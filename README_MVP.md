# Volunteer Coordination MVP (Version 1 - Submission Ready)

## Problem Solved
Local communities struggle to coordinate urgent volunteer needs (food, medical, shelter, education). This MVP connects need reports with volunteer skills through simple, reliable matching - no AI complexity.

## Why this is an MVP
This version focuses ONLY on core workflow validation:
- Manual need reporting + dashboard viewing
- Deterministic volunteer matching (category + keywords)

Intentionally excludes AI, maps, and automation to validate the basic coordination loop first.

## Limitations of MVP
- No intelligent prioritization (manual urgency only)
- No real-time updates
- No geolocation or maps
- No automation (all manual entry)

## MVP Features


## MVP Features
- **Report Need**: Form with title/location/category/urgency/description → validated API POST /needs
- **Needs Dashboard**: Live list (GET /needs), sorted by urgency descending, empty state
- **Volunteer Match**: Skills input → deterministic matches (category + keywords), top 3 ranked with reasons, loading/error states
- **In-memory storage** with 5 dummy needs for reliable demo

## Intentionally NOT Included (Future v2+)
- AI/ML, image scan, maps (requires APIs/DB)
- User auth, real DB, notifications
- Advanced filters, real-time updates

## Demo Flow (3 Steps)
1. **Tab 1**: Report Need → Fill form → Submit → Success snackbar
2. **Tab 2**: Dashboard → See new need + dummies (sorted urgency)
3. **Tab 3**: Match → Skills "food nurse" → Top matches with reasons like "Urgency 5/5; category match"

## Architecture
```
Frontend (Flutter)
├── api_service.dart → FastAPI backend
└── 3 screens (report/dashboard/match)

Backend (FastAPI)
├── /needs POST → Validate/store (in-memory)
├── /needs GET → Urgency-sorted list
├── /match GET → Deterministic scoring: urgency*cat_match + keywords
└── Dummy data for stability
```

**Run:**
```
# Backend
cd backend
pip install -r requirements.txt
uvicorn main:app --reload  # localhost:8000/needs

# Frontend  
cd frontend
flutter pub get
flutter run
```

**How This Evolves**: Add Firebase/DB/maps for v2, Gemini AI for semantic matching v3.

## Demo Steps
**Exact 4-step demo (2 minutes):**

1. **Report Need** (Tab 1): Fill form → Submit → Success message
2. **View Dashboard** (Tab 2): See needs sorted by urgency (live refresh)
3. **Run Match** (Tab 3): Enter skills like "food nurse" → See top 3 matches + reasons
4. **MVP Limitation + Future**: Note manual process, then explain v2 evolution (AI/maps)

## How this evolves into our Prototype
- AI-based need detection (Gemini for image/text scan)
- Smart volunteer matching (semantic AI search)
- Map-based visualization (real locations)
- Scalable backend (Firebase + real-time)

Stable, explainable MVP validates core manual coordination loop.

