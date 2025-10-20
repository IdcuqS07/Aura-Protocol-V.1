# Aura Protocol

Universal Trust in a Trustless World - Polygon ZK-ID Credit Layer

## Overview

Aura Protocol is a decentralized credibility layer that builds ZK Credit Passports — on-chain financial identities that verify reputation without revealing personal data.

## Tech Stack

- **Frontend**: React, TailwindCSS, shadcn/ui
- **Backend**: FastAPI (Python)
- **Database**: MongoDB
- **Blockchain**: Polygon

## Prerequisites

- Python 3.8+
- Node.js 18+
- MongoDB
- Yarn

## Installation

### Backend Setup

```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Frontend Setup

```bash
cd frontend
yarn install
```

## Configuration

### Backend (.env)

```
MONGO_URL=mongodb://localhost:27017
DB_NAME=aura_protocol
CORS_ORIGINS=*
```

### Frontend (.env)

```
REACT_APP_BACKEND_URL=http://localhost:9000
```

## Running the Application

### Start MongoDB

```bash
brew services start mongodb/brew/mongodb-community
```

### Start Backend

```bash
cd backend
source venv/bin/activate
uvicorn server:app --reload --host 0.0.0.0 --port 9000
```

### Start Frontend

```bash
cd frontend
yarn start
```

Access the application at `http://localhost:3000`

## Features

- **ZK-ID Badge**: Unique identity proof with Zero-Knowledge Proofs
- **Credit Passport**: Soulbound NFT representing on-chain financial reputation
- **Proof-as-a-Service**: Real-time credibility verification API
- **AI Risk Oracle**: AI-powered risk assessment for lending

## API Endpoints

- `GET /api/` - API info
- `POST /api/users` - Create user
- `GET /api/users/{user_id}` - Get user
- `POST /api/users/{user_id}/verify` - Verify identity
- `POST /api/passports` - Create credit passport
- `GET /api/passports/{user_id}` - Get passport
- `GET /api/badges/{user_id}` - Get user badges
- `GET /api/analytics` - Get analytics data

## License

MIT
