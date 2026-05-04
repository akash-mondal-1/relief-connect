# ReliefConnect 🚀

A full-stack volunteer coordination platform that connects people in need with volunteers using intelligent matching and automated categorization.

---

## 🌐 Live Demo

* Frontend: https://relief-connect.netlify.app/
* Backend API: https://volunteer-backend-production-c181.up.railway.app
* API Docs: https://volunteer-backend-production-c181.up.railway.app/docs

---

## 🎯 Problem

During emergencies, people struggle to quickly find relevant help.
Existing systems lack intelligent prioritization and real-time coordination.

---

## 💡 Solution

ReliefConnect allows users to:

* Report urgent needs
* Automatically categorize requests
* Match volunteers using a scoring system
* Manage their own requests securely

---

## ⚡ Features

* 🔐 JWT Authentication (Signup/Login)
* 📌 Report Needs (food, medical, shelter, etc.)
* 🤖 AI-like Category Detection (keyword scoring)
* 🎯 Smart Matching Algorithm

  * Urgency-based scoring
  * Keyword similarity
  * Category relevance
* 🧑 Ownership-based Edit/Delete
* 🌍 Fully deployed system

---

## 🧠 How It Works

1. User submits a request
2. System auto-detects category from text
3. Matching engine ranks needs using:

   * urgency × weight
   * keyword overlap
   * category match
4. Top results returned with **score + reasoning**

---

## 🛠 Tech Stack

**Frontend**

* Flutter (Web)

**Backend**

* FastAPI
* SQLite

**Deployment**

* Railway (Backend)
* Netlify (Frontend)

---

## ⚠️ Limitations

* SQLite used (non-persistent on free tier)
* Backend may cold start after inactivity

---

## 🚀 Future Improvements

* PostgreSQL for persistence
* Real NLP/ML model for classification
* Image upload for verification
* Map-based need visualization

---

## 📸 Screenshots

(Add screenshots here — REQUIRED)

---

## 👨‍💻 Author

Akash Mondal
