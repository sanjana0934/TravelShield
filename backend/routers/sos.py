from fastapi import APIRouter
import requests

router = APIRouter(tags=["SOS"])

def get_place_name(lat, lon):
    url = "https://nominatim.openstreetmap.org/reverse"
    params = {"lat": lat, "lon": lon, "zoom": 18, "addressdetails": 1, "format": "json"}
    headers = {"User-Agent": "TravelShield-SOS-App"}
    try:
        response = requests.get(url, params=params, headers=headers, timeout=5)
        data = response.json()
        return data.get("name") or data.get("display_name")
    except Exception:
        return None

@router.post("/send_location")
def receive_location(data: dict):
    lat   = float(data["latitude"])
    lon   = float(data["longitude"])
    place = get_place_name(lat, lon) or f"{lat:.6f}, {lon:.6f}"
    maps_link = f"https://www.google.com/maps?q={lat},{lon}"
    print(f"🚨 SOS | Place: {place} | Maps: {maps_link}")
    return {"status": "SOS received", "place": place, "maps": maps_link}