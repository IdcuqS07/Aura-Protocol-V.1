#!/bin/bash

# Check Passport Data in MongoDB
# Usage: bash check-passport-data.sh

echo "🔍 Checking Passport Data..."
echo ""

ssh root@159.65.134.137 << 'ENDSSH'

echo "1️⃣ Check MongoDB is running..."
systemctl status mongod --no-pager | head -5

echo ""
echo "2️⃣ Count passports in database..."
mongosh --quiet --eval "use aura_protocol; db.passports.countDocuments()"

echo ""
echo "3️⃣ List all passports..."
mongosh --quiet --eval "use aura_protocol; db.passports.find({}, {user_id: 1, wallet_address: 1, credit_score: 1, badge_count: 1}).limit(10)" | head -30

echo ""
echo "4️⃣ Count badges..."
mongosh --quiet --eval "use aura_protocol; db.badges.countDocuments()"

echo ""
echo "5️⃣ Count demo badges..."
mongosh --quiet --eval "use aura_protocol; db.demo_badges.countDocuments()"

echo ""
echo "6️⃣ List recent badges..."
mongosh --quiet --eval "use aura_protocol; db.badges.find({}, {wallet_address: 1, badge_type: 1, token_id: 1}).sort({issued_at: -1}).limit(5)" | head -20

ENDSSH

echo ""
echo "✅ Check complete!"
