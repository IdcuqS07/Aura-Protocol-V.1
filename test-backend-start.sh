#!/bin/bash

cd "$(dirname "$0")/backend"
source venv/bin/activate

echo "Testing backend startup..."
python -c "
import sys
try:
    from server import app
    print('✅ Server module loaded successfully')
    sys.exit(0)
except Exception as e:
    print(f'❌ Error loading server: {e}')
    sys.exit(1)
"

if [ $? -eq 0 ]; then
    echo ""
    echo "Backend is ready to start!"
    echo "Run: ./start-backend.sh"
else
    echo ""
    echo "Fix errors above before starting backend"
fi
