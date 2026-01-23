# Image Search App

Swift iOS app demonstrating an Image Search UI built with the MVVM architecture. The app lets users search for images, view results in a grid, and preview individual images.

- Repository: [yashiika04/ImageSearchApp](https://github.com/yashiika04/ImageSearchApp)
- Language: Swift
- Architecture: MVVM
- Xcode project: Image Search App MVVM.xcodeproj

## Features

- Search images by keyword
- Display results in a responsive grid
- Image preview/detail view
- MVVM structure for clear separation of concerns
- Async image loading and basic caching
- Simple, testable networking layer

## Tech / Libraries

- Swift (latest stable version)
- UIKit
- Networking using URLSession / async-await (or combine if present)
- Basic in-memory image caching

## Requirements

- Xcode 14.0+ 
- iOS 13.0+ 
- Swift 5.6+ 

## Getting Started

1. Clone the repository
```bash
git clone https://github.com/yashiika04/ImageSearchApp.git
cd ImageSearchApp
```

2. Open the Xcode project
```bash
open "Image Search App MVVM.xcodeproj"
```

3. Build & Run
- Select a simulator or a device in Xcode and press Run (CMD+R).

## Project Structure

- Image Search App MVVM/
  - Models/ — data models (Image, SearchResult, etc.)
  - ViewModels/ — view model classes that expose data to views
  - Views/ — view controllers cells
  - Services/ — networking (API client), image cache, persistence

This project follows MVVM to keep network and business logic testable and separated from UI code.

## Configuration & Notes

- API Rate Limits: If using a public image API, be mindful of rate limits during development.
- Image caching: The app includes a basic image cache; consider replacing with a production-ready library if needed.
- Error handling: Network and parsing errors are surfaced via the ViewModel to the UI; extend as required.

## Screenshots

(Add screenshots to the `docs/` folder or `assets/` and link them here.)

![Search Screen](docs/screenshots/search.png)
![Detail Screen](docs/screenshots/detail.png)
