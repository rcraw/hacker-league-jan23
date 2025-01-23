#!/bin/bash

# Cyberpunk colors
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to display the menu
show_menu() {
    clear
    echo -e """
${CYAN}╔══════════════════════════════════════════════════════════════════╗
║             NEURAL NETWORK CONTROL INTERFACE v2.0                ║
╚══════════════════════════════════════════════════════════════════╝${NC}

${MAGENTA}▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
        🧠 DUAL CORE AI SYSTEM - COMMAND CENTER 🧠
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀${NC}

${YELLOW}[1]${NC} 📦 INSTALL NEURAL DEPENDENCIES
${YELLOW}[2]${NC} 🚀 ACTIVATE AI CORES (DEFAULT MODE)
${YELLOW}[3]${NC} 🎯 ACTIVATE AI CORES (CUSTOM MODE)
${YELLOW}[4]${NC} 💤 ENTER SLEEP MODE

${CYAN}▮${NC} Enter command: """
}

# Function to get custom parameters
get_custom_params() {
    echo -e """
${CYAN}╔══════════════════════════════════════════════════════════════════╗
║                   NEURAL PARAMETER CONFIG                       ║
╚══════════════════════════════════════════════════════════════════╝${NC}
"""
    echo -e "${YELLOW}[SYS]${NC} Enter your prompt (or press Enter for default): "
    read custom_prompt
    echo -e "${YELLOW}[SYS]${NC} Select task type:
${YELLOW}[1]${NC} research
${YELLOW}[2]${NC} execute
${YELLOW}[3]${NC} both (default)
${CYAN}▮${NC} Enter choice: "
    read task_choice
    
    case $task_choice in
        1) task_type="research";;
        2) task_type="execute";;
        *) task_type="both";;
    esac

    if [ -z "$custom_prompt" ]; then
        PROMPT_ARG=""
    else
        PROMPT_ARG="--prompt \"$custom_prompt\""
    fi
    
    TASK_ARG="--task $task_type"
}

# Function to install dependencies
install_dependencies() {
    echo -e """
${CYAN}╔══════════════════════════════════════════════════════════════════╗
║                NEURAL PACKAGE INSTALLATION                       ║
╚══════════════════════════════════════════════════════════════════╝${NC}
    """
    echo -e "${YELLOW}⚡ Initializing dependency scanner...${NC}"
    if poetry lock; then
        if poetry install; then
            echo -e """
${GREEN}╔══════════════════════════════════════════════════════════════════╗
║             🎉 NEURAL PACKAGES SYNCHRONIZED 🎉                   ║
╚══════════════════════════════════════════════════════════════════╝${NC}
"""
        else
            echo -e """
${RED}╔══════════════════════════════════════════════════════════════════╗
║             ⚠️ NEURAL PACKAGE SYNC FAILED ⚠️                    ║
╚══════════════════════════════════════════════════════════════════╝${NC}
"""
        fi
    else
        echo -e """
${RED}╔══════════════════════════════════════════════════════════════════╗
║             ⚠️ LOCK FILE GENERATION FAILED ⚠️                   ║
╚══════════════════════════════════════════════════════════════════╝${NC}
"""
    fi
    read -p "Press Enter to continue..."
}

# Function to run the agent
run_agent() {
    local mode=$1
    if [ "$mode" = "custom" ]; then
        get_custom_params
    else
        PROMPT_ARG=""
        TASK_ARG=""
    fi

    echo -e """
${CYAN}╔══════════════════════════════════════════════════════════════════╗
║                   NEURAL CORE ACTIVATION                        ║
╚══════════════════════════════════════════════════════════════════╝${NC}

${MAGENTA}▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
        🔄 INITIALIZING QUANTUM PROCESSORS...
        📡 ESTABLISHING NEURAL LINKS...
        🌐 CONNECTING TO THE GRID...
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀${NC}

${YELLOW}[SYS]${NC} Press ${RED}Ctrl+C${NC} to initiate emergency shutdown\n"""
    if eval "poetry run python src/hello_world/main.py $PROMPT_ARG $TASK_ARG"; then
        echo -e """
${GREEN}╔══════════════════════════════════════════════════════════════════╗
║             🎯 MISSION COMPLETED SUCCESSFULLY 🎯                ║
╚══════════════════════════════════════════════════════════════════╝${NC}
"""
    else
        echo -e """
${YELLOW}╔══════════════════════════════════════════════════════════════════╗
║             🛑 NEURAL CORES DEACTIVATED 🛑                      ║
╚══════════════════════════════════════════════════════════════════╝${NC}
"""
    fi
    read -p "Press Enter to continue..."
}

# Main loop
while true; do
    show_menu
    read choice
    case $choice in
        1)
            install_dependencies
            ;;
        2)
            run_agent "default"
            ;;
        3)
            run_agent "custom"
            ;;
        4)
            echo -e """
${CYAN}╔══════════════════════════════════════════════════════════════════╗
║                    ENTERING SLEEP MODE                          ║
╚══════════════════════════════════════════════════════════════════╝${NC}

${MAGENTA}▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
        💤 NEURAL CORES POWERING DOWN...
        📴 DISCONNECTING FROM THE GRID...
        👋 GOODBYE, USER...
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀${NC}
"""
            exit 0
            ;;
        *)
            echo -e """
${RED}╔══════════════════════════════════════════════════════════════════╗
║             ⚠️ INVALID COMMAND DETECTED ⚠️                      ║
╚══════════════════════════════════════════════════════════════════╝${NC}
"""
            read -p "Press Enter to continue..."
            ;;
    esac
done
