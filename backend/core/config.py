"""
core/config.py  –  Shared configuration, API keys, and logging setup.
All routers import from here. Never import from main.py in routers.
"""

import os
import logging
from dotenv import load_dotenv

load_dotenv()


# ── Logging ──────────────────────────────────────────────────────────────────
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s"
)
logger = logging.getLogger(__name__)

# ── API Keys ──────────────────────────────────────────────────────────────────
GROQ_API_KEY        = os.getenv("GROQ_API_KEY", "")
GROQ_MODEL          = os.getenv("GROQ_MODEL", "llama-3.3-70b-versatile")
GNEWS_API_KEY       = os.getenv("GNEWS_API_KEY", "")
OPENWEATHER_API_KEY = os.getenv("OPENWEATHER_API_KEY", "")

# ── Upload folder ─────────────────────────────────────────────────────────────
UPLOAD_FOLDER = "uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

# ── Database ──────────────────────────────────────────────────────────────────
# PostgreSQL connection string from Supabase
# Format: postgresql://postgres:PASSWORD@db.xxxx.supabase.co:5432/postgres
DATABASE_URL = os.getenv("DATABASE_URL", "")

if not DATABASE_URL:
    raise ValueError("DATABASE_URL environment variable is not set!")