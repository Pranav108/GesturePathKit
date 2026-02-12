
# GesturePathKit

A lightweight, debug-only iOS SDK that visualizes touch gestures in real time — rendering a gradient trail, crosshair, touch circle, and a live coordinate HUD directly on your app's window.

> **Debug-only** — All code is wrapped in `#if DEBUG`, so it is completely stripped from release builds. Zero impact on your production app.

<img width="300" height="700" alt="SampelScreenShot" src="https://github.com/user-attachments/assets/fb3dcf57-e089-4574-baf5-7eaf164b6f17" />


---

## ✨ Features

| Feature | Description |
|---|---|
| **Gradient Trail** | Draws a smooth, color-gradient path following your finger as it moves across the screen. |
| **Crosshair Lines** | Full-screen horizontal and vertical crosshair lines track the current touch position. |
| **Touch Circle** | A subtle circle indicator marks the exact point of contact. |
| **Coordinate HUD** | A live heads-up display shows the current touch coordinates (`x`, `y`) and the delta from the starting point (`dx`, `dy`). |
| **Configurable Appearance** | Customize gradient colors, HUD text/background colors, and HUD position. |
| **Single-Finger Tracking** | Only the first finger is tracked — additional simultaneous touches are ignored for a clean visualization. |
| **Non-Intrusive** | The overlay is completely transparent to touch events. Your app's buttons, gestures, and scroll views continue to work normally. |
| **Memory Bounded** | Trail points are capped at 500, keeping memory usage stable during long drag sessions. |

---

## 📦 Installation

### Swift Package Manager

Add GesturePathKit to your project using Xcode:

1. Go to **File → Add Package Dependencies...**
2. Enter the repository URL:
   ```
   https://github.com/Pranav108/GesturePathKit.git
   ```
3. Select your desired version rule and add the package.

Or add it directly in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Pranav108/GesturePathKit.git", from: "REQIRED.VERSION.HERE")
]
```

Then add the dependency to your target:

```swift
.target(
    name: "YourApp",
    dependencies: ["GesturePathKit"]
)
```

---

## 🚀 Integration

GesturePathKit works by replacing your app's `UIWindow` with `GesturePathTrackingWindow`. This is a one-line change in your `SceneDelegate`.

### Basic Setup (Default Configuration)

In your `SceneDelegate.swift`:

```swift
import UIKit
import GesturePathKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        // Replace UIWindow with GesturePathTrackingWindow
        let trackingWindow = GesturePathTrackingWindow(windowScene: windowScene)

        trackingWindow.rootViewController = UINavigationController(
            rootViewController: YourViewController()
        )
        trackingWindow.makeKeyAndVisible()
        window = trackingWindow
    }
}
```

That's it! Drag your finger anywhere on screen to see the gesture trail, crosshair, touch circle, and coordinate HUD.

### Custom Configuration

Customize the overlay appearance using `GesturePathKitConfiguration`:

```swift
import UIKit
import GesturePathKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let config = GesturePathKitConfiguration(
            interactionCoordinateTextColor: .white,
            interactionCoordinateBackgroundColor: UIColor.black.withAlphaComponent(0.7),
            gradientStartColor: .systemPurple,
            gradientEndColor: .systemOrange,
            interactionCoordinateAlignment: .bottomLeft
        )

        let trackingWindow = GesturePathTrackingWindow(
            windowScene: windowScene,
            configuration: config
        )

        trackingWindow.rootViewController = UINavigationController(
            rootViewController: YourViewController()
        )
        trackingWindow.makeKeyAndVisible()
        window = trackingWindow
    }
}
```

---

## ⚙️ Configuration Options

All properties on `GesturePathKitConfiguration` have sensible defaults — override only what you need.

| Property | Type | Default | Description |
|---|---|---|---|
| `gradientStartColor` | `UIColor` | `.systemRed` | Left color of the gradient trail. |
| `gradientEndColor` | `UIColor` | `.systemBlue` | Right color of the gradient trail. |
| `interactionCoordinateTextColor` | `UIColor` | `.white` | Text color of the coordinate HUD. |
| `interactionCoordinateBackgroundColor` | `UIColor` | `UIColor.black` (70% opacity) | Background color of the coordinate HUD. |
| `interactionCoordinateAlignment` | `GesturePathKitInteractionCoordinateAlignment` | `.topLeft` | Position of the coordinate HUD on screen. |

### HUD Alignment Options

```swift
public enum GesturePathKitInteractionCoordinateAlignment {
    case topLeft      // Top-left corner (default)
    case topRight     // Top-right corner
    case bottomLeft   // Bottom-left corner
    case bottomRight  // Bottom-right corner
    case centerLeft   // Vertically centered, left edge
    case centerRight  // Vertically centered, right edge
}
```

---

## 🔧 Requirements

| Requirement | Minimum |
|---|---|
| iOS | 13.0+ |
| Swift | 5.9+ |
| Xcode | 15.0+ |

---

## 📁 Project Structure

```
GesturePathKit/
├── GesturePathTrackingWindow.swift    # UIWindow subclass that intercepts touches
├── GesturePathKitConfiguration.swift  # Public configuration & alignment enum
├── TouchOverlayView.swift             # Internal view rendering the visual layers
└── GesturePathKit.docc/               # Documentation catalog
```

---

