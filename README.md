# City Explorer

The application allows users to browse countries and cities, view detailed city information, and manage a list of favorite cities.  
The project is built using SwiftUI with a clean MVVM + Repository architecture.

---

## Features

- Browse countries and their cities
- Search cities with pagination support
- View detailed city data: population, timezone, coordinates
- Display map preview for each city using MapKit
- Add and remove cities from favorites
- Favorites persist using a repository backed by UserDefaults
- Reusable UI components

---

## Technologies Used

- Swift
- SwiftUI
- Combine  
- MapKit 
- UserDefaults persistence  
- RapidAPI (GeoDB Cities API)

---

## API Setup (Required)

This app uses the [GeoDB Cities API](https://rapidapi.com/wirefreethought/api/geodb-cities) provided by RapidAPI. 

### 1. Create a RapidAPI account  
https://rapidapi.com/

### 2. Subscribe to the "GeoDB Cities" API  
Choose any available subscription tier (free tier works).

### 3. Locate your API credentials  
After subscribing, retrieve:

- `X-RapidAPI-Key`
- `X-RapidAPI-Host`

### 4. Add your API keys to the project  
Edit the following file:

Shared/Networking/LiveAPI/GeoDBKeys.swift

### 5. Insert your credentials:

```swift
struct GeoDBKeys {
    static let apiKey = "YOUR_RAPIDAPI_KEY"
    static let apiHost = "wft-geo-db.p.rapidapi.com"
}
```

## How to Run the App

1. Clone the repository:

```bash
git clone https://github.com/magmatti/city-explorer.git
```
2. Open the project in Xcode:

```bash
open city-explorer.xcodeproj
```

3. Build and run the project using an iPhone simulator.
Recommended target: iOS 17 or later.
