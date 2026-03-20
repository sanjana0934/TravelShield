"""
core/security.py  –  Password hashing, JWT tokens, rate limiting.
Install deps:  pip install passlib[bcrypt] python-jose[cryptography]
"""

from datetime import datetime, timedelta
from passlib.context import CryptContext
from jose import JWTError, jwt
from core.database import get_db

# ── Config ────────────────────────────────────────────────────────────────────
# IMPORTANT: Change SECRET_KEY to a long random string before deploying!
# Generate one with: python -c "import secrets; print(secrets.token_hex(32))"
SECRET_KEY      = "0f96a38abbba43eaaadb8086254843e60169f340cd23b4887622e254cee3fa81"
ALGORITHM       = "HS256"
TOKEN_EXPIRE_HOURS = 24          # auto logout after 24 hours

MAX_ATTEMPTS    = 5              # max failed logins
LOCKOUT_MINUTES = 15             # lockout duration

# ── Password hashing (bcrypt) ─────────────────────────────────────────────────
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def hash_password(plain: str) -> str:
    """Hash a plain-text password using bcrypt."""
    return pwd_context.hash(plain)

def verify_password(plain: str, hashed: str) -> bool:
    """Verify a plain-text password against a bcrypt hash."""
    return pwd_context.verify(plain, hashed)


# ── JWT tokens ────────────────────────────────────────────────────────────────

def create_access_token(data: dict) -> str:
    """Create a signed JWT token that expires after TOKEN_EXPIRE_HOURS."""
    payload = data.copy()
    payload["exp"] = datetime.utcnow() + timedelta(hours=TOKEN_EXPIRE_HOURS)
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)

def decode_token(token: str):
    """Decode JWT. Returns email string or None if invalid/expired."""
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload.get("sub")   # "sub" = email
    except JWTError:
        return None


# ── Rate limiting (stored in SQLite) ─────────────────────────────────────────

def check_rate_limit(email: str):
    """
    Returns (blocked: bool, wait_minutes: int).
    Blocked = True if too many failed attempts in the last LOCKOUT_MINUTES.
    """
    with get_db() as conn:
        cursor = conn.cursor()
        cutoff = (datetime.utcnow() - timedelta(minutes=LOCKOUT_MINUTES)).isoformat()
        cursor.execute("""
            SELECT COUNT(*) FROM login_attempts
            WHERE email=? AND attempted_at > ? AND success=0
        """, (email, cutoff))
        count = cursor.fetchone()[0]

    if count >= MAX_ATTEMPTS:
        return True, LOCKOUT_MINUTES
    return False, 0

def record_failed_attempt(email: str):
    """Record a failed login attempt."""
    with get_db() as conn:
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO login_attempts (email, attempted_at, success)
            VALUES (?, ?, 0)
        """, (email, datetime.utcnow().isoformat()))
        conn.commit()

def clear_failed_attempts(email: str):
    """Clear failed attempts after successful login."""
    with get_db() as conn:
        cursor = conn.cursor()
        cursor.execute("DELETE FROM login_attempts WHERE email=?", (email,))
        conn.commit()