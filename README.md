📝 README.md

✅ Task Manager App
The Task Manager App is a modern, easy-to-use task management application built using SwiftUI and Core Data.
It allows users to:

Create tasks with titles and descriptions.
Mark tasks as completed.
Edit or delete tasks.
Sort and filter tasks by name, date, or completion status.
Toggle task details with a smooth animation.
🚀 Features
Add New Tasks: Quickly create tasks with a title and description.
Edit Tasks: Update the task title or details.
Delete Tasks: Swipe to remove tasks from the list.
Mark as Completed: Toggle completion status with a single tap.
Sorting Options: Sort tasks by:
Name: Alphabetical order.
Date: Newest to oldest.
Completion Status: Incomplete tasks first.
Filtering Options: Show:
All Tasks
Completed Tasks
Pending Tasks
Animated Task Details: Smooth transition when opening/closing task details.
Keyboard Navigation: Seamlessly manage tasks using keyboard shortcuts.
🏗️ Project Structure
TaskManagerApp/
├── TaskManagerApp.xcodeproj        # Xcode project file
├── TaskManagerApp.xcdatamodeld     # Core Data model file
├── TaskManagerApp/
│   ├── ContentView.swift           # Main content view
│   ├── TaskListView.swift          # Task list with sorting/filtering
│   ├── TaskDetailView.swift        # Task details view
│   └── Models/
│       └── Task.swift              # Core Data entity model
├── Tests/
│   └── TaskManagerUITests.swift    # XCTest UI tests
└── README.md                       # Project documentation
🛠️ Setup Instructions

📝 Prerequisites
Xcode 14+
iOS 18+
Swift 5+

📝 License

This project is licensed under the MIT License - see the LICENSE file for details.
