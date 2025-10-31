#!/bin/bash
# Quick setup script for .env file

cat > .env << EOF
# Database
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/brix_nutrition

# JWT
JWT_SECRET=8JYHts6Qw3lbxLcFICvdGUjxxK8SzVHD3o9JQI8HJaM=
API_TOKEN_SALT=OmiKMPL64DkXIpEjWQ/3oyPiU1WwVH8EKB05OwItSsM=
JWT_EXPIRES_IN=7d

# Server
NODE_ENV=development
HOST=0.0.0.0
PORT=3000
LOG_LEVEL=info

# CORS
CORS_ORIGIN=http://localhost:3001,http://localhost:3000
FRONTEND_URL=http://localhost:3001

# Rate Limiting
RATE_LIMIT_MAX=100
RATE_LIMIT_WINDOW_MS=60000

# Mock mode (для разработки без реальных API)
USE_MOCK_EMAIL=true
USE_MOCK_SMS=true
EOF

echo "✅ .env file created successfully!"
echo "📝 You can now run: npm run dev"

