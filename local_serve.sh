#!/bin/bash
nohup ollama serve &
# Get the PID of the last command (ollama serve)
OLLAMA_PID=$!

# Print the PID (optional)
echo "Ollama server is running in the background with PID: $OLLAMA_PID"