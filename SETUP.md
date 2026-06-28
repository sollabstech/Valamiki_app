# VALAMIKI App — Setup Guide

## Prerequisites
- Flutter SDK (latest stable)
- Android Studio / VS Code
- Firebase account
- Git

---

## Step 1: Install Dependencies

```bash
flutter pub get
```

---

## Step 2: Download Fonts (Required)

The app uses **Poppins** font. Download from Google Fonts and place in `assets/fonts/`:

- `Poppins-Light.ttf`
- `Poppins-Regular.ttf`
- `Poppins-Medium.ttf`
- `Poppins-SemiBold.ttf`
- `Poppins-Bold.ttf`

Download: https://fonts.google.com/specimen/Poppins

---

## Step 3: Firebase Setup

### 3.1 Create Firebase Project
1. Go to https://console.firebase.google.com/
2. Click **Add Project** → name it `Valamiki`
3. Enable Google Analytics (optional)

### 3.2 Add Android App
1. Click **Add App** → Android
2. Package name: `com.valamiki.valamiki_app`
3. App nickname: `VALAMIKI`
4. Download `google-services.json`
5. Replace `android/app/google-services.json` with the downloaded file

### 3.3 Enable Firebase Services

#### Authentication
- Firebase Console → Authentication → Sign-in method
- Enable **Email/Password**

#### Firestore Database
- Firebase Console → Firestore Database → Create database
- Start in **test mode** (update rules before production)
- Choose your nearest region

#### Storage
- Firebase Console → Storage → Get started
- Start in test mode

### 3.4 Firestore Security Rules (Production)
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      match /addresses/{addressId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
    match /products/{productId} {
      allow read: if true;
      allow write: if false; // Admin only via Firebase Console
    }
    match /categories/{categoryId} {
      allow read: if true;
      allow write: if false;
    }
    match /banners/{bannerId} {
      allow read: if true;
      allow write: if false;
    }
    match /orders/{orderId} {
      allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
    }
  }
}
```

---

## Step 4: Seed Firestore Data

Add sample data via Firebase Console or use the seed script:

### Categories Collection (`categories`)
```json
{
  "id": "grocery",
  "name": "Grocery",
  "icon": "🥦",
  "color": 4283284560,
  "isActive": true,
  "productCount": 0
}
```
Add for: grocery, stationery, snacks, household, daily_essentials

### Products Collection (`products`)
Each product should have:
```json
{
  "name": "Product Name",
  "description": "Description here",
  "categoryId": "grocery",
  "categoryName": "Grocery",
  "price": 100.0,
  "discountPrice": 85.0,
  "discountPercent": 15.0,
  "images": ["https://storage-url/image.jpg"],
  "unit": "500g",
  "stock": 100,
  "isAvailable": true,
  "isFeatured": false,
  "isPopular": true,
  "isFlashDeal": false,
  "rating": 4.5,
  "reviewCount": 120,
  "tags": ["fresh", "organic"],
  "createdAt": "timestamp"
}
```

---

## Step 5: Run the App

```bash
# Debug mode
flutter run

# Release APK
flutter build apk --release

# Release AAB (for Play Store)
flutter build appbundle --release
```

---

## Step 6: Razorpay Integration (Future)

When ready to integrate Razorpay:
1. Add to `pubspec.yaml`:
   ```yaml
   razorpay_flutter: ^1.3.7
   ```
2. Get API keys from https://dashboard.razorpay.com/
3. Update `lib/core/services/payment_service.dart` — `RazorpayPaymentProvider` class is already architected

---

## Project Structure

```
lib/
├── core/
│   ├── constants/     # App constants, colors
│   ├── theme/         # Material 3 theme
│   ├── utils/         # Validators, helpers
│   └── services/      # Firebase, Storage, Payment services
├── data/
│   ├── models/        # UserModel, ProductModel, OrderModel, etc.
│   └── repositories/  # Data access layer
├── modules/
│   ├── splash/        # Animated splash screen
│   ├── onboarding/    # 3-page onboarding
│   ├── auth/          # Login, Register, Forgot Password
│   ├── home/          # Main home with bottom nav
│   ├── categories/    # Category grid + products
│   ├── product/       # Product detail with hero animation
│   ├── cart/          # Cart with quantity management
│   ├── checkout/      # Address + COD checkout
│   ├── orders/        # Order history + tracking timeline
│   ├── profile/       # User profile + addresses
│   └── search/        # Product search
├── routes/            # GetX routing
├── widgets/           # Reusable components
└── main.dart
```

---

## App Features

✅ Premium splash screen with animations  
✅ 3-page onboarding  
✅ Email/Password authentication  
✅ Home with banner slider, categories, products  
✅ Category filtering  
✅ Product detail with hero animation  
✅ Cart with real-time quantity updates  
✅ Checkout with address management  
✅ Cash on Delivery payment  
✅ Order confirmation screen  
✅ Order history with status timeline  
✅ User profile management  
✅ Product search  
✅ Shimmer loading states  
✅ GetX state management throughout  
✅ Firebase backend ready  
✅ Razorpay architecture prepared  
