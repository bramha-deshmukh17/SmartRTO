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
    1. Create a flutter project in Firebase
    2. Get started by adding Firebase to your app
        - Here select the Flutter Icon
        - Then Install Firebase cli and execute it and run follwing command:
          ```bash
          firebase login
          ```
        - Now configue CLI globally by running
          ```bash
          dart pub global activate flutterfire_cli
          ```
    3. Add firebase configuration files to project directory by running the command in root folder of project
       ```bash
       flutterfire configure --project=YOUR_PROJECT_ID
       ```
       - The project id will be diaplayed when you are setting up the firebase for your project
    4. 

5. **Run the application**:
    ```bash
    flutter run
    ```

## Usage

After setting up the application, you can create an account, log in, and manage your profile. The app allows you to interact with different functionalities related to road transport operations.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any enhancements or bug fixes.
