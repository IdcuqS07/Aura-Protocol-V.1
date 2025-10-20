#!/bin/bash

echo "🚀 Starting Aura Protocol with Polygon Integration..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if MongoDB is running
echo -e "${BLUE}📊 Checking MongoDB status...${NC}"
if brew services list | grep -q "mongodb-community.*started"; then
    echo -e "${GREEN}✅ MongoDB is running${NC}"
else
    echo -e "${YELLOW}⚠️  Starting MongoDB...${NC}"
    brew services start mongodb/brew/mongodb-community
    sleep 3
fi

# Install backend dependencies
echo -e "${BLUE}📦 Installing backend dependencies...${NC}"
cd backend
if [ ! -d "venv" ]; then
    echo -e "${YELLOW}Creating virtual environment...${NC}"
    python3 -m venv venv
fi

source venv/bin/activate
pip install -r requirements.txt

# Install smart contract dependencies
echo -e "${BLUE}🔗 Installing smart contract dependencies...${NC}"
cd ../contracts
if [ ! -d "node_modules" ]; then
    npm install
fi

# Compile smart contracts
echo -e "${BLUE}⚙️  Compiling smart contracts...${NC}"
npx hardhat compile

# Install frontend dependencies
echo -e "${BLUE}🎨 Installing frontend dependencies...${NC}"
cd ../frontend
if [ ! -d "node_modules" ]; then
    yarn install
fi

# Start backend server
echo -e "${BLUE}🔧 Starting backend server...${NC}"
cd ../backend
source venv/bin/activate
uvicorn server:app --reload --host 0.0.0.0 --port 9000 &
BACKEND_PID=$!

# Wait for backend to start
sleep 5

# Start frontend
echo -e "${BLUE}🌐 Starting frontend...${NC}"
cd ../frontend
yarn start &
FRONTEND_PID=$!

# Display information
echo -e "${GREEN}"
echo "🎉 Aura Protocol is now running with Polygon integration!"
echo ""
echo "📱 Frontend: http://localhost:3000"
echo "🔧 Backend API: http://localhost:9000"
echo "📚 API Docs: http://localhost:9000/docs"
echo ""
echo "🔗 Blockchain Features:"
echo "   • ZK-ID Badge System"
echo "   • Proof of Uniqueness"
echo "   • Civic Integration"
echo "   • Worldcoin Integration"
echo ""
echo "🛠️  Available Routes:"
echo "   • /zk-verification - Identity verification"
echo "   • /proof-uniqueness - Generate uniqueness proof"
echo "   • /zk-badges - View your badges"
echo ""
echo "⚠️  Note: Update .env files with your private keys for full blockchain functionality"
echo ""
echo "Press Ctrl+C to stop all services"
echo -e "${NC}"

# Function to cleanup on exit
cleanup() {
    echo -e "${YELLOW}🛑 Stopping services...${NC}"
    kill $BACKEND_PID 2>/dev/null
    kill $FRONTEND_PID 2>/dev/null
    echo -e "${GREEN}✅ All services stopped${NC}"
    exit 0
}

# Trap Ctrl+C
trap cleanup INT

# Wait for processes
wait