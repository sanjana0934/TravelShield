"""
routers/auth.py  -  User authentication: signup, login, profile.
"""

import re
from datetime import datetime
from fastapi import APIRouter
from core.database import get_db

router = APIRouter(tags=["Auth"])


# -- Password validator -------------------------------------------------------

def validate_password(password: str):
    if len(password) < 8:
        return "Password must be at least 8 characters."
    if not re.search(r'[A-Z]', password):
        return "Must include an uppercase letter."
    if not re.search(r'[0-9]', password):
        return "Must include a number."
    if not re.search(r'[#@!$%^&*]', password):
        return "Must include a special character (#@!$%^&*)."
    return None


# -- Signup -------------------------------------------------------------------

@router.post("/signup")
def signup(data: dict):
    try:
        if not re.match(r'^[\w\.\+\-]+@[\w\-]+\.[a-zA-Z]{2,}$', data["email"]):
            return {"status": "error", "message": "Please enter a valid email address."}

        error = validate_password(data["password"])
        if error:
            return {"status": "error", "message": error}

        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT 1 FROM users WHERE email=?", (data["email"],))
            if cursor.fetchone():
                return {"status": "error", "message": "An account with this email already exists."}
            cursor.execute("""
            INSERT INTO users(
                first_name, middle_name, last_name, gender, dob, phone,
                emergency_contact, nationality, address, blood_group,
                email, password, created_at
            ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)
            """, (
                data["first_name"], data["middle_name"], data["last_name"],
                data["gender"], data["dob"], data["phone"],
                data["emergency_contact"], data["nationality"],
                data["address"], data["blood_group"],
                data["email"], data["password"],
                datetime.now().isoformat()
            ))
            conn.commit()
        return {"status": "success", "message": "User registered successfully"}
    except Exception as e:
        return {"status": "error", "message": str(e)}


# -- Login --------------------------------------------------------------------

@router.post("/login")
def login(data: dict):
    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(
                "SELECT * FROM users WHERE email=? AND password=?",
                (data["email"], data["password"])
            )
            user = cursor.fetchone()
        if user:
            return {"status": "success", "user": _row_to_user(user)}
        return {"status": "error", "message": "Invalid login"}
    except Exception as e:
        return {"status": "error", "message": str(e)}


# -- Profile ------------------------------------------------------------------

@router.get("/profile/{email}")
def get_profile(email: str):
    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM users WHERE email=?", (email,))
            user = cursor.fetchone()
        if not user:
            return {"status": "error", "message": "User not found"}
        return {"status": "success", "user": _row_to_user(user)}
    except Exception as e:
        return {"status": "error", "message": str(e)}


# -- Helper -------------------------------------------------------------------

def _row_to_user(row):
    return {
        "first_name": row[1], "middle_name": row[2], "last_name": row[3],
        "gender": row[4], "dob": row[5], "phone": row[6],
        "emergency_contact": row[7], "nationality": row[8],
        "address": row[9], "blood_group": row[10], "email": row[11],
    }