#!/bin/bash

# Aura Protocol - Start Local Development
# This will start both backend and frontend for browser testing

echo "🚀 Starting Aura Protocol Local Development..."
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if MongoDB is running
echo -e "${BLUE}Checking MongoDB...${NC}"
if ! pgrep -x "mongod" > /dev/null; then
    echo -e "${YELLOW}MongoDB not running. Starting MongoDB...${NC}"
    brew services start mongodb-community 2>/dev/null || brew services start mongodb/brew/mongodb-community
    sleep 3
fi
echo -e "${GREEN}✓ MongoDB is running${NC}"
echo ""

# Start Backend
echo -e "${BLUE}Starting Backend (Port 9000)...${NC}"
cd backend

# Check if venv exists
if [ ! -d "venv" ]; then
    echo -e "${YELLOW}Creating virtual environment...${NC}"
    python3 -m venv venv
fi

# Activate venv and install dependencies
source venv/bin/activate
pip install -q -r requirements.txt

# Start backend in background
echo -e "${GREEN}✓ Backend starting at http://localhost:9000${NC}"
uvicorn server:app --reload --host 0.0.0.0 --port 9000 > ../backend.log 2>&1 &
BACKEND_PID=$!
echo $BACKEND_PID > ../backend.pid
echo ""

# Wait for backend to start
sleep 5

# Start Frontend
echo -e "${BLUE}Starting Frontend (Port 3000)...${NC}"
cd ../frontend

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}Installing frontend dependencies...${NC}"
    yarn install
fi

# Start frontend
echo -e "${GREEN}✓ Frontend starting at http://localhost:3000${NC}"
echo ""

# Open browser
sleep 3
echo -e "${GREEN}🌐 Opening browser...${NC}"
open http://localhost:3000

# Start frontend (this will block)
yarn start

# Cleanup on exit
trap "kill $BACKEND_PID 2>/dev/null; rm -f ../backend.pid" EXIT
