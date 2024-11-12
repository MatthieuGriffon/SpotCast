# SpotCast 🎣

## Description
**SpotCast** is a mobile application built for fishing enthusiasts who want to explore, share, and manage their favorite fishing spots. The app connects anglers, allowing them to collaborate in real-time, organize group events, and access detailed weather forecasts to optimize their fishing experience. Whether you’re an experienced fisherman or a novice, SpotCast provides everything you need to enhance your adventures on the water.

## Table of Contents
- [SpotCast 🎣](#spotcast-)
  - [Description](#description)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Technology Stack](#technology-stack)
  - [Installation](#installation)
    - [Prerequisites](#prerequisites)
    - [Setup Instructions](#setup-instructions)
    - [Backend](#backend)
    - [Environment Variables:](#environment-variables)
    - [Launch the Application](#launch-the-application)
    - [Run the project:](#run-the-project)
    - [Access the app:](#access-the-app)
    - [Usage](#usage)
    - [Contributing](#contributing)
    - [Fork the repository.](#fork-the-repository)
    - [License](#license)

## Features
- 🌍 **Spot Discovery & Sharing**  
  Discover fishing spots on an interactive map, share your locations with the community, and explore top-rated spots.
- 💬 **Real-Time Chat**  
  Communicate with other anglers using our integrated chat feature, powered by WebSockets.
- 🎣 **Group & Event Management**  
  Create, join, and manage fishing groups and events to plan fishing trips with friends or other enthusiasts.
- ☀️ **Weather Forecasts**  
  Get real-time weather forecasts and fishing conditions powered by OpenWeather.
- 🔒 **Secure User Authentication**  
  Protect your data with JWT-based authentication and encrypted passwords.
- 📱 **Cross-Platform Support**  
  Built with Flutter to ensure seamless performance on both iOS and Android devices.

## Technology Stack
- **Frontend**: Flutter(Dart)
- **Backend**: AdonisJS, PostgreSQL
- **APIs & Services**: 
  - Google Maps for location services
  - OpenWeather for weather forecasts
  - Cloudinary for image uploads
  - OneSignal for push notifications
- **Real-Time Communication**: WebSocket for chat
- **Hosting & Deployment**: Docker for containerization

## Installation

### Prerequisites
Make sure you have the following installed on your system:
- [Node.js](https://nodejs.org/) (version >= 20.6)
- [Flutter](https://flutter.dev/)
- [PostgreSQL](https://www.postgresql.org/download/)

### Setup Instructions
1. **Clone the repository**:
   ```bash
   git clone https://github.com/MatthieuGriffon/SpotCast.git
   cd SpotCast
Install dependencies for both frontend and backend:


## Install Dependencies for both Frontend and Backend:

### Frontend
```bash
cd frontend
flutter pub get
```

### Backend
```bash
cd ../backend
npm install
```

### Environment Variables:
Create a .env file in the backend folder with the following content:
```bash
DB_CONNECTION=pg
DB_HOST=localhost
DB_PORT=5432
DB_USER=your_db_user
DB_PASSWORD=your_db_password
DB_NAME=spotcast_db
JWT_SECRET=your_jwt_secret
```

### Launch the Application
To run both the frontend (Flutter) and backend (AdonisJS) simultaneously:

Configure concurrently to launch both servers: Add the following to your root package.json file:
```bash
"scripts": {
  "dev": "concurrently \"npm run dev-backend\" \"npm run dev-frontend\"",
  "dev-backend": "cd backend && npm run dev",
  "dev-frontend": "cd frontend && flutter run -d <ID-DEVICE>"
}
```
Replace <ID-DEVICE> with the ID of your physical device.

### Run the project:
```bash
  npm run dev
```
### Access the app:

Frontend: The Flutter project will open on your physical device.
Backend: The AdonisJS server will be accessible at http://localhost:3333.

### Usage
Sign up to create an account or log in if you already have one.
Discover and share fishing spots on the map.
Join or create fishing groups and plan events.
Chat with fellow anglers in real-time.
Check weather forecasts to plan your next fishing trip.
Screenshots
Include some screenshots of your app here (optional).
Example:

API Integrations
SpotCast leverages various third-party APIs:

Google Maps API: For interactive map and location services.
OpenWeather API: For real-time weather conditions and forecasts.
Cloudinary: For managing and storing user-uploaded images.
OneSignal: For sending push notifications to users.

### Contributing
We welcome contributions! If you'd like to contribute to this project, please follow these steps:

### Fork the repository.
```bash
Create a new branch:
git checkout -b feature/your-feature
Make your changes and commit:
git commit -m "Add new feature"
Push to the branch:
git push origin feature/your-feature
Open a pull request.
```
### License
This project is licensed under the MIT License. See the LICENSE file for details.
