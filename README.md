# WriteFlow — Flutter Blogging Application

WriteFlow is a blogging application built using Flutter that enables users to create, manage, and read blog content with a clean and responsive interface. The project focuses on real-world app architecture, state management, and backend integration.

This application was developed as a hands-on implementation of production-oriented Flutter development practices.

---

## Overview

WriteFlow allows users to authenticate, publish blog posts, upload images, and browse content in a structured and scalable environment. The project demonstrates separation of concerns, modular structure, and integration with cloud services.

---

## Core Features

* User authentication (sign up and login)
* Create, edit, and delete blog posts
* Image upload and storage integration
* Blog feed with structured content display
* Loading, error, and empty states handling
* Responsive UI design
* Backend-connected data flow

---

## Tech Stack

* Framework: Flutter
* Language: Dart
* State Management: Bloc / Cubit
* Backend: Supabase / Firebase
* Database: PostgreSQL (Supabase) / Firestore
* Storage: Supabase Storage

---

## Project Structure

```
lib/

├── core/                  # Theme, constants, utilities
├── features/
│   ├── auth/              # Authentication logic and UI
│   ├── blog/              # Blog creation, display, and management
│
└── main.dart
```

The structure follows a modular approach with separation between UI, business logic, and data handling.

---

## Setup Instructions

### 1. Clone the repository

```
git clone https://github.com/your-username/writeflow.git
```

### 2. Navigate to the project directory

```
cd writeflow
```

### 3. Install dependencies

```
flutter pub get
```

### 4. Run the application

```
flutter run
```

---

## Backend Configuration

### Supabase

* Create a Supabase project
* Configure authentication
* Create required tables for users and blogs
* Apply row-level security policies
* Add project URL and anon key in app initialization


## Engineering Focus Areas

* Clean architecture implementation
* State management using Bloc/Cubit
* Async programming using Future and streams
* Scalable UI component structure
* Backend-driven data flow
* Reusable widgets and theming

---

## Future Scope

* Blog search functionality
* Like and comment system
* Bookmark feature
* Rich text editor
* AI-assisted writing support

---

