#!/bin/bash

cd "$(dirname "$0")/backend"

# Activate venv
source venv/bin/activate

# Start backend
echo "Starting Aura Protocol Backend..."
uvicorn server:app --reload --host 0.0.0.0 --port 9000
