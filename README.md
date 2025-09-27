# PantryLink

> **One Platform. Every Tool Your Food Bank Needs.**

A comprehensive food bank management platform that streamlines operations, tracks inventory, manages volunteers, and connects communities through a modern web application and iOS mobile app.

**🏆 Congressional App Challenge 2025 Entry** | **🏫 Developed at The Coder School Montgomery**

[![React](https://img.shields.io/badge/React-19.1.0-61DAFB?logo=react)](https://reactjs.org/)
[![Swift](https://img.shields.io/badge/Swift-5.0-orange?logo=swift)](https://swift.org/)
[![Flask](https://img.shields.io/badge/Flask-3.1.1-000000?logo=flask)](https://flask.palletsprojects.com/)
[![Mantine](https://img.shields.io/badge/Mantine-8.0.2-339AF0?logo=mantine)](https://mantine.dev/)

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Development](#-development)
- [Team](#-team)
- [Contributing](#-contributing)

---

## 🎯 Overview

PantryLink is a full-stack food bank management solution designed to help food banks and pantries operate more efficiently. The platform provides tools for inventory tracking, volunteer scheduling, donation management, and community engagement through an intuitive web interface and mobile application.

### Key Benefits
- **Streamlined Operations**: Centralized management of all food bank activities
- **Real-time Tracking**: Monitor inventory levels and donation status
- **Volunteer Management**: Easy scheduling and coordination of volunteers
- **Community Connection**: Bridge the gap between donors, volunteers, and recipients
- **Mobile Accessibility**: iOS app for recipients and volunteers

---

## ✨ Features

### 🖥️ Web Application
- **Modern Dashboard**: Real-time overview of food bank operations
- **Inventory Management**: Track donations, expiration dates, and stock levels
- **Volunteer Scheduling**: Coordinate volunteer shifts and responsibilities
- **Donation Tracking**: Monitor incoming donations and donor information
- **Responsive Design**: Works seamlessly across desktop and mobile devices

### 📱 iOS Mobile App
- **Native Experience**: Built with SwiftUI for optimal iOS performance
- **Push Notifications**: Real-time alerts for urgent needs or updates
- **Stock and Stream**: Easily Veiw the current stock of local pantries and any notifications they have viea the stream.

### 🔧 Backend Services
- **RESTful API**: Flask-based backend for data management
- **Data Persistence**: Secure storage of inventory and user data
- **Authentication**: Secure user authentication and authorization
- **Real-time Updates**: WebSocket support for live data synchronization

---

## 🛠️ Tech Stack

### Frontend (Web)
- **React 19.1.0** - Modern UI library for building interactive interfaces
- **Mantine 8.0.2** - Comprehensive React component library
- **Redux 4.2.1** - State management for predictable application state
- **Framer Motion** - Animation library for smooth user interactions
- **React Router DOM** - Client-side routing
<!-- - **Recharts** - Data visualization and charts -->
- **Vite** - Fast build tool and development server

### Mobile (iOS)
- **SwiftUI** - Modern declarative UI framework
- **Swift 5.0** - Apple's programming language
- **Xcode** - Integrated development environment

### Backend
- **Flask 3.1.1** - Lightweight Python web framework
- **Python 3.x** - Backend programming language
- **MongoDB** - Database management

### Development Tools
- **ESLint** - Code linting and formatting
- **Git** - Version control
- **npm** - Package management

---

## 📁 Project Structure

```
yellow_team/
├── 📱 ClientReact/                 # React web application
│   ├── src/
│   │   ├── components/            # Reusable UI components
│   │   ├── pages/                 # Page components
│   │   ├── assets/                # Static assets
│   │   └── App.jsx               # Main application component
│   ├── package.json              # Dependencies and scripts
│   └── vite.config.js            # Vite configuration
├── 📱 PantryLink/                 # iOS mobile application
│   ├── PantryLink/
│   │   ├── PantryLinkApp.swift   # Main app entry point
│   │   ├── HomeView.swift        # Home screen
│   │   ├── NavView.swift         # Navigation
│   │   └── StreamView.swift      # Data streaming
│   └── PantryLink.xcodeproj/     # Xcode project files
├── 🖥️ server/                     # Flask backend
│   ├── run.py                    # Server entry point
│   └── requirements.txt          # Python dependencies
└── 📄 README.md                  # Project documentation
```

---

## 🚀 Getting Started

### Prerequisites

- **Node.js** (v18 or higher)
- **Python** (v3.8 or higher)
- **Xcode** (for iOS development, macOS only)
- **Git**

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/yellow_team.git
   cd yellow_team
   ```

2. **Set up the Web Application**
   ```bash
   cd ClientReact
   npm install
   npm run dev
   ```
   The web app will be available at `http://localhost:5173`

3. **Set up the Backend Server**
   ```bash
   cd ../server
   pip install -r requirements.txt
   python run.py
   ```
   The server will run on `http://localhost:3000`

4. **Set up the iOS App** (macOS only)
   ```bash
   cd ../PantryLink
   open PantryLink.xcodeproj
   ```
   Open the project in Xcode and run on simulator or device.

---

## 💻 Development

### Available Scripts

#### Web Application (ClientReact/)
```bash
npm run dev          # Start development server
npm run build        # Build for production
npm run preview      # Preview production build
npm run lint         # Run ESLint
```

#### Backend Server (server/)
```bash
python run.py        # Start Flask development server
```


## 👥 Team

**Yellow Team** - Building the future of food bank management

**🏫 The Coder School Montgomery** | **🏆 Congressional App Challenge 2025**

| Member | Role | Contributions |
|--------|------|---------------|
| **Nupur** | Frontend Developer | IOS UI/UX design |
| [**Josh**](https://www.joshuasambol.com) | Full Stack Developer | React website, IOS UI/UX design, Backend API connections, Redux |
| **Naisha** | Full Stack Developer | Database Design, IOS UI/UX |
| **Michael Youtz** | Full Stack Developer | Flask server, Backend Schema and Routes, IOS UI/UX |

### Team Values
- **Collaboration**: Working together to solve complex problems
- **Innovation**: Creating cutting-edge solutions for food security
- **Impact**: Making a real difference in communities
- **Quality**: Delivering robust, user-friendly applications

### About the Project
This project was developed as part of **The Coder School Montgomery**'s advanced coding program and is our entry for the **2025 Congressional App Challenge**. The challenge encourages students to create innovative applications that solve real-world problems in their communities. PantryLink addresses the critical need for efficient food bank management systems to better serve communities facing food insecurity.

---

## 🙏 Acknowledgments

- **Mantine Team** for the excellent React component library
- **React Community** for the amazing ecosystem
- **Apple** for SwiftUI and iOS development tools
- **Flask Community** for the lightweight web framework
- **The Coder School** for managing and supporting our project
---

## 📞 Contact

- **Project Link**: [https://github.com/posaune14/yellow_team](https://github.com/posaune14/yellow_team)
- **Issues**: [https://github.com/posaune14/yellow_team/issues](https://github.com/posaune14/yellow_team/issues)

---

<div align="center">

**Made with ❤️ by Yellow Team**

*Empowering food pantries, one community at a time*

</div>