# 💰 Expense Ledger

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Hive](https://img.shields.io/badge/Hive-FFDD00?style=for-the-badge&logo=hive&logoColor=000000)](https://pub.dev/packages/hive)
[![Provider](https://img.shields.io/badge/Provider-FB0A8D?style=for-the-badge&logoColor=white)](https://pub.dev/packages/provider)
[![Material3](https://img.shields.io/badge/Material3-6200EE?style=for-the-badge&logoColor=white)](https://m3.material.io/)

A high-performance personal finance tracker built with **Flutter**. This app leverages **NoSQL local storage** and advanced data visualization to provide a fast, private, and intuitive budgeting experience.

---

## 📱 Screenshots Gallery

### Light Mode

**Dashboard – Real-time Ledger**  
<img src="assets/light_mode/4_home.png" width="400" alt="Light Mode Dashboard – Real-time Ledger" />

**Analytics – Weekly Insights**  
<img src="assets/light_mode/8_stats.png" width="400" alt="Light Mode Analytics – Weekly Insights" />

**Add Expense**  
<img src="assets/light_mode/5_add_expense.png" width="400" alt="Light Mode Add Expense Screen" />

### Dark Mode

**Dashboard – Real-time Ledger**  
<img src="assets/dark_mode/4_home.png" width="400" alt="Dark Mode Dashboard – Real-time Ledger" />

**Analytics – Weekly Insights**  
<img src="assets/dark_mode/8_stats.png" width="400" alt="Dark Mode Analytics – Weekly Insights" />

**Add Expense**  
<img src="assets/dark_mode/5_add_expense.png" width="400" alt="Dark Mode Add Expense Screen" />

> Full screenshots including Settings, Edit Transaction, Login/Signup, and Splash Screen are available in the `assets/screenshots` folder.

---

## 🎯 Engineering Highlights

- **Layered Architecture:** Implemented with the **Provider pattern** to ensure a strict separation between Presentation, Domain, and Data layers.
- **Optimized Performance:** Utilizes **Hive (NoSQL)** for O(1) data access, offering superior speed over traditional SQLite for local persistence.
- **Advanced Visualization:** Custom `fl_chart` implementation featuring dynamic scaling, shorthand currency formatting, and theme-aware rendering.
- **Modular Design:** Built with **13+ atomic custom components** to ensure code reusability and UI consistency.

---

## ✨ Core Functionalities

### 🏦 Ledger Management

- **Full CRUD:** Effortless transaction management with persistent local storage.
- **Categorization:** Smart sorting across 8 essential categories with custom icons.
- **Native UX:** Integrated swipe-to-action gestures and tactile haptic feedback.

### 📊 Insights & Analytics

- **Adaptive Charting:** Weekly trends that auto-scale for high-volume data without breaking layouts.
- **Distribution Analysis:** Pie-chart breakdown for instant identification of spending patterns.
- **Reactive UI:** Real-time state synchronization across all application modules.

### 🎨 Design System

- **Adaptive Theming:** Seamless support for System, Light, and Dark modes.
- **Material 3:** Modern aesthetic with high-contrast typography and fluid animations.
- **Responsive:** Designed to adapt perfectly to any screen size or aspect ratio.

---

## 🏗️ System Design

### State Management (Provider)

Uses a reactive approach where domains (Expenses, Theme, Preferences) are isolated into specific Providers to optimize memory and prevent unnecessary rebuilds.

### Persistence Strategy (Hive)

Selected for its binary storage format and rapid indexing, ensuring complex charts and large datasets render instantly without lag.

---

## 🛠️ Tech Stack & Packages Used

- **Flutter:** Frontend framework for cross-platform development
- **Dart:** Programming language
- **Hive:** NoSQL local storage for fast CRUD operations
- **Provider:** State management
- **fl_chart:** Custom charts and data visualization
- **Material 3:** Modern design components and theming
- **Other Packages:**
  - `intl` (currency formatting)
  - `shared_preferences` (storing user preferences)
  - `flutter_localizations` (multi-language support)

---

## 🚀 Getting Started

1. **Clone & Install**

```bash
git clone https://github.com/Rumaisa19/expense_ledger_app.git
cd expense-ledger
flutter pub get
```

2. **Run**

```bash
flutter run
```

---

## 👨‍💻 Author

**Rumaisa Mushtaq**

- **LinkedIn:** [https://linkedin.com/in/rumaisamushtaq](https://linkedin.com/in/rumaisamushtaq)
- **GitHub:** [https://github.com/Rumaisa19](https://github.com/Rumaisa19)

---

## 📞 Support

If you find this project useful, please give it a ⭐️ on GitHub!
Feel free to share feedback or ask questions — contributions are welcome.
