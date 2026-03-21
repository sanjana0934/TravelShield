"""
core/database.py  –  PostgreSQL connection and table initialisation.
Uses psycopg2 to connect to Supabase PostgreSQL.
Call `init_db()` once on app startup.
"""

import psycopg2
import psycopg2.extras
from contextlib import contextmanager
from core.config import DATABASE_URL


@contextmanager
def get_db():
    """Return a PostgreSQL connection as a context manager."""
    conn = psycopg2.connect(DATABASE_URL)
    try:
        yield conn
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()


def init_db():
    """Create all tables if they don't exist yet."""
    with get_db() as conn:
        cursor = conn.cursor()

        # ── Users ─────────────────────────────────────────────────────────────
        cursor.execute("""
        CREATE TABLE IF NOT EXISTS users(
            id                SERIAL PRIMARY KEY,
            first_name        TEXT,
            middle_name       TEXT,
            last_name         TEXT,
            gender            TEXT,
            dob               TEXT,
            phone             TEXT,
            emergency_contact TEXT,
            nationality       TEXT,
            address           TEXT,
            blood_group       TEXT,
            email             TEXT UNIQUE,
            password          TEXT,
            created_at        TEXT
        )
        """)

        # ── Trips ─────────────────────────────────────────────────────────────
        cursor.execute("""
        CREATE TABLE IF NOT EXISTS trips(
            id              SERIAL PRIMARY KEY,
            user_email      TEXT    NOT NULL,
            title           TEXT    NOT NULL,
            destination     TEXT    NOT NULL,
            start_date      TEXT,
            end_date        TEXT,
            purpose         TEXT    DEFAULT 'leisure',
            travelers_count INTEGER DEFAULT 1,
            budget_inr      REAL,
            notes           TEXT,
            status          TEXT    DEFAULT 'upcoming',
            created_at      TEXT,
            FOREIGN KEY (user_email) REFERENCES users(email)
        )
        """)

        # ── Itinerary days ────────────────────────────────────────────────────
        cursor.execute("""
        CREATE TABLE IF NOT EXISTS itinerary_days(
            id          SERIAL PRIMARY KEY,
            trip_id     INTEGER NOT NULL,
            day_number  INTEGER,
            date        TEXT,
            title       TEXT,
            activities  TEXT,
            FOREIGN KEY (trip_id) REFERENCES trips(id)
        )
        """)

        # ── Login attempts (for rate limiting) ────────────────────────────────
        cursor.execute("""
        CREATE TABLE IF NOT EXISTS login_attempts(
            id           SERIAL PRIMARY KEY,
            email        TEXT    NOT NULL,
            attempted_at TEXT    NOT NULL,
            success      INTEGER DEFAULT 0
        )
        """)