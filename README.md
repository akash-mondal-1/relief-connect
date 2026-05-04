# Relief-Connect 🚀

A full-stack volunteer coordination system that connects people in need with volunteers using intelligent matching and automated categorization.

---

## 🌐 Live Demo

* Frontend: https://relief-connect.netlify.app
* Backend API: https://volunteer-backend-production-c181.up.railway.app

---

## ⚡ Features

* 🔐 JWT Authentication (Signup/Login)
* 📌 Report Needs (food, medical, shelter, etc.)
* 🤖 Automatic Category Detection (AI-like keyword scoring)
* 🎯 Smart Matching Algorithm (urgency + relevance scoring)
* 🧑‍💼 Ownership-based CRUD (edit/delete your own needs)
* 🌍 Fully deployed (Railway + Netlify)

---

## 🧠 How It Works

1. Users submit a need request
2. System auto-detects category from text
3. Matching endpoint ranks needs based on:

   * Urgency
   * Keyword similarity
   * Category match
4. Top matches are returned with score + reasoning

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

* PostgreSQL integration
* Real AI/NLP model for classification
* Image upload for needs
* Map-based location tracking

---

## 👨‍💻 Author

Akash Mondal
