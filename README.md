<p align="center">
  <img src="images/logo.png" alt="SmartRTO App Preview" width="250"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
</p>

# 🚦 SmartRTO

A modern and efficient mobile application for road transport officers, built with Flutter and Firebase.

---

## Table of Contents

- [🛠️ Tech Stack](#tech-stack)
- [✨ Features](#features)
- [👮‍♂️ Author](#author)
- [⚙️ Setup Instructions](#setup-instructions)
- [📱 Usage](#usage)
- [⚙️ Deployment](#deployment)
- [🌐 References](#references)
- [📬 Contact](#contact)

---

## <a id="tech-stack"></a>🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **APIs**: Gemini API, Razorpay API

---

## <a id="features"></a>✨ Features

- 🔐 User authentication (sign up, login, logout)
- 👤 Profile management for officers
- 🔄 Fetching officer data from Firestore
- ⏳ Progress indicators for loading states
- 🌐 Support for multiple languages (if applicable)

---

## <a id="setup-instructions"></a>⚙️ Setup Instructions

### 📝 Steps

1. **Clone the repository**

    ```bash
    git clone https://github.com/bramha-deshmukh17/SmartRTO.git
    cd SmartRTO
    ```

2. **Install dependencies**

    ```bash
    flutter pub get
    ```

3. **Configure Firebase**
   - Set up a Firebase project and add the necessary configurations to your app.
   - Add support for Firebase Authentication, Firestore, and Storage for both Android and iOS.
   - Add `firebase.json`, `google-services.json` to their respective folders.
   - Ensure you have added the appropriate permissions in the Android and iOS configuration files.

4. **Configure .env**
   - Add the following data to it:
     ```bash
     GEMINI_API=YOUR_GEMINI_API_KEY_FROM_GOOGLE
     RAZOR_PAY_API=YOUR_RAZORPAY_API_KEY
     ```

5. **Run the application**

    ```bash
    flutter run
    ```

---

## <a id="usage"></a>📱 Usage

- Create an account, log in, and manage your profile.
- Interact with different functionalities related to road transport operations.

---

## <a id="deployment"></a>⚙️ Deployment

- Build the app for release with `flutter build apk` or `flutter build ios`.
- Deploy to the Google Play Store or Apple App Store as per platform guidelines.
- Set environment variables as needed for production.

---

## <a id="references"></a>🌐 References

- [Flutter](https://flutter.dev/)
- [Firebase](https://firebase.google.com/)
- [Dart](https://dart.dev/)
- [Gemini API](https://aistudio.google.com/app/apikey)
- [Razorpay](https://razorpay.com/)

---


## <a id="author"></a>👮‍♂️ Author

- **Bramha Deshmukh**
- [GitHub](https://github.com/bramha-deshmukh17)

---


## <a id="contact"></a>📬 Contact

For any inquiries or feedback, please contact me at [work@bramhadeshmukh.me](mailto:work@bramhadeshmukh.me).
