#!/bin/bash

echo "🔄 Phase 2: Restart Backend & Test Integration"
echo "=============================================="
echo ""

echo "⚠️  MANUAL STEP REQUIRED:"
echo "1. Go to backend terminal"
echo "2. Press Ctrl+C to stop server"
echo "3. Run: uvicorn server:app --reload --port 9000"
echo "4. Wait for 'Application startup complete'"
echo "5. Come back here and press Enter"
echo ""
read -p "Press Enter when backend is restarted..."

echo ""
echo "✅ Backend should be restarted"
echo ""

# Wait a bit for backend to fully start
sleep 2

# Test backend is running
echo "📡 Testing backend..."
if curl -s http://localhost:9000/api/ > /dev/null; then
    echo "✅ Backend is running"
else
    echo "❌ Backend not responding"
    exit 1
fi
echo ""

# Run Phase 2 integration test
echo "🧪 Running Phase 2 Integration Test..."
echo ""
bash test-phase2.sh

echo ""
echo "📝 Next Steps:"
echo "1. Check if passport was created"
echo "2. Go to http://localhost:3000/passport"
echo "3. Verify credit score and badge count"
echo ""
echo "If test passed, Phase 2 is complete! 🎉"
