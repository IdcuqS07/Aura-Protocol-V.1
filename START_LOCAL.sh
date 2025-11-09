#!/bin/bash

echo "🚀 Starting Aura Protocol Locally"
echo ""

# Check MongoDB
if pgrep -x mongod > /dev/null; then
    echo "✅ MongoDB running"
else
    echo "❌ MongoDB not running"
    echo "Starting MongoDB..."
    brew services start mongodb-community
    sleep 3
fi

# Start Backend
echo ""
echo "📡 Starting Backend (port 9000)..."
cd backend
source venv/bin/activate 2>/dev/null || python3 -m venv venv && source venv/bin/activate
pip install -q -r requirements.txt
uvicorn server:app --reload --host 0.0.0.0 --port 9000 &
BACKEND_PID=$!
echo "Backend PID: $BACKEND_PID"

# Wait for backend
sleep 5

# Start Frontend
echo ""
echo "🎨 Starting Frontend (port 3000)..."
cd ../frontend
yarn start &
FRONTEND_PID=$!
echo "Frontend PID: $FRONTEND_PID"

echo ""
echo "✅ Services started!"
echo ""
echo "📍 Frontend: http://localhost:3000"
echo "📍 Backend:  http://localhost:9000"
echo "📍 API Docs: http://localhost:9000/docs"
echo ""
echo "Press Ctrl+C to stop all services"
echo ""

# Wait for Ctrl+C
trap "echo ''; echo 'Stopping services...'; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit" INT
wait
