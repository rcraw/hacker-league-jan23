from crewai import Agent, Crew, Process, Task
from hello_world.tools.custom_tool import CustomTool
import yaml
from dotenv import load_dotenv
import os
import json
import asyncio
import google.generativeai as genai
from pathlib import Path

load_dotenv()  # Load environment variables from .env file

# Configure Google Gemini API
genai.configure(api_key=os.getenv('GOOGLE_API_KEY'))

class AgentCatalog:
    def __init__(self, agents_dir="src/hello_world/agents"):
        self.agents_dir = Path(agents_dir)
        self.metadata = self._load_metadata()
        self.agents = {}
        self._load_agents()

    def _load_metadata(self):
        with open(self.agents_dir / "metadata.yaml", 'r') as f:
            return yaml.safe_load(f)

    def _load_agents(self):
        """Load all agent configurations from the catalog"""
        for agent_type in ['research', 'execution', 'analysis']:
            agent_dir = self.agents_dir / agent_type
            if agent_dir.exists():
                for config_file in agent_dir.glob("*.yaml"):
                    with open(config_file, 'r') as f:
                        config = yaml.safe_load(f)
                        self.agents[config['name']] = config

    def get_agent_by_tag(self, tag):
        """Retrieve agent configuration by tag"""
        for agent_name, config in self.agents.items():
            if tag in self.metadata['agent_tags'].get(agent_name, {}).get('categories', []):
                return config
        return None

    def get_agent_by_capability(self, capability):
        """Retrieve agent configuration by capability"""
        for agent_name, config in self.agents.items():
            if capability in self.metadata['agent_tags'].get(agent_name, {}).get('capabilities', []):
                return config
        return None

async def stream_gemini_response(prompt, model_name="gemini-pro", progress_callback=None):
    """Stream responses from Gemini with progress tracking"""
    model = genai.GenerativeModel(model_name)
    
    response = model.generate_content(
        prompt,
        generation_config=genai.types.GenerationConfig(
            temperature=0.7,
            candidate_count=1,
            stop_sequences=None,
            max_output_tokens=2048,
            top_p=0.8,
            top_k=40,
        ),
        stream=True
    )

    full_response = ""
    async for chunk in response:
        if chunk.text:
            print(chunk.text, end='', flush=True)
            full_response += chunk.text
            if progress_callback:
                await progress_callback(chunk.text)
    
    return full_response

class HelloWorldCrew:
    def __init__(self):
        self.agent_catalog = AgentCatalog()
        self.validation_status = {"reasoning": [], "actions": []}
        self.progress_tracker = {"current_step": 0, "total_steps": 0, "status": ""}

    def validate_reasoning(self, reasoning_step):
        """Validate each reasoning step in the ReACT process"""
        validation_result = {
            "step": reasoning_step,
            "valid": True,
            "feedback": []
        }
        
        if not reasoning_step.get("thought"):
            validation_result["valid"] = False
            validation_result["feedback"].append("Missing thought process")
        
        self.validation_status["reasoning"].append(validation_result)
        return validation_result

    def validate_action(self, action_step):
        """Validate each action before execution"""
        validation_result = {
            "step": action_step,
            "valid": True,
            "feedback": []
        }
        
        if not action_step.get("action"):
            validation_result["valid"] = False
            validation_result["feedback"].append("Missing action definition")
            
        self.validation_status["actions"].append(validation_result)
        return validation_result

    def track_progress(self, step_type, status):
        """Track progress of ReACT methodology execution"""
        self.progress_tracker["current_step"] += 1
        self.progress_tracker["status"] = status
        
        progress = f"""
▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
📊 Progress Update:
➤ Step {self.progress_tracker["current_step"]}: {step_type}
➤ Status: {status}
▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
"""
        print(progress)

    def _create_agent_from_config(self, agent_type):
        """Create a CrewAI agent from catalog configuration"""
        config = None
        
        if agent_type == "researcher":
            config = self.agent_catalog.get_agent_by_tag("research")
        elif agent_type == "processor":
            config = self.agent_catalog.get_agent_by_tag("execution")
        elif agent_type == "analyzer":
            config = self.agent_catalog.get_agent_by_tag("analysis")
            
        if not config:
            raise ValueError(f"No configuration found for agent type: {agent_type}")
            
        return Agent(
            role=config['role'],
            goal=config['goal'],
            backstory=config['backstory'],
            llm_model=config['model']['name'],
            verbose=True,
            tools=[CustomTool()]
        )
            
    async def run_with_streaming(self, prompt="Tell me about yourself", task_type="both"):
        """Run crew with streaming responses using enhanced ReACT methodology"""
        self.progress_tracker["total_steps"] = 4
        
        if task_type in ["research", "both"]:
            await self._run_researcher(prompt)
            
        if task_type in ["execute", "both"]:
            await self._run_processor(prompt)
            
        if task_type == "analyze":
            await self._run_analyzer(prompt)
            
        return True
            
    async def _run_analyzer(self, prompt):
        """Run the analyzer agent"""
        analyzer = self._create_agent_from_config("analyzer")
        config = self.agent_catalog.get_agent_by_tag("analysis")
            
        analyzer_messages = [{
            "role": "system",
            "content": self._get_agent_prompt(config, prompt)
        }]
        
        self.track_progress("Analysis Initialization", "Starting performance analysis")
        
        print("""
╔══════════════════════════════════════════════════════════════════╗
║  📊 INITIALIZING PERFORMANCE ANALYZER v1.0 - GEMINI CORE        ║
╚══════════════════════════════════════════════════════════════════╝
        
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
🔄 LOADING ANALYSIS CONFIGURATION...
📡 METRIC COLLECTION: ACTIVE
🧮 OPTIMIZATION ENGINE: ONLINE
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

[SYS]: Beginning Performance Analysis...
""")
        await stream_gemini_response(analyzer_messages[0]["content"])
        
    async def _run_researcher(self, prompt):
        """Run the researcher agent"""
        researcher = self._create_agent_from_config("researcher")
        config = self.agent_catalog.get_agent_by_tag("research")
        
        researcher_messages = [{
            "role": "system",
            "content": self._get_agent_prompt(config, prompt)
        }]
        
        self.track_progress("Research Initialization", "Starting ReACT analysis")
        
        print("""
╔══════════════════════════════════════════════════════════════════╗
║  🤖 INITIALIZING RESEARCH ANALYST v2.0 - GEMINI CORE LOADED     ║
╚══════════════════════════════════════════════════════════════════╝
        
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
🔄 ACTIVATING ReACT PROTOCOL...
📡 NEURAL INTERFACE ONLINE
🧠 COGNITIVE SYSTEMS ENGAGED
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

[SYS]: Initiating ReACT Methodology Analysis...
""")
        await stream_gemini_response(researcher_messages[0]["content"])
        
    async def _run_processor(self, prompt):
        """Run the processor agent"""
        processor = self._create_agent_from_config("processor")
        config = self.agent_catalog.get_agent_by_tag("execution")
        
        processor_messages = [{
            "role": "system",
            "content": self._get_agent_prompt(config, prompt)
        }]
        
        self.track_progress("Processing Phase", "Starting data processing")
        
        print("""
╔══════════════════════════════════════════════════════════════════╗
║  ⚡ ACTIVATING DATA PROCESSOR v1.5 - GEMINI CORE INITIALIZED    ║
║     WITH ReACT VALIDATION PROTOCOLS                             ║
╚══════════════════════════════════════════════════════════════════╝

▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
🎯 PROCESSING PROTOCOLS LOADED
⚙️ SYSTEM OPTIMIZATION: ENABLED
🔧 TOOL INTERFACE: ACTIVE
✅ ReACT VALIDATION: ONLINE
🔍 QUALITY CHECKS: READY
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

[SYS]: Beginning Processing Sequence with ReACT Validation...
""")
        await stream_gemini_response(processor_messages[0]["content"])

    def _get_agent_prompt(self, config, user_prompt):
        """Generate agent-specific prompt based on configuration"""
        base_prompt = f"""You are a {config['role']} with the goal: {config['goal']}.
Use ReACT (Reasoning and Acting) methodology with the following structure:

1. Thought: {config['react_config']['components']['thought']['structure']}
2. Action: Specify the action to take
3. Observation: Document results
4. {config['react_config']['components'].get('reflection', {}).get('name', 'Reflection')}: Analyze and plan next steps

Format your response using this template:
[THOUGHT] Your reasoning here...
[ACTION] Your proposed action...
[OBSERVATION] Results and findings...
[{config['react_config']['components'].get('reflection', {}).get('name', 'REFLECTION')}] Analysis and next steps...

User Prompt: {user_prompt}
"""
        return base_prompt

    def run(self, prompt="Tell me about yourself", task_type="both"):
        """Run crew synchronously"""
        try:
            return asyncio.run(self.run_with_streaming(prompt=prompt, task_type=task_type))
        except KeyboardInterrupt:
            print("""
╔══════════════════════════════════════════════════════════════════╗
║  🛑 EMERGENCY SHUTDOWN SEQUENCE INITIATED                        ║
╚══════════════════════════════════════════════════════════════════╝
⚠️ Saving neural state...
💾 Preserving memory banks...
🔌 Powering down cores...
""")
            return None
        except Exception as e:
            print(f"""
╔══════════════════════════════════════════════════════════════════╗
║  ⚠️ SYSTEM MALFUNCTION DETECTED                                 ║
╚══════════════════════════════════════════════════════════════════╝
🔍 Error Analysis:
{str(e)}
🔧 Initiating recovery protocols...
""")
            return None
