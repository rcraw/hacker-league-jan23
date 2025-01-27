# Advanced Web Research System with CrewAI and Gemini

A sophisticated web research system built with CrewAI and Google's Gemini API, featuring specialized agents for research, data processing, and insight analysis.

## Features

### 1. Modular Agent System
- **Web Researcher**: Gathers and validates information from web sources
- **Data Processor**: Structures and enriches raw research data
- **Insight Analyzer**: Synthesizes data into actionable insights

### 2. Advanced Research Tools
- Web search with result validation
- Fact checking against trusted sources
- Source credibility assessment
- Structured data extraction

### 3. ReACT Methodology Integration
- Reasoning and Acting framework
- Structured thought process
- Action validation
- Progress tracking

### 4. Quality Assurance
- Source validation
- Fact verification
- Credibility scoring
- Data quality checks

## Setup

1. **Clone the Repository**
```bash
git clone <repository-url>
cd <repository-name>
```

2. **Install Dependencies**
```bash
poetry install
```

3. **Environment Configuration**
- Copy `env.sample` to `.env`
- Configure required API keys and settings:
  ```
  GOOGLE_API_KEY=your_google_api_key_here
  ```

4. **Verify Installation**
```bash
poetry run pytest
```

## Usage

### Basic Research Task
```python
from hello_world.crew import HelloWorldCrew

# Initialize the crew
crew = HelloWorldCrew()

# Run a research task
crew.run(
    prompt="Research the latest developments in quantum computing",
    task_type="both"  # Options: "research", "execute", "analyze", "both"
)
```

### Custom Agent Configuration
```python
# Agents are configured via YAML files in src/hello_world/agents/
# See examples in:
# - research/web_researcher.yaml
# - execution/data_processor.yaml
# - analysis/insight_analyzer.yaml
```

## Agent Catalog

The system uses a tagged agent catalog system for flexible agent deployment:

### Categories
- Research
- Execution
- Analysis
- Web
- Data
- Insights

### Capabilities
- Web scraping
- Fact validation
- Source verification
- Data synthesis
- Pattern recognition
- Insight generation

## Architecture

```
src/hello_world/
├── agents/                 # Agent configurations
│   ├── metadata.yaml      # Agent catalog metadata
│   ├── research/          # Research agents
│   ├── execution/         # Execution agents
│   └── analysis/          # Analysis agents
├── tools/                 # Custom tools
│   └── custom_tool.py     # Tool implementations
└── crew.py               # Main crew implementation
```

## Development

### Adding New Agents
1. Create agent configuration in appropriate directory
2. Update metadata.yaml with tags
3. Implement any required tools
4. Update tests

### Adding New Tools
1. Extend CustomTool in custom_tool.py
2. Add tool configuration to agent YAML
3. Update tests

## Testing

```bash
# Run all tests
poetry run pytest

# Run specific test file
poetry run pytest tests/test_specific.py

# Run with coverage
poetry run pytest --cov=src
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit changes
4. Create pull request

## License

[Your License Here]

## Credits

Built with:
- [CrewAI](https://github.com/joaomdmoura/crewAI)
- [Google Gemini API](https://ai.google.dev/)
- [LangChain](https://github.com/hwchase17/langchain)
