# Takyeem (تقييم)

A Flutter application for managing and tracking student progress in Quran memorization.

## Overview

Takyeem is a comprehensive management system designed for Quran teaching institutions. It helps track student attendance, progress, and performance through daily records and reports.

## Features

- **Authentication System**
  - Secure login with email and password
  - Session management using Supabase

- **Dashboard**
  - Daily statistics overview
  - Total students count
  - Daily attendance tracking
  - Different memorization types tracking (حلقة, ثمن, حروف)
  - Hijri calendar integration

- **Student Management**
  - Add new students
  - View student profiles
  - Track individual progress

- **Reports System**
  - Daily records management
  - Monthly results tracking
  - Custom report generation
  - Student performance analytics

## Technical Stack

- **Frontend**: Flutter
- **Backend**: Supabase
- **State Management**: BLoC Pattern
- **Database**: PostgreSQL (via Supabase)
- **Authentication**: Supabase Auth

## Project Structure
ib/
├── features/
│ ├── auth/ # Authentication related code
│ ├── dashboard/ # Dashboard and statistics
│ ├── date/ # Hijri date management
│ ├── navbar/ # Navigation components
│ ├── reports/ # Reporting system
│ └── students/ # Student management



## Dependencies

- flutter_bloc: ^9.0.0
- supabase_flutter: ^2.6.2
- flutter_form_builder: ^9.5.0
- hijri: ^3.0.0
- flutter_native_splash: ^2.4.4
- And more...

## Getting Started

1. Clone the repository
bash
git clone https://github.com/yourusername/takyeem.git

2. Install dependencies
bash
flutter pub get

3. Set up environment variables

bash
cp .env.example .env

4. Run the app

bash
flutter run
