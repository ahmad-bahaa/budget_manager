# Budget Manager

Budget Manager is a powerful, privacy-focused expense tracking and budgeting application built with Flutter. It helps you manage your money with complete offline privacy while offering modern AI-powered features.

## 🚀 Features

### 💰 Core Budgeting
- **Expense Tracking**: Easily record your daily spending with notes and categories.
- **Monthly Budgets**: Set monthly limits for different categories to stay on top of your finances.
- **Budget Overview**: Visual dashboard with pie charts showing your budget breakdown and spending progress.
- **Custom Categories**: Create, edit, and delete categories with custom colors and icons.
- **Recurring Transactions**: Automate your regular bills and income (Daily, Weekly, Monthly).
- **Savings Goals**: Track your progress towards specific savings targets.

### 🤖 AI-Powered Tools (Powered by Gemini)
- **AI Budget Advisor**: Get personalized financial advice and insights based on your spending habits.
- **Smart Receipt Scanning**: Use OCR and Gemini AI to automatically extract amounts, notes, and dates from your receipts.
- **Category Suggestions**: AI helps you categorize your expenses based on your transaction notes.

### 🔒 Privacy & Security
- **Offline First**: Your financial data stays on your device.
- **Secure Storage**: Sensitive information like API keys are stored using platform-specific secure storage (Android Keystore / iOS Keychain).
- **Cloud Sync (Optional)**: Securely sync your data across devices using Firebase with Google Sign-In.

### 🛠 Other Features
- **Multi-language Support**: Available in English, Arabic, French, and Spanish.
- **Themes**: Support for Light and Dark modes with custom color seeds.
- **Home Screen Widget**: Quick view of your budget status directly from your home screen.
- **Data Export/Import**: Backup and restore your data locally.

## 🛠 Tech Stack
- **Framework**: Flutter
- **State Management**: Riverpod
- **Database**: SQLite (via `sqflite`)
- **AI**: Google Generative AI (Gemini)
- **OCR**: Google ML Kit Text Recognition
- **Security**: Flutter Secure Storage
- **Charts**: FL Chart

## 🏁 Getting Started

### Prerequisites
- Flutter SDK
- Android Studio / VS Code
- A Gemini API Key (for AI features)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/ahmad-bahaa/budget_manager.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## 📝 License
This project is for educational purposes. See the repository for license details.
