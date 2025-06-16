# Smart Foot Traffic Monitoring System – Frontend

This is the Flutter frontend for the Smart Foot Traffic Monitoring System. It provides an interactive web interface where users can filter, generate, and analyze traffic data through heatmaps, charts, and detailed snapshots.

---

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/AurelioAlfons/Smart-Foot-Traffic-Frontend.git
cd Smart-Foot-Traffic-Frontend
```

### 2. Set Up Flutter Environment

- Ensure Flutter SDK is installed and configured
- Use VS Code or any preferred IDE
- Run the following command to get dependencies:

```bash
flutter pub get
```

---

## Running the App

You can run the app in multiple ways:

- In Chrome:
  ```bash
  flutter run -d chrome
  ```

- Through VS Code:
  - Click the green **Run** or **Debug** button

- Via hosted GitHub Pages site (if available)

---

## How to Use the App

1. Launch the app in Chrome or your browser.
2. Use the filter panel to select:
   - Date, Time, Traffic Type, Year, Season
3. Click the **Generate** button to load data:
   - A heatmap will be shown
   - Snapshot table will display all sensor zones
   - Bar, Line, Pie, and Forecast charts will render
4. Click the **Export Report** button to download a full HTML summary report

---

## Tech Stack

- Flutter Web
- Dart
- Material UI
- Integrated with Flask Backend API

---

## Folder Structure

```
lib/
├── components/        # Reusable widgets (dropdowns, charts, buttons)
├── pages/             # Main UI screens
├── services/          # API integration logic
├── routing/           # Route configuration
└── main.dart          # App entry point
```

---

## Requirements

- Flutter 3.10 or newer
- Dart SDK
- Chrome browser (for testing)
- VS Code or Andro
