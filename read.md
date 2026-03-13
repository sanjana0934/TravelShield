# TravelShield 🛡️
> Kerala Tourism Safety & Travel Planning App

---

## Project Structure
```
TravelShield/
├── backend/          # FastAPI Python backend
│   ├── main.py
│   ├── core/
│   ├── routers/
│   ├── models/       # ML models (shared via Drive — see below)
│   └── .env          # API keys (never pushed — create locally)
└── travel_app/       # Flutter frontend
```

---

## Team Setup Guide

### Prerequisites
- Python 3.11 → https://www.python.org/downloads/release/python-3110/
- Flutter SDK → https://docs.flutter.dev/get-started/install
- Git

---

### 1. Clone the repo
```bash
git clone https://github.com/sanjana0934/TravelShield.git
cd TravelShield
```

---

### 2. Backend Setup
```bash
cd backend

# Create virtual environment with Python 3.11
py -3.11 -m venv tf_env

# Activate (Windows)
tf_env\Scripts\activate

# Activate (Mac/Linux)
source tf_env/bin/activate

# Install dependencies
pip install -r requirements.txt
```

#### Create your `.env` file (ask team lead for keys)
```
# backend/.env
GROQ_API_KEY=your_key_here
GROQ_MODEL=llama-3.3-70b-versatile
GNEWS_API_KEY=your_key_here
```

#### Get ML model files
- Download `qr_model.pkl` and `currency_cnn_model.h5` from the shared Google Drive link (ask team lead)
- Place them in `backend/models/`

#### Run the backend
```bash
uvicorn main:app --reload
# Server runs at http://localhost:8000
# API docs at http://localhost:8000/docs
```

---

### 3. Flutter Setup
```bash
cd travel_app
flutter pub get
flutter run -d chrome     # Web
flutter run -d android    # Android (emulator or device)
```

---

## API Base URLs
| Environment | URL |
|---|---|
| Web / localhost | `http://localhost:8000` |
| Android emulator | `http://10.0.2.2:8000` |
| Physical device | `http://<your-wifi-ip>:8000` |

---

## Branching Strategy
```
main          ← stable, working code only
dev           ← active development, merge PRs here
feature/xxx   ← individual features (branch off dev)
fix/xxx       ← bug fixes
```

### Workflow
```bash
# Always branch from dev
git checkout dev
git pull origin dev
git checkout -b feature/your-feature-name

# Work, commit, push
git add .
git commit -m "feat: describe what you did"
git push origin feature/your-feature-name

# Then open a Pull Request → dev on GitHub
```

---

## Environment Files (NEVER push these)
| File | What it contains |
|---|---|
| `backend/.env` | API keys (GROQ, GNews, OpenWeather) |
| `backend/database.db` | Local SQLite database |
| `backend/uploads/` | Uploaded images |
| `backend/models/` | ML model files |

Share API keys and model files via a **private channel** (WhatsApp/Telegram/Drive) — never commit them.

---

## Contributors
- [@sanjana0934](https://github.com/sanjana0934)