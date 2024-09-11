# todo1

A new Flutter project.

Flutter To-Do List App
A simple and functional To-Do list mobile application built using Flutter. This app allows users to manage their tasks locally and sync them with a remote API.

Features
Task Management:

Add, update, and delete tasks.
Each task contains a title, description, and due date.
Tasks can be marked as completed or pending.
Local Storage:

Tasks are stored locally using SQLite for persistent storage.
Even after closing the app, tasks will be available upon reopening.
API Sync:

Fetch tasks from an external REST API and save them locally.
Sync newly added or updated tasks with the remote API.
Example public API used: JSONPlaceholder.
Task Filtering:

Filter tasks based on their status (All, Completed, Pending).
User-friendly UI:

Responsive and easy-to-use interface for both Android and iOS devices.

Dependencies
The app uses the following dependencies:

sqflite: For local database storage using SQLite.
path: For managing file paths for SQLite.
shared_preferences: For storing user preferences locally (optional).
intl: For date formatting.
http: For API requests.

Notes
Ensure you have an active internet connection for the API sync feature to work.
Modify the API endpoints in api_service.dart if you're using a different API.
Future Improvements
Add authentication to sync tasks with a personal API.
Implement task reminders using notifications.
Add a dark mode option.