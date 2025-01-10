# Live It

**Live It** is a demo iOS application showcasing a modern and engaging video feed experience with features like user authentication, validation, custom UI components, and category-based content discovery.

---

## Features

### **Home Page**
- **Video Feed**: Displays trending videos with smooth scrolling.
- **Tabs**:
  - **For You**: Personalized content based on user preferences.
  - **Following**: Content from followed users.
  - **Discover**: Explore new categories and creators.

### **User Authentication**
- **Login**: Secure login with email and password validation.
- **Signup**:
  - Validates user age (must be 18 or older).
  - Ensures username uniqueness and valid characters.
  - First and Last name validation for proper formatting.
  - Allows users to upload a profile picture from a custom UI gallery.

### **Video Interests**
- Users can select categories of interest during onboarding to tailor content recommendations.

### **Custom UI Components**
- **Custom UI Gallery**: A polished and intuitive image selection component.
- **Video Feed**: Seamless video playback with pagination.

### **Validation**
- Comprehensive field validation for secure and accurate user data input.

---

## Technical Details

### **Tech Stack**
- **Language**: Swift
- **Frameworks**:
  - UIKit for UI design
  - Combine for reactive programming
  - Core Data for data persistence
- **Video Playback**: AVPlayer
- **Custom Gallery**: Image picker implemented with efficient memory management.

### **Architecture**
- **MVVM**: To separate logic and views for better scalability and testability.

---

## Screenshots


### App Demo:
<p align="left">
    <video alt="App Screenshots" src="https://raw.githubusercontent.com/Muniyaraj-ios/assets/main/live_it_onboard_page_ui_design.mp4"> </p>

---

## Installation

1. Clone the repository.
2. Open `Live It.xcworkspace` in Xcode.
3. Run the app on an iOS simulator or device.

---

## Future Enhancements
- Push notifications for trending videos.
- Enhanced personalization using ML recommendations.
