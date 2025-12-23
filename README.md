![questions screen](https://github.com/user-attachments/assets/b3401b5f-d937-4dd5-ad2f-d1429675fe18)# Interview Prep App (Flutter)

#Output
![login screen](https://github.com/user-attachments/assets/b3c6a9c9-b89c-4a23-8c7c-eaccb905ef8d)
![home screen](https://github.com/user-attachments/assets/48eccc9b-6735-4e81-872b-6cb02754ad42)
![questions screen](https://github.com/user-attachments/assets/11b1ef42-f658-40bb-9bb3-ca613508aaa4)
![questio screen2](https://github.com/user-attachments/assets/798390f1-a470-417e-9e51-bf1f40d652e5)
![attempt history screen](https://github.com/user-attachments/assets/ddfc4e08-a55d-4b54-b4fc-3743a4f4dac1)



## 📌 Short Description
A mini interview preparation mobile app built using Flutter.
The app allows users to practice interview questions, submit answers,
get basic feedback scores, and receive daily interview reminders
using **local notifications**.

This project is built as part of an interview assignment
focusing on clean architecture, local storage, and state management.

---

## Screens

- Login Screen  
  Dummy authentication using local SQLite storage.

- Home Screen  
  Displays list of interview questions stored locally.

- Question Detail Screen  
  Shows question text, role & difficulty tags, and answer input field.

- Feedback Screen  
  Displays score (1–5) based on basic scoring logic.

- Attempts History Screen  
  Shows previous answers with scores and timestamps.


## 🚀 Features
- Dummy login (local-only using SQLite)
- List of interview questions (local DB)
- Question detail screen with:
    - Question text
    - Role & difficulty tags
    - Answer input field
- Answer submission with local storage
- Attempts history screen showing:
    - Previous answers
    - Feedback scores (1–5)
- Basic answer scoring logic:
    - Length-based / keyword-based
- Daily interview reminder using **local notifications**
  (No device token / FCM required)

👉 All assignment requirements are fully implemented and tested.

---

## 🛠 Tech Stack
- **Flutter** – UI development
- **SQLite (sqflite)** – Local database (login, questions, attempts)
- **flutter_local_notifications** – Daily reminder notification
- **BLoC** – State management (MVVM pattern)

---

## 🗂 Folder Structure

lib/
├── data/
│ ├── datasources/ # SQLite DB & local storage
│ ├── models/ # Data models
│ 
│
├── domain/
│ ├── entities/ # Core entities
│ ├── scoring/ # Scoring logic 
│ 
│
├── presentation/
│ ├── screens/ # UI screens
│ 
│ 
│
├── notification_service.dart # Local notification handling
└── main.dart # App entry point
