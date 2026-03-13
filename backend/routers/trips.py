"""
routers/trips.py  –  Trip CRUD (create, read, update, delete).
"""

from datetime import datetime
from fastapi import APIRouter, HTTPException, Query
from core.database import get_db

router = APIRouter(tags=["Trips"])


# ── Helpers ───────────────────────────────────────────────────────────────────

def _row_to_trip(row):
    return {
        "id":             row[0],
        "user_email":     row[1],
        "title":          row[2],
        "destination":    row[3],
        "start_date":     row[4],
        "end_date":       row[5],
        "purpose":        row[6],
        "travelers_count":row[7],
        "budget_inr":     row[8],
        "notes":          row[9],
        "status":         row[10],
        "created_at":     row[11],
    }


# ── Routes ────────────────────────────────────────────────────────────────────

@router.get("/trips")
def get_trips(email: str = Query(...)):
    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(
                "SELECT * FROM trips WHERE user_email=? ORDER BY created_at DESC",
                (email,)
            )
            rows = cursor.fetchall()
        return {"status": "success", "trips": [_row_to_trip(r) for r in rows]}
    except Exception as e:
        return {"status": "error", "message": str(e)}


@router.post("/trips")
def create_trip(data: dict):
    try:
        email = data.get("user_email")
        if not email:
            raise HTTPException(status_code=400, detail="user_email is required")
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("""
            INSERT INTO trips(
                user_email, title, destination, start_date, end_date,
                purpose, travelers_count, budget_inr, notes, status, created_at
            ) VALUES (?,?,?,?,?,?,?,?,?,?,?)
            """, (
                email,
                data.get("title"),
                data.get("destination"),
                data.get("start_date"),
                data.get("end_date"),
                data.get("purpose", "leisure"),
                data.get("travelers_count", 1),
                data.get("budget_inr"),
                data.get("notes"),
                "upcoming",
                datetime.now().isoformat(),
            ))
            trip_id = cursor.lastrowid
            conn.commit()
        return {"status": "success", "id": trip_id, "message": "Trip created"}
    except Exception as e:
        return {"status": "error", "message": str(e)}


@router.get("/trips/{trip_id}")
def get_trip(trip_id: int, email: str = Query(...)):
    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(
                "SELECT * FROM trips WHERE id=? AND user_email=?",
                (trip_id, email)
            )
            row = cursor.fetchone()
        if not row:
            raise HTTPException(status_code=404, detail="Trip not found")
        return {"status": "success", "trip": _row_to_trip(row)}
    except HTTPException:
        raise
    except Exception as e:
        return {"status": "error", "message": str(e)}


@router.patch("/trips/{trip_id}")
def update_trip(trip_id: int, data: dict):
    try:
        email = data.get("user_email")
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("""
            UPDATE trips
            SET title=?, destination=?, start_date=?, end_date=?,
                purpose=?, travelers_count=?, budget_inr=?, notes=?, status=?
            WHERE id=? AND user_email=?
            """, (
                data.get("title"),
                data.get("destination"),
                data.get("start_date"),
                data.get("end_date"),
                data.get("purpose"),
                data.get("travelers_count"),
                data.get("budget_inr"),
                data.get("notes"),
                data.get("status", "upcoming"),
                trip_id,
                email,
            ))
            conn.commit()
        return {"status": "success", "message": "Trip updated"}
    except Exception as e:
        return {"status": "error", "message": str(e)}


@router.delete("/trips/{trip_id}")
def delete_trip(trip_id: int, email: str = Query(...)):
    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(
                "DELETE FROM trips WHERE id=? AND user_email=?",
                (trip_id, email)
            )
            conn.commit()
        return {"status": "success", "message": "Trip deleted"}
    except Exception as e:
        return {"status": "error", "message": str(e)}