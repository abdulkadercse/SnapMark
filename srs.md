# Software Requirements Specification (SRS)

## SnapMark — Desktop Screenshot & Annotation Application

**Document Version:** 1.0
**Document Status:** Initial Product Specification
**Product Type:** Offline-first Desktop Application
**Target Platforms:** Windows, macOS, Linux
**Primary Framework:** Flutter
**Primary Language:** Dart
**Architecture:** Clean Architecture + Feature-First
**Application Category:** Screenshot Capture, Annotation & Screen Utility

---

# 1. Document Overview

## 1.1 Purpose

This Software Requirements Specification defines the functional, non-functional, technical, UI/UX, security, storage, architecture, and deployment requirements for **SnapMark**, a cross-platform desktop screenshot and annotation application.

SnapMark will allow users to:

* Capture screenshots quickly.
* Select a specific screen region.
* Capture full screens.
* Capture active windows.
* Capture screenshots across multiple monitors.
* Annotate screenshots.
* Draw arrows, lines, rectangles, circles, and freehand marks.
* Add text.
* Highlight important areas.
* Blur or pixelate sensitive information.
* Add numbered indicators.
* Undo and redo modifications.
* Copy screenshots directly to clipboard.
* Save screenshots locally.
* Maintain screenshot history.
* Operate primarily offline.
* Run in the background through the system tray.
* Trigger screenshot capture through configurable global keyboard shortcuts.

The product will be inspired by the simple and fast workflow of screenshot tools such as Lightshot, but will focus more strongly on **developer, SQA, bug-reporting, documentation, and technical communication workflows**.

---

# 2. Product Vision

## 2.1 Vision

SnapMark should provide the fastest possible workflow for:

> **Capture → Mark → Explain → Copy/Save**

The user should be able to capture a screen area and start annotating it within seconds.

The application should not require:

* Account registration
* Internet connection
* Cloud backend
* User login
* Online storage

for the core screenshot workflow.

---

# 3. Product Goals

## 3.1 Primary Goals

The system shall:

1. Provide instant screenshot capture.
2. Provide global keyboard shortcuts.
3. Provide a screen-selection overlay.
4. Provide powerful screenshot annotation tools.
5. Provide fast clipboard copying.
6. Provide local image saving.
7. Provide screenshot history.
8. Provide offline-first functionality.
9. Support multiple monitors.
10. Support Windows, macOS, and Linux.
11. Consume minimal system resources while running in the background.
12. Provide a clean and modern interface.
13. Provide developer/SQA-oriented annotation capabilities.

---

# 4. Target Users

## 4.1 Software Developers

Developers can use SnapMark to:

* Highlight bugs.
* Explain UI problems.
* Share implementation issues.
* Annotate screenshots for documentation.
* Explain code/UI behavior.
* Send marked screenshots to teammates.

## 4.2 SQA Engineers

SQA users can:

* Capture defects.
* Mark exact UI locations.
* Add bug numbers.
* Highlight expected/actual areas.
* Blur sensitive information.
* Prepare screenshots for bug reports.

## 4.3 UI/UX Designers

Designers can:

* Highlight UI elements.
* Mark spacing issues.
* Add comments.
* Indicate alignment problems.
* Annotate design references.

## 4.4 Customer Support

Support teams can:

* Capture customer issues.
* Mark instructions.
* Add numbered steps.
* Highlight buttons.
* Blur customer information.

## 4.5 General Users

General users can:

* Capture screenshots.
* Save images.
* Copy screenshots.
* Add simple annotations.

---

# 5. Product Scope

## 5.1 In Scope

### Screenshot

* Region capture
* Full-screen capture
* Active-window capture
* Multi-monitor capture
* Delayed capture
* Global hotkeys
* Screen overlay

### Annotation

* Pen
* Line
* Arrow
* Rectangle
* Circle
* Ellipse
* Text
* Highlight
* Blur
* Pixelate
* Number marker
* Eraser

### Editing

* Undo
* Redo
* Move
* Resize
* Rotate
* Delete
* Duplicate
* Crop
* Resize image

### Output

* Copy to clipboard
* Save
* Save As
* PNG
* JPG
* WEBP
* BMP

### Desktop

* System tray
* Background execution
* Startup with OS
* Global hotkeys
* Settings
* Local history

---

# 6. Out of Scope for MVP

The following features shall not be mandatory in Version 1.0:

* Cloud accounts
* User authentication
* Team collaboration
* Cloud storage
* Online sharing
* AI screenshot analysis
* AI bug detection
* Screen recording
* GIF recording
* Video editing
* Automatic cloud synchronization

These may be introduced in future versions.

---

# 7. Platform Requirements

## 7.1 Windows

The application shall support:

* Windows 10
* Windows 11

Target architecture:

* x64
* ARM64 where practical

Windows-specific integrations may be implemented through native Win32 APIs or Flutter desktop plugins.

---

# 7.2 macOS

The application shall support:

* Supported modern macOS versions according to the selected Flutter release.

Target architecture:

* Apple Silicon
* Intel where supported by the selected Flutter release

macOS-specific requirements include:

* Screen Recording permission.
* Accessibility permissions where required.
* Native screen capture integration.
* Native global hotkey integration.

---

# 7.3 Linux

The application shall support:

* Ubuntu LTS
* Debian-based Linux distributions

Initial target:

* Ubuntu 22.04+
* Debian 12+

The Linux implementation shall consider both:

* X11
* Wayland

because screen capture and global keyboard functionality can differ significantly between Linux display environments.

---

# 8. Functional Requirements

# FR-001 — Application Startup

The system shall start as a desktop application.

The user shall be able to:

* Launch the application normally.
* Launch the application minimized to tray.
* Configure startup behavior.
* Exit the application completely.

---

# FR-002 — Background Mode

The application shall support background execution.

When background mode is enabled:

```text
Application
     ↓
System Tray
     ↓
Global Hotkey
     ↓
Capture
```

The main application window shall not need to remain open.

---

# FR-003 — System Tray

The application shall provide a system tray icon.

The tray menu shall contain:

```text
SnapMark

Capture Region
Full Screen
Active Window
Recent Screenshots
Settings
About
Exit
```

---

# FR-004 — Global Hotkey

The application shall support configurable global keyboard shortcuts.

Default shortcut:

```text
Print Screen
```

Alternative shortcuts may include:

```text
Ctrl + Shift + S
Ctrl + Shift + A
```

The user shall be able to change shortcuts.

The system shall detect conflicts where possible.

---

# FR-005 — Region Capture

The user shall be able to capture a selected screen region.

Workflow:

```text
Global Hotkey
     ↓
Screen Dim
     ↓
Crosshair Cursor
     ↓
Mouse Down
     ↓
Drag
     ↓
Mouse Up
     ↓
Screenshot
```

---

# FR-006 — Screen Overlay

During region selection:

* The entire screen shall be dimmed.
* The selected area shall remain visually clear.
* Selection borders shall be visible.
* Cursor shall change to selection mode.
* Selection dimensions shall be displayed.

Example:

```text
Selected Area

800 × 450
```

---

# FR-007 — Selection Resize

After selecting an area, the user shall be able to:

* Resize horizontally.
* Resize vertically.
* Resize from corners.
* Resize from edges.
* Move the selection.
* Cancel selection.

---

# FR-008 — Keyboard Selection Control

The user shall be able to fine-tune selection using keyboard controls.

Example:

```text
Arrow Keys → Move
Shift + Arrow → Resize
Esc → Cancel
Enter → Capture
```

---

# FR-009 — Full Screen Capture

The system shall provide full-screen capture.

For multi-monitor environments:

```text
Screen 1
Screen 2
Screen 3
```

The user shall be able to select:

* Current monitor
* All monitors

---

# FR-010 — Active Window Capture

The system shall provide active-window capture where supported by the operating system.

The captured image shall contain the selected application window rather than the entire desktop.

---

# FR-011 — Delayed Capture

The application shall support delayed screenshots.

Supported delays:

```text
0 seconds
3 seconds
5 seconds
10 seconds
```

The user shall be able to configure a default delay.

---

# FR-012 — Screenshot Preview

After capture, the screenshot shall open in the annotation editor.

The editor shall display:

* Screenshot
* Annotation toolbar
* Color controls
* Thickness controls
* Undo
* Redo
* Copy
* Save
* Cancel

---

# 9. Annotation Requirements

# FR-013 — Freehand Pen

The user shall be able to draw freely over screenshots.

Properties:

* Color
* Thickness
* Opacity

---

# FR-014 — Straight Line

The user shall be able to draw straight lines.

Properties:

* Color
* Thickness
* Opacity

---

# FR-015 — Arrow

The user shall be able to draw arrows.

Properties:

* Start point
* End point
* Arrow-head type
* Color
* Thickness
* Opacity

Example:

```text
Problem ───────────────►
```

---

# FR-016 — Rectangle

The user shall be able to draw rectangles.

Properties:

* Border color
* Border thickness
* Fill color
* Fill opacity

---

# FR-017 — Circle / Ellipse

The user shall be able to draw:

* Circle
* Ellipse

Properties:

* Border
* Fill
* Opacity
* Thickness

---

# FR-018 — Text

The user shall be able to add text.

Text properties:

* Font family
* Font size
* Font weight
* Color
* Background
* Alignment
* Opacity

Example:

```text
BUG HERE
```

---

# FR-019 — Highlight

The system shall provide a highlighter tool.

The highlighter shall use semi-transparent rendering.

Properties:

* Color
* Thickness
* Opacity

---

# FR-020 — Blur

The system shall allow users to blur selected areas.

Use cases:

* Email
* Phone number
* Personal information
* API keys
* Passwords
* Customer data

The blur tool shall support rectangular selection.

---

# FR-021 — Pixelate

The system shall provide pixelation as an alternative to blur.

Example:

```text
Sensitive Information
████████████████████
```

---

# FR-022 — Number Marker

The system shall provide automatic numbered indicators.

Example:

```text
①
②
③
④
```

When the user creates a new marker, the system shall automatically increment the number.

The user shall be able to reset numbering.

---

# FR-023 — Eraser

The user shall be able to remove annotations.

Two modes:

1. Object eraser.
2. Freehand eraser where applicable.

---

# FR-024 — Annotation Selection

The user shall be able to select an annotation object.

Selected objects shall provide controls for:

* Move
* Resize
* Delete
* Duplicate
* Rotate

---

# FR-025 — Annotation Layer

Annotations shall not permanently modify the original screenshot until export.

The editor shall maintain:

```text
Original Screenshot
        +
Annotation Objects
        ↓
Final Render
```

This is required to support reliable:

* Undo
* Redo
* Editing
* Object movement
* Object deletion

---

# FR-026 — Undo

The user shall be able to undo annotation actions.

Shortcut:

```text
Ctrl + Z
```

macOS:

```text
Command + Z
```

---

# FR-027 — Redo

The user shall be able to redo previously undone actions.

Shortcut:

```text
Ctrl + Shift + Z
```

macOS:

```text
Command + Shift + Z
```

---

# FR-028 — Crop

The user shall be able to crop screenshots after capture.

---

# FR-029 — Image Resize

The user shall be able to resize screenshots.

Options:

```text
Original
25%
50%
75%
Custom
```

---

# FR-030 — Image Rotation

The user shall be able to rotate screenshots:

```text
90° clockwise
90° counter-clockwise
180°
```

---

# 10. Clipboard Requirements

# FR-031 — Copy Screenshot

The user shall be able to copy the final screenshot directly to the system clipboard.

Shortcut:

```text
Ctrl + C
```

macOS:

```text
Command + C
```

The clipboard shall contain image data.

---

# FR-032 — Copy Without Saving

The user shall be able to copy a screenshot without saving it to disk.

This is an important requirement for fast workflows.

---

# 11. Save Requirements

# FR-033 — Save Screenshot

The user shall be able to save screenshots locally.

Default format:

```text
PNG
```

Supported formats:

```text
PNG
JPG/JPEG
WEBP
BMP
```

---

# FR-034 — Save As

The user shall be able to select:

* File name
* Directory
* Format

---

# FR-035 — Default Save Directory

The application shall provide a configurable default save directory.

Default:

```text
Pictures/SnapMark
```

---

# FR-036 — Automatic File Naming

The application shall generate unique filenames.

Example:

```text
SnapMark_2026-08-25_20-30-45.png
```

---

# 12. Screenshot History

# FR-037 — History

The system shall maintain local screenshot history.

History information:

* ID
* File path
* Thumbnail
* Created date
* Created time
* Width
* Height
* File size
* Favorite status

---

# FR-038 — History Search

Users shall be able to search history.

Search options:

* Filename
* Date
* Favorite

---

# FR-039 — History Preview

Clicking a history item shall open its preview.

Actions:

```text
Open
Copy
Edit
Save As
Delete
Show in Folder
```

---

# FR-040 — Delete History

Users shall be able to delete screenshots from history.

The system shall display confirmation before permanent deletion.

---

# FR-041 — Favorites

Users shall be able to mark screenshots as favorites.

---

# 13. Settings

# FR-042 — General Settings

Settings shall include:

```text
Start with system
Minimize to tray
Show notifications
Confirm before delete
```

---

# FR-043 — Capture Settings

Settings:

```text
Default capture mode
Default delay
Show cursor
Show selection dimensions
Freeze screen during selection
```

---

# FR-044 — Annotation Settings

Settings:

```text
Default color
Default thickness
Default opacity
Default font
Default font size
Default highlight color
```

---

# FR-045 — Save Settings

Settings:

```text
Default format
Default directory
Automatic naming
JPEG quality
WEBP quality
```

---

# FR-046 — Hotkey Settings

The user shall be able to configure:

```text
Region Capture
Full Screen
Active Window
Cancel
```

---

# 14. Application UI

# FR-047 — Main Dashboard

The application main window shall contain:

```text
┌─────────────────────────────────────────────┐
│ SnapMark                         — □ ×     │
├─────────────────────────────────────────────┤
│                                             │
│       Capture Screenshot                    │
│                                             │
│    ┌──────────────┐  ┌──────────────┐      │
│    │   Region     │  │ Full Screen  │      │
│    └──────────────┘  └──────────────┘      │
│                                             │
│    ┌──────────────┐                         │
│    │ Active Window│                         │
│    └──────────────┘                         │
│                                             │
│ Recent Screenshots                          │
│                                             │
│ [Image] [Image] [Image] [Image]             │
│                                             │
└─────────────────────────────────────────────┘
```

---

# FR-048 — Annotation Editor

The annotation editor shall be the primary workspace.

Suggested structure:

```text
┌──────────────────────────────────────────────┐
│ Undo Redo | Tools | Colors | Copy | Save    │
├──────────────────────────────────────────────┤
│                                              │
│                                              │
│             Screenshot Canvas               │
│                                              │
│                                              │
├──────────────────────────────────────────────┤
│ Zoom: 100%                    1200 × 800      │
└──────────────────────────────────────────────┘
```

---

# 15. Zoom

# FR-049 — Canvas Zoom

The editor shall support:

```text
25%
50%
75%
100%
150%
200%
400%
```

The user shall also be able to use:

```text
Ctrl + Mouse Wheel
```

for zoom.

---

# 16. Pan

# FR-050 — Canvas Pan

When zoomed in, users shall be able to pan the screenshot.

Supported:

* Mouse drag
* Middle mouse button
* Trackpad gesture where supported

---

# 17. Keyboard Shortcuts

Recommended default shortcuts:

| Action         | Windows/Linux       | macOS                       |
| -------------- | ------------------- | --------------------------- |
| Region Capture | Print Screen        | Print Screen / configurable |
| Full Screen    | Ctrl + Print Screen | Cmd + Shift + 3             |
| Copy           | Ctrl + C            | Cmd + C                     |
| Save           | Ctrl + S            | Cmd + S                     |
| Undo           | Ctrl + Z            | Cmd + Z                     |
| Redo           | Ctrl + Shift + Z    | Cmd + Shift + Z             |
| Delete         | Delete              | Delete                      |
| Escape         | Esc                 | Esc                         |
| Zoom           | Ctrl + Wheel        | Cmd + Wheel                 |

The exact default hotkeys shall remain configurable because operating-system shortcuts may conflict.

---

# 18. Notifications

The system may show desktop notifications for:

* Screenshot saved.
* Screenshot copied.
* Screenshot deleted.
* Update available.

Notifications shall be configurable.

---

# 19. Offline Requirements

The core application shall function without an internet connection.

Offline features shall include:

* Screenshot capture.
* Annotation.
* Copy.
* Save.
* History.
* Settings.
* Local search.
* Local image processing.

No internet connection shall be required for these features.

---

# 20. Optional Online Features

Future versions may include:

* Cloud upload.
* Share links.
* Account synchronization.
* Team collaboration.
* Cloud history.
* Remote access.
* AI features.

These features shall be isolated from the offline core.

---

# 21. Data Model

## 21.1 Screenshot

```text
Screenshot
-------------------------
id
filePath
thumbnailPath
fileName
width
height
fileSize
format
createdAt
updatedAt
isFavorite
```

---

# 22. Annotation Model

Each annotation shall contain:

```text
Annotation
-------------------------
id
screenshotId
type
position
size
rotation
color
opacity
strokeWidth
text
fontSize
zIndex
metadata
```

---

# 23. Annotation Types

Supported types:

```text
pen
line
arrow
rectangle
circle
ellipse
text
highlight
blur
pixelate
number
```

---

# 24. Local Database

A local database shall be used for metadata.

Recommended:

```text
SQLite
```

with:

```text
Drift
```

as the Flutter data-access layer.

The database shall not store large screenshot binaries by default.

Instead:

```text
Database
   ↓
Metadata
   ↓
File Path
   ↓
Image File
```

---

# 25. File Storage

Recommended structure:

```text
Application Data
│
├── database/
│
├── thumbnails/
│
├── cache/
│
└── logs/
```

User screenshots:

```text
Pictures/
└── SnapMark/
    ├── 2026/
    │   ├── 08/
    │   │   ├── SnapMark_001.png
    │   │   └── SnapMark_002.png
```

---

# 26. Cache Management

The application shall maintain temporary files separately.

The system shall provide:

```text
Clear Cache
```

The user shall be informed before deleting cache files.

---

# 27. Architecture

The recommended architecture is:

```text
Presentation
      ↓
Application
      ↓
Domain
      ↓
Data
      ↓
Platform Services
```

---

# 28. Recommended Flutter Project Structure

```text
lib/
│
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme.dart
│
├── core/
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   ├── utils/
│   └── services/
│
├── features/
│
│   ├── capture/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── editor/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── history/
│   │
│   ├── settings/
│   │
│   ├── clipboard/
│   │
│   └── system_tray/
│
├── shared/
│   ├── widgets/
│   ├── models/
│   └── components/
│
└── main.dart
```

---

# 29. State Management

Recommended:

```text
Riverpod
```

State categories:

```text
CaptureState
EditorState
AnnotationState
HistoryState
SettingsState
HotkeyState
SystemTrayState
```

---

# 30. Screenshot Service

An abstraction shall be created:

```dart
abstract class ScreenCaptureService {
  Future<List<ScreenInfo>> getScreens();

  Future<Uint8List> captureFullScreen();

  Future<Uint8List> captureRegion(Rect region);

  Future<Uint8List> captureWindow(WindowInfo window);
}
```

Platform implementations:

```text
WindowsScreenCaptureService
MacOSScreenCaptureService
LinuxScreenCaptureService
```

---

# 31. Platform Integration

Flutter can provide the common application/UI layer, while native/platform-specific functionality can be implemented through plugins or native code where necessary. Flutter explicitly supports writing platform-specific plugins and native integrations for desktop.

Required platform services:

```text
Global Hotkey
Screen Capture
Window Detection
Clipboard
System Tray
Startup
File Dialog
Notifications
Screen Permissions
```

---

# 32. Windows Native Integration

Potential responsibilities:

```text
Win32
│
├── Global Hotkey
├── Screen Capture
├── Window Enumeration
├── Active Window Detection
├── Clipboard
├── System Tray
└── Startup Registration
```

Flutter's Windows desktop environment supports native C/C++ integration and Win32 APIs where required.

---

# 33. macOS Native Integration

Potential responsibilities:

```text
macOS
│
├── ScreenCaptureKit
├── CGWindow
├── NSPasteboard
├── Global Event APIs
├── NSStatusItem
└── LaunchAtLogin
```

The application shall properly handle macOS screen-recording permissions.

---

# 34. Linux Native Integration

Potential responsibilities:

```text
Linux
│
├── X11
├── Wayland
├── GTK
├── Clipboard
├── System Tray
└── Desktop Notifications
```

Linux support shall be tested separately under X11 and Wayland.

Flutter provides Linux desktop integration and allows applications/plugins to bind to native Linux libraries and code.

---

# 35. Performance Requirements

## NFR-001 — Startup

Application startup target:

```text
< 2 seconds
```

on a modern desktop.

---

# 36. Capture Performance

Region capture should normally complete within:

```text
< 500 ms
```

under normal system conditions.

Large or multi-monitor captures may require additional processing time.

---

# 37. Annotation Performance

The editor should maintain smooth interaction at:

```text
60 FPS target
```

for normal screenshot sizes.

---

# 38. Memory Usage

When idle in system tray:

Target:

```text
< 100 MB RAM
```

The exact limit shall be validated during performance testing.

---

# 39. CPU Usage

When idle:

```text
CPU < 2%
```

except during:

* Screenshot capture
* Image processing
* Export
* OCR
* Thumbnail generation

---

# 40. Large Image Support

The application shall support screenshots from:

* Full HD
* 2K
* 4K
* 5K
* High-DPI monitors

The application should avoid unnecessary duplicate image buffers.

---

# 41. High DPI

The application shall support:

* Windows scaling
* Retina displays
* High-DPI Linux displays

Screenshot coordinates must correctly map between:

```text
Logical Pixels
```

and

```text
Physical Pixels
```

---

# 42. Multi-Monitor Requirements

The application shall support:

```text
Monitor 1
Monitor 2
Monitor 3
```

with different:

* Resolutions
* Scaling factors
* Positions
* Orientations

---

# 43. Security Requirements

## NFR-001 — Local Privacy

Screenshots shall remain local by default.

The application shall not upload screenshots without explicit user action.

---

# 44. Sensitive Data

Blur/pixelate tools shall help users protect:

* Passwords
* API keys
* Emails
* Phone numbers
* Personal information
* Customer information

---

# 45. No Automatic Cloud Upload

The MVP shall not automatically upload screenshots.

---

# 46. Permission Handling

The application shall clearly explain required OS permissions.

Example:

```text
SnapMark needs Screen Recording permission
to capture your screen.
```

The user shall be directed to the relevant system settings.

---

# 47. Error Handling

The system shall gracefully handle:

* Capture failure.
* Permission denied.
* Invalid region.
* Clipboard failure.
* File permission failure.
* Disk full.
* Unsupported image format.
* Hotkey conflict.
* Monitor unavailable.
* Corrupted screenshot.
* Database failure.

---

# 48. Error Message Format

Errors shall be user-friendly.

Bad:

```text
Exception: PlatformException(-123)
```

Good:

```text
Unable to capture the screen.

Please make sure SnapMark has
screen recording permission.
```

---

# 49. Logging

The application shall maintain local logs.

Log categories:

```text
INFO
WARNING
ERROR
DEBUG
```

Logs shall not contain screenshot image data.

Sensitive information shall not be logged.

---

# 50. Crash Handling

The application shall prevent one feature failure from crashing the entire application where possible.

Example:

```text
OCR failure
      ↓
Screenshot still works
```

---

# 51. Accessibility

The application shall support:

* Keyboard navigation.
* Tooltips.
* Accessible button labels.
* Sufficient contrast.
* Resizable UI.
* Keyboard shortcuts.

---

# 52. UI/UX Design Requirements

The design shall be:

* Minimal.
* Modern.
* Fast.
* Clean.
* Developer-friendly.
* Non-distracting.

Recommended visual style:

```text
Background:
#F8F9FA

Surface:
#FFFFFF

Primary:
#2563EB

Text:
#111827

Border:
#E5E7EB
```

The exact branding palette may be changed later.

---

# 53. Editor Toolbar

Recommended toolbar:

```text
Select
Pen
Line
Arrow
Rectangle
Circle
Highlight
Text
Blur
Pixelate
Number
Eraser
```

Secondary controls:

```text
Color
Thickness
Opacity
Font
```

---

# 54. Contextual Toolbar

The toolbar should adapt according to the selected tool.

For example:

```text
Arrow selected

Color | Thickness | Arrow Head
```

Text selected:

```text
Font | Size | Weight | Color | Background
```

Blur selected:

```text
Blur Strength
```

---

# 55. Keyboard Workflow

Example:

```text
Print Screen
      ↓
Select Area
      ↓
Enter
      ↓
Arrow Tool
      ↓
Draw
      ↓
Number Tool
      ↓
Add ①
      ↓
Copy
      ↓
Paste into Slack/Jira/Email
```

This workflow should require minimal clicks.

---

# 56. Screenshot Export Pipeline

```text
Screen
 ↓
Raw Screenshot
 ↓
Crop
 ↓
Annotation Layer
 ↓
Render
 ↓
Image Encoder
 ↓
PNG/JPG/WEBP
 ↓
File / Clipboard
```

---

# 57. Annotation Rendering

The editor shall use object-based rendering.

Each object should have:

```text
Position
Size
Rotation
Color
Opacity
Stroke
Z-index
```

This allows non-destructive editing.

---

# 58. Z-Index

Annotations shall support layering.

Example:

```text
Screenshot
   ↓
Highlight
   ↓
Rectangle
   ↓
Arrow
   ↓
Text
```

---

# 59. File Naming

Default format:

```text
SnapMark_YYYY-MM-DD_HH-MM-SS.png
```

Example:

```text
SnapMark_2026-08-25_20-45-30.png
```

---

# 60. Auto Save

Optional auto-save shall be available.

The user can configure:

```text
Never
Always
Ask every time
```

---

# 61. Temporary Capture

Screenshots copied to clipboard without saving may be stored temporarily in memory/cache.

Temporary data shall be cleaned according to configurable retention rules.

---

# 62. Storage Cleanup

Settings shall include:

```text
Clear History
Clear Cache
Delete All Screenshots
```

Dangerous operations shall require confirmation.

---

# 63. Import Image

The editor shall support importing existing images.

Supported:

```text
PNG
JPG
JPEG
WEBP
BMP
```

Workflow:

```text
Open Image
      ↓
Editor
      ↓
Annotate
      ↓
Save
```

---

# 64. Drag and Drop

Users shall be able to drag image files into the application editor.

---

# 65. Print

Future MVP+ feature:

```text
Screenshot
    ↓
Print
```

The application shall use the platform print dialog.

---

# 66. OCR — Future Feature

Version 2 may provide:

```text
Screenshot
     ↓
OCR
     ↓
Extracted Text
```

Users can:

* Copy text.
* Search text.
* Export text.

---

# 67. Cloud Sharing — Future Feature

Future architecture:

```text
Desktop
   ↓
Upload API
   ↓
Cloud Storage
   ↓
Share URL
```

The user must explicitly initiate upload.

---

# 68. Optional Backend

MVP:

```text
NO BACKEND
```

Future cloud version:

```text
Frontend:
Flutter Desktop

Backend:
Django REST Framework

Database:
PostgreSQL

Storage:
S3-compatible object storage
```

---

# 69. Future User Accounts

Future versions may provide:

```text
Register
Login
Profile
Devices
Cloud History
```

This shall not be part of the offline MVP.

---

# 70. Future Team Features

Potential future functionality:

```text
Workspace
Teams
Projects
Shared Screenshots
Comments
Permissions
```

---

# 71. Future Developer Features

Developer-focused roadmap:

```text
Bug Marker
Expected/Actual Labels
Step Numbering
Console Screenshot
Code Highlight
JSON Highlight
API Response Screenshot
```

---

# 72. Future SQA Features

Potential:

```text
Bug Report Mode
Severity Marker
Expected Result
Actual Result
Steps
Environment
Screenshot
```

Example:

```text
BUG #104

Expected:
Login should succeed.

Actual:
Login button does nothing.
```

---

# 73. Future Screen Recording

Possible future module:

```text
Screen Recorder
   ↓
MP4
GIF
WebM
```

Recording shall be implemented separately from screenshot capture to avoid increasing MVP complexity.

---

# 74. Application Lifecycle

```text
Start
 ↓
Initialize Services
 ↓
Load Settings
 ↓
Initialize Database
 ↓
Initialize Tray
 ↓
Register Hotkeys
 ↓
Wait
```

Capture:

```text
Hotkey
 ↓
Capture Mode
 ↓
Overlay
 ↓
Selection
 ↓
Screenshot
 ↓
Editor
```

Exit:

```text
Exit Request
 ↓
Unregister Hotkeys
 ↓
Dispose Tray
 ↓
Close Database
 ↓
Exit
```

---

# 75. State Machine — Capture

```text
IDLE
 ↓
CAPTURE_REQUESTED
 ↓
OVERLAY_ACTIVE
 ↓
SELECTING
 ↓
REGION_SELECTED
 ↓
CAPTURING
 ↓
CAPTURE_COMPLETE
 ↓
EDITOR_OPEN
```

Cancel:

```text
SELECTING
 ↓
CANCELLED
 ↓
IDLE
```

---

# 76. State Machine — Editor

```text
EDITOR_OPEN
 ↓
READY
 ↓
EDITING
 ↓
EXPORTING
 ↓
EXPORTED
```

---

# 77. Testing Requirements

The project shall use:

* Unit testing.
* Widget testing.
* Integration testing.
* Platform testing.
* Performance testing.
* Manual UX testing.

---

# 78. Unit Testing

Test:

* Annotation models.
* Coordinate conversion.
* Undo/redo.
* Numbering.
* File naming.
* Settings.
* History.
* Image metadata.

---

# 79. Widget Testing

Test:

* Toolbar.
* Editor.
* Settings.
* History.
* Capture UI.
* Dialogs.

---

# 80. Integration Testing

Test:

```text
Hotkey
 ↓
Overlay
 ↓
Selection
 ↓
Capture
 ↓
Editor
 ↓
Annotation
 ↓
Copy
```

---

# 81. Platform Testing

Each release shall be tested independently on:

```text
Windows
macOS
Linux X11
Linux Wayland
```

---

# 82. Multi-Monitor Testing

Test configurations:

```text
1 monitor
2 monitors
3 monitors
Mixed resolution
Mixed scaling
Different monitor positions
Portrait + landscape
```

---

# 83. Performance Testing

Test:

* 1080p screenshot.
* 1440p screenshot.
* 4K screenshot.
* Multi-monitor screenshot.
* Large annotations.
* 100+ annotations.
* Long editor sessions.

---

# 84. Security Testing

Verify:

* No unexpected network uploads.
* Screenshot files remain local.
* Logs do not contain sensitive screenshot data.
* Cloud features require explicit action.
* Temporary files are cleaned.
* Permissions are handled correctly.

---

# 85. Acceptance Criteria

The MVP shall be considered complete when:

### Capture

* [ ] Region capture works.
* [ ] Full-screen capture works.
* [ ] Active-window capture works where supported.
* [ ] Global hotkey works.
* [ ] Multi-monitor capture works.
* [ ] Selection overlay works.

### Annotation

* [ ] Pen works.
* [ ] Line works.
* [ ] Arrow works.
* [ ] Rectangle works.
* [ ] Circle works.
* [ ] Text works.
* [ ] Highlight works.
* [ ] Blur works.
* [ ] Pixelate works.
* [ ] Number marker works.
* [ ] Eraser works.

### Editor

* [ ] Undo works.
* [ ] Redo works.
* [ ] Move works.
* [ ] Resize works.
* [ ] Delete works.
* [ ] Zoom works.
* [ ] Pan works.

### Output

* [ ] Copy works.
* [ ] Save works.
* [ ] Save As works.
* [ ] PNG works.
* [ ] JPG works.
* [ ] WEBP works.

### Desktop

* [ ] System tray works.
* [ ] Startup option works.
* [ ] Settings work.
* [ ] Offline operation works.

---

# 86. MVP Release Definition

Version 1.0 shall contain:

```text
                    SnapMark v1.0
                         │
        ┌────────────────┼────────────────┐
        │                │                │
     Capture          Editor           Output
        │                │                │
   Region             Pen              Copy
   Full Screen        Arrow            Save
   Window             Line             Save As
   Multi Monitor      Rectangle        PNG
   Delay              Circle           JPG
   Hotkey             Text             WEBP
                      Highlight
                      Blur
                      Pixelate
                      Number
                      Undo/Redo
                         │
                      History
                         │
                      Settings
```

---

# 87. Version Roadmap

## Version 1.0

Core screenshot application.

```text
Capture
Annotation
Copy
Save
History
Hotkey
Tray
Settings
```

## Version 1.1

```text
OCR
Crop
Resize
Rotate
Import
Drag & Drop
Better History
```

## Version 1.5

```text
Scrolling Screenshot
Screen Recording
GIF
Advanced Export
```

## Version 2.0

```text
Cloud Sharing
Accounts
Share Links
Team Workspace
```

## Version 2.5

```text
AI Screenshot Analysis
AI Bug Report
AI OCR
AI Description
```

---

# 88. Recommended Package Categories

The final package selection should be validated against the target Flutter version and each platform.

Recommended categories:

```text
State Management
    Riverpod

Database
    Drift + SQLite

File System
    path_provider
    file_picker

Window Management
    desktop window package

System Tray
    desktop tray package

Keyboard
    global hotkey package / native implementation

Image
    image package

Notifications
    desktop notification package

Clipboard
    desktop clipboard package
```

For critical functionality such as global hotkeys and screen capture, the implementation shall not blindly depend on a single third-party package. A platform abstraction must exist so that native APIs can be introduced if package behavior is insufficient.

---

# 89. Dependency Strategy

Dependencies shall be classified as:

### Core

Required for application operation.

### Optional

Required for non-MVP functionality.

### Platform-specific

Used only on:

```text
Windows
macOS
Linux
```

The project shall avoid unnecessary dependencies.

---

# 90. Build Requirements

Flutter supports building native desktop applications for Windows, macOS, and Linux.

Build commands shall include equivalents of:

```bash
flutter build windows
flutter build macos
flutter build linux
```

Flutter's official desktop deployment documentation provides platform-specific build and release guidance.

---

# 91. Distribution

## Windows

Potential formats:

```text
EXE Installer
MSIX
Microsoft Store
Portable ZIP
```

## macOS

Potential formats:

```text
DMG
PKG
Mac App Store
```

## Linux

Potential formats:

```text
AppImage
DEB
RPM
Snap
```

The first Linux release should preferably provide:

```text
AppImage
DEB
```

---

# 92. Auto Update

MVP:

```text
Manual update
```

Future:

```text
Automatic Update
```

Update system shall:

* Check version.
* Notify user.
* Download update.
* Install update.
* Roll back if update fails where feasible.

---

# 93. Analytics

The offline MVP shall not require analytics.

If analytics are introduced later:

* Must be opt-in or clearly disclosed according to product/privacy requirements.
* No screenshot images shall be transmitted.
* No screenshot contents shall be collected.

---

# 94. Privacy Policy Requirements

If cloud functionality is added, the product shall clearly disclose:

* What data is collected.
* What data is uploaded.
* How long data is retained.
* How users delete data.
* Whether screenshots are processed by third-party services.

---

# 95. Localization

MVP language:

```text
English
```

Future:

```text
Bangla
Arabic
Hindi
Spanish
French
German
```

The application shall use localization-ready strings from the beginning.

---

# 96. Theme

The application shall support:

```text
Light
Dark
System
```

The screenshot itself shall never be affected by the application's theme.

---

# 97. Accessibility

The application shall provide:

* Keyboard navigation.
* Tooltips.
* Focus indicators.
* Screen-reader-compatible labels where applicable.
* Adjustable text sizes where practical.

---

# 98. Reliability Requirements

The application should not lose the user's screenshot because of an annotation operation failure.

Where feasible:

```text
Capture
 ↓
Temporary image
 ↓
Editor
 ↓
Export
```

The original capture shall remain available until the editing session ends.

---

# 99. Disaster Recovery

Because the application is local-first, disaster recovery shall focus on local files.

The user shall be responsible for normal filesystem backup.

The application shall provide:

```text
Show Screenshot Folder
```

to allow users to back up screenshots using normal OS backup mechanisms.

---

# 100. Non-Functional Summary

| Requirement   | Target               |
| ------------- | -------------------- |
| Startup       | < 2 sec target       |
| Idle CPU      | < 2% target          |
| Idle RAM      | < 100 MB target      |
| Capture       | < 500 ms target      |
| Editor        | 60 FPS target        |
| Offline       | Fully supported      |
| Platforms     | Windows/macOS/Linux  |
| High DPI      | Required             |
| Multi-monitor | Required             |
| Accessibility | Required             |
| Security      | Local-first          |
| Cloud         | Not required for MVP |

---

# 101. Core Product Principle

The application must always prioritize:

```text
SPEED
  ↓
SIMPLICITY
  ↓
ACCURACY
  ↓
ANNOTATION
  ↓
OUTPUT
```

The user should never need to open a complicated editor just to mark an arrow on a screenshot.

---

# 102. Primary User Journey

```text
User working on computer
        ↓
Finds a problem
        ↓
Presses Print Screen
        ↓
Screen becomes dim
        ↓
Selects problem area
        ↓
Screenshot captured
        ↓
Annotation toolbar appears
        ↓
Draws rectangle
        ↓
Adds arrow
        ↓
Adds "BUG HERE"
        ↓
Adds number ①
        ↓
Clicks Copy
        ↓
Pastes into Jira / Slack / Email
```

Target:

**Capture-to-Copy should be extremely fast.**

---

# 103. Developer/SQA Differentiator

SnapMark should not be positioned only as:

> Screenshot Tool

It should be positioned as:

> **Screenshot + Visual Bug Indication Tool**

The strongest differentiating features should therefore be:

```text
① Numbered Steps
② Bug Marker
③ Arrow
④ Highlight
⑤ Blur / Pixelate
⑥ Text
⑦ Quick Copy
⑧ Developer/SQA Workflow
```

---

# 104. Future Bug Report Mode

A future dedicated mode may provide:

```text
┌─────────────────────────────────────┐
│ Bug Report Screenshot               │
├─────────────────────────────────────┤
│                                     │
│ Screenshot                          │
│                                     │
├─────────────────────────────────────┤
│ Title: Login button not working     │
│                                     │
│ Expected: Login should succeed      │
│ Actual: Nothing happens             │
│                                     │
│ Steps:                              │
│ ① Enter email                       │
│ ② Enter password                    │
│ ③ Click Login                       │
└─────────────────────────────────────┘
```

This can later integrate with:

```text
Jira
GitHub Issues
GitLab
Linear
Trello
ClickUp
```

---

# 105. Future Screen Recording Mode

The same application can eventually become:

```text
SnapMark
│
├── Screenshot
├── Annotation
├── Screen Recording
├── GIF Recording
├── OCR
└── Bug Reporting
```

This gives the product a much larger long-term scope without making the MVP complicated.

---

# 106. Recommended Development Phases

## Phase 1 — Technical Prototype

Duration target:

```text
1–2 weeks
```

Build only:

```text
Global Hotkey
Screen Overlay
Region Selection
Screen Capture
Basic Editor
Arrow
Rectangle
Copy
Save
```

Goal:

**Prove the hardest technical parts first.**

---

## Phase 2 — Core MVP

Build:

```text
All capture modes
All annotation tools
Undo/Redo
Clipboard
History
Settings
System Tray
```

---

## Phase 3 — Cross Platform

Test separately:

```text
Windows
macOS
Linux X11
Linux Wayland
```

---

## Phase 4 — Optimization

Optimize:

```text
Startup
Memory
CPU
Image rendering
Multi-monitor
4K screenshots
```

---

## Phase 5 — Release

Create:

```text
Windows Installer
macOS DMG
Linux AppImage
Linux DEB
```

---

# 107. Final MVP Feature Matrix

| Module   | Feature            | Priority |
| -------- | ------------------ | -------: |
| Capture  | Region             |       P0 |
| Capture  | Full Screen        |       P0 |
| Capture  | Active Window      |       P0 |
| Capture  | Multi Monitor      |       P0 |
| Capture  | Delay              |       P1 |
| Capture  | Global Hotkey      |       P0 |
| Editor   | Pen                |       P0 |
| Editor   | Line               |       P0 |
| Editor   | Arrow              |       P0 |
| Editor   | Rectangle          |       P0 |
| Editor   | Circle             |       P0 |
| Editor   | Text               |       P0 |
| Editor   | Highlight          |       P0 |
| Editor   | Blur               |       P0 |
| Editor   | Pixelate           |       P1 |
| Editor   | Number             |       P0 |
| Editor   | Eraser             |       P0 |
| Editor   | Undo               |       P0 |
| Editor   | Redo               |       P0 |
| Editor   | Crop               |       P1 |
| Output   | Copy               |       P0 |
| Output   | Save               |       P0 |
| Output   | Save As            |       P0 |
| Output   | PNG                |       P0 |
| Output   | JPG                |       P1 |
| Output   | WEBP               |       P1 |
| History  | Screenshot History |       P1 |
| History  | Favorites          |       P2 |
| Desktop  | System Tray        |       P0 |
| Desktop  | Startup            |       P1 |
| Desktop  | Notifications      |       P2 |
| Settings | Hotkeys            |       P0 |
| Settings | Capture            |       P0 |
| Settings | Annotation         |       P1 |
| Settings | Save               |       P1 |
| Platform | Windows            |       P0 |
| Platform | macOS              |       P0 |
| Platform | Linux              |       P0 |
| Cloud    | Upload             |       P2 |
| Cloud    | Share Link         |       P2 |
| AI       | OCR                |       P2 |
| AI       | AI Bug Report      |       P3 |
| Video    | Screen Recording   |       P3 |

---

# 108. Final Technical Recommendation

The recommended final architecture is:

```text
                         SNAPMARK
                            │
              ┌─────────────┴─────────────┐
              │                           │
        Flutter Application         Native Platform Layer
              │                           │
       ┌──────┼──────┐           ┌────────┼────────┐
       │      │      │           │        │        │
    Capture Editor History     Windows   macOS   Linux
       │      │      │           │        │        │
       └──────┼──────┘           └────────┼────────┘
              │                           │
              └───────────┬───────────────┘
                          │
                    Local Storage
                          │
                    SQLite + Files
```

Flutter is a good fit for the common UI/application layer because it officially supports native Windows, macOS, and Linux desktop applications and provides mechanisms for platform-specific plugins/native code.

The **most important architectural decision** is to keep screenshot capture, global hotkeys, clipboard, system tray, window detection, and permission handling behind platform abstractions. Do **not** put Windows/macOS/Linux-specific code directly into your editor UI.

---

# 109. Final Product Definition

**SnapMark is an offline-first cross-platform desktop screenshot and annotation application designed to capture, mark, explain, and share screen information quickly.**

Its primary workflow is:

```text
CAPTURE
   ↓
SELECT
   ↓
ANNOTATE
   ↓
MARK
   ↓
COPY / SAVE
```

Its primary target users are:

```text
Developers
SQA Engineers
Designers
Support Teams
Technical Teams
General Desktop Users
```

Its core differentiator is:

> **Fast screenshot capture combined with professional visual indication tools for bugs, instructions, and technical communication.**

The MVP should remain completely focused on this workflow. Cloud, AI, OCR, screen recording, collaboration, and other advanced features should be added only after the core capture and annotation engine is stable.
