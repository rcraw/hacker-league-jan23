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
${YELLOW}[2]${NC} 🚀 ACTIVATE AI CORES
${YELLOW}[3]${NC} 💤 ENTER SLEEP MODE

${CYAN}▮${NC} Enter command: """
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

# Function to get user prompt
get_prompt() {
    echo -e """
${CYAN}╔══════════════════════════════════════════════════════════════════╗
║                   NEURAL PROMPT INTERFACE                       ║
╚══════════════════════════════════════════════════════════════════╝${NC}

${MAGENTA}▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
        💭 ENTER YOUR TASK OR QUESTION BELOW
        🤖 AI CORES WILL ANALYZE AND EXECUTE
        ⚡ PRESS ENTER TO BEGIN PROCESSING
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀${NC}

${YELLOW}[INPUT]${NC} Enter your prompt: "
    read -r user_prompt
    echo "$user_prompt"
}

# Function to run the agent
run_agent() {
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
    
    prompt=$(get_prompt)
    if REACT_PROMPT="$prompt" poetry run python src/hello_world/main.py; then
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
            run_agent
            ;;
        3)
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
