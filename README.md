# 💰 Expense Tracker Application

## 📌 Introduction

The **Expense Tracker Application** is a mobile application developed using Flutter that helps users manage their daily financial activities efficiently. It allows users to record income and expenses, categorize transactions, and analyze spending behavior through visual insights.

The application is designed with a modern user interface and supports both **light and dark themes**, making it user-friendly and visually appealing. It works completely offline using local storage, ensuring fast performance and data privacy.

---

## 🎯 Objective

The main objective of this project is to:

* Provide a simple and effective way to track daily expenses and income
* Help users understand their spending habits
* Demonstrate the use of local storage in Flutter
* Build a real-world application using modern UI/UX principles

---

## 📱 Application Overview

The application consists of multiple screens that work together to provide a complete expense management system:

* **Home Screen** – Displays balance, recent transactions, and quick actions
* **Add/Edit Transaction Screen** – Allows users to add or modify transactions
* **Analytics Screen** – Visual representation of expenses using charts
* **All Transactions Screen** – Displays complete transaction history
* **Category Management** – Allows adding and customizing categories

---

## ✨ Key Features

### 🔹 1. Transaction Management

Users can:

* Add new transactions
* Edit existing transactions
* Delete transactions

Each transaction includes:

* Amount
* Description
* Date
* Category
* Type (Income or Expense)

This allows structured and meaningful financial tracking.

---

### 🔹 2. Income and Expense Tracking

The application clearly distinguishes between:

* **Income** (money received)
* **Expense** (money spent)

This helps calculate:

* Total Balance
* Total Income
* Total Expenses

All values are dynamically updated.

---

### 🔹 3. Category System

The app provides predefined categories such as:

* Food
* Travel
* Shopping
* Bills

Users can also:

* Add custom categories
* Assign emojis/icons
* Select colors
* Delete categories

This makes the app flexible and personalized.

---

### 🔹 4. Local Data Storage

The application uses:

* **SQLite (sqflite)** for storing transactions
* **SharedPreferences** for storing:

  * Theme settings
  * Custom categories

This ensures:

* Offline functionality
* Fast data access
* Persistent storage

---

### 🔹 5. Analytics and Visualization

The app includes an analytics section where:

* Expenses are grouped by category
* Data is displayed using a **pie chart**

This helps users:

* Understand spending patterns
* Identify high-expense categories

Animations enhance user experience.

---

### 🔹 6. User Interface Design

The application follows modern UI principles:

* Clean and minimal layout
* Gradient backgrounds
* Rounded components
* Responsive design
* Proper spacing and alignment

The UI is optimized to avoid overflow issues and maintain consistency across devices.

---

### 🔹 7. Light and Dark Theme Support

The app supports:

* Light Mode ☀️
* Dark Mode 🌙

Users can switch themes from any screen.
The selected theme is saved and applied automatically on next launch.

---

### 🔹 8. Navigation System

The application uses Flutter navigation to move between screens:

* Home → Add Transaction
* Home → Analytics
* Home → All Transactions

Smooth transitions provide a seamless user experience.

---

## ⚙️ Working of the Application

1. The user opens the app and sees the dashboard with balance and recent transactions.
2. The user can add a transaction by entering details like amount, category, and date.
3. The transaction is stored locally using SQLite.
4. The home screen updates automatically with new data.
5. The user can view analytics to understand spending trends.
6. The user can switch themes or manage categories as needed.

---

## 🧠 Concepts Used

This project demonstrates the following concepts:

* Flutter UI design and layout
* State management using StatefulWidgets
* Navigation between screens
* Local database integration (SQLite)
* Persistent storage using SharedPreferences
* Data visualization using charts
* Error handling and UI optimization

---

## 🚧 Challenges Faced

During development, several challenges were encountered:

* Handling UI overflow issues in rows and layouts
* Managing dynamic categories and storing them locally
* Implementing theme switching across multiple screens
* Ensuring responsive design for different screen sizes

These challenges were resolved using proper Flutter widgets like `Expanded`, `Flexible`, and theme-based styling.

---

## 🔮 Future Enhancements

The application can be further improved by adding:

* PDF report generation
* Monthly and yearly expense summaries
* Cloud synchronization using Firebase
* Notifications and reminders
* Search and filter functionality

---

## 📌 Conclusion

The Expense Tracker application is a complete and practical implementation of a financial management tool. It demonstrates how Flutter can be used to build responsive, visually appealing, and fully functional mobile applications.

This project not only fulfills the requirement of using local storage but also provides a real-world solution for personal finance management.

---

## 📸 Screenshots

<p align="center">
  <img src="assets/screenshots/1.jpg" width="220" />
  <img src="assets/screenshots/2.jpg" width="220" />
  <img src="assets/screenshots/3.jpg" width="220" />
  <img src="assets/screenshots/4.jpg" width="220" />
  <img src="assets/screenshots/5.jpg" width="220" />
  <img src="assets/screenshots/6.jpg" width="220" />
  <img src="assets/screenshots/7.jpg" width="220" />
  <img src="assets/screenshots/8.jpg" width="220" />
</p>
