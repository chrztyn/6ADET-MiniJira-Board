# mini_jira_board
## Group Information

**Group Number: 1**
**Members and Role:**

- ***Domingo, Jasmeen Clarisse***  
    - Role: Testing, Bug Fixing & Final Review
- ***Lapuz, Mary Micah G.***
    - Role: Task Model & State Management
- ***Payawal, Kyle Eishley G.***
    - Role: Filters & Sprint Summary Logic
- ***Quiambao, Maxene P.***
    - Role: UI / Layout Design
- ***Yunun, Christine Mae D.***
    - Role: Project Lead , CRUD Operations 
 
## How to Run the App

1. Make sure Flutter is installed:

```bash
flutter doctor  
```
**Note:** If it shows the Flutter version and environment info, Flutter is installed correctly.  If not, follow the official Flutter installation guide: https://flutter.dev/docs/get-started/install

2. Navigate to the project folder:
```bash
cd mini_jira_board
```
3. Install dependencies:
```bash
flutter pub get
```
4. Run the app:
```bash
flutter run
```
  

## App Overview

MiniJira Board is a simple Flutter task management app inspired by Jira. It allows users to create, update, delete, and filter tasks using an in memory list.


**Feature Checklist**

1. CRUD Operations (Create, Read, Update, Delete)
2. Task list displayed using Cards and ListView
3. Sprint Summary (To Do / In Progress / Done) with live updates
4. Summary Card (Total / Done / Remaining)
5. Text counter for task description with color changes
6. Priority and Status dropdowns
7. Quick Filters (All / High Priority / Done)
8. Reusable widgets (StatBox, TaskCard, PriorityBadge)
