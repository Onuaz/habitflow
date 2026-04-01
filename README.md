# HabitFlow  
A simple and effective habit tracking app built with Flutter and SQLite.  
HabitFlow helps users build consistency by tracking daily habit completion, monitoring streaks, and visualizing weekly progress.

---

## 📱 Features

### ✔ Create Habits  
Add new habits with a title and description.

### ✔ Edit & Delete Habits  
Modify or remove habits at any time.

### ✔ Daily Completion Tracking  
Mark habits as completed for the current day.

### ✔ Streak Counter  
Automatically calculates how many consecutive days a habit has been completed.

### ✔ Weekly Progress Tracker  
Displays a 7‑day view showing which days were completed.

### ✔ Local Data Storage  
All data is stored locally using SQLite — no internet required.

### ✔ Dark Mode  
Theme preference is saved using SharedPreferences.

### ✔ Clean, Modern UI  
Card‑based layout, streak previews, and completion indicators.

---

## 🛠 Tech Stack

| Technology | Purpose |
|-----------|---------|
| **Flutter** | UI framework |
| **Dart** | Programming language |
| **SQLite (sqflite)** | Local database |
| **Provider** | State management |
| **SharedPreferences** | Theme persistence |

---

## 📂 Project Structure

---

## 🗄 Database Schema

### **habits table**
| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER PRIMARY KEY | Habit ID |
| title | TEXT | Habit name |
| description | TEXT | Habit details |

### **habit_logs table**
| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER PRIMARY KEY | Log ID |
| habit_id | INTEGER | Linked habit |
| date | TEXT (YYYY-MM-DD) | Completion date |
| completed | INTEGER (0/1) | Completion status |

---

## 🚀 How to Run the App

### 1. Clone the repository

### 2. Install dependencies

### 3. Run the app

Make sure you have an emulator or physical device connected.

---

## 🖼 Screenshots  


---

## 🔮 Future Improvements (Optional)
These are not required but can be added later:

- Notifications / reminders  
- Habit categories  
- Cloud sync  
- Monthly analytics  
- Custom habit icons  

---

## 📄 License  
This project is for educational purposes.

---

## 👤 Author  
Onomeh Umudi  
002701364
Mobile App Development/Henry Louis
