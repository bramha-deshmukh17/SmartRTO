# SmartRTO

SmartRTO is a mobile application designed to streamline the processes related to road transport operations. It provides functionalities for officers to manage their profiles, handle service requests, and ensure efficient communication.

## Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)
- [Contributing](#contributing)

## Features

- User authentication (sign up, login, logout)
- Profile management for officers
- Fetching officer data from Firestore
- Progress indicators for loading states
- Support for multiple languages (if applicable)

## Technologies Used

- **Flutter**: For building the UI.
- **Firebase**: For backend services like authentication and Firestore.
- **Dart**: Programming language used for Flutter development.

## Setup Instructions

1. **Clone the repository**:
    ```bash
    git clone https://github.com/bramha-deshmukh17/SmartRTO.git
    ```

2. **Navigate to the project directory**:
    ```bash
    cd SmartRTO
    ```

3. **Install dependencies**:
    ```bash
    flutter pub get
    ```

4. **Configure Firebase**:
   - Set up a Firebase project and add the necessary configurations to your app.
   - Also add support for the firebase authentication, firestore and storage for both Android and iOS.

5. Configure *.env*
   - add follwing data to it
     ```bash
     GEMINI_API=YOUR_GRMINI_API_KEY_FROM_GOOGLE
     RAZOR_PAY_API=YOUR_RAZORPAY_API_KEY
     ```
        

5. **Run the application**:
    ```bash
    flutter run
    ```

## Usage

After setting up the application, you can create an account, log in, and manage your profile. The app allows you to interact with different functionalities related to road transport operations.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any enhancements or bug fixes.
