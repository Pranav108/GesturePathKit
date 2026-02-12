
//
//  GesturePathTrackingWindow.swift
//  GesturePathKit
//
//  Created by Pranav Singh
//

#if DEBUG
import UIKit

/// A `UIWindow` subclass that intercepts touch events and renders a visual overlay
/// (gradient trail, crosshair, circle, coordinate HUD) directly on itself.
///
/// **No additional window is created.** The overlay is added as a transparent subview
/// on top of the window's existing content.
///
/// Only the first finger's path is tracked; additional simultaneous touches are ignored.
///
/// Usage:
/// ```swift
/// // In SceneDelegate, use as the main window:
/// let window = GesturePathTrackingWindow(windowScene: windowScene)
/// // or with custom colors:
/// let config = GesturePathKitConfiguration(gradientStartColor: .purple)
/// let window = GesturePathTrackingWindow(windowScene: windowScene, configuration: config)
/// ```
public final class GesturePathTrackingWindow: UIWindow {
    
    // MARK: - Private Properties
    
    private let overlayView: TouchOverlayView
    
    /// The first touch that began — only this finger's path is tracked.
    private weak var trackedTouch: UITouch?
    
    // MARK: - Init
    
    /// Creates a tracking window attached to the given scene.
    ///
    /// - Parameters:
    ///   - windowScene: The window scene to attach to.
    ///   - configuration: Appearance configuration for the overlay. Uses defaults if omitted.
    public init(windowScene: UIWindowScene, configuration: GesturePathKitConfiguration = .init()) {
        self.overlayView = TouchOverlayView(configuration: configuration)
        super.init(windowScene: windowScene)
        setupOverlay()
    }
    
    /// Creates a tracking window by adopting the properties of an existing `UIWindow`.
    ///
    /// Use this initializer for apps that don't use a scene delegate and already have
    /// a `UIWindow` instance (e.g. from a storyboard or `AppDelegate.window`).
    /// The existing window's `frame`, `rootViewController`, `windowLevel`,
    /// and `windowScene` (if available) are transferred to this tracking window.
    ///
    /// - Parameters:
    ///   - window: The existing `UIWindow` whose properties will be adopted.
    ///   - configuration: Appearance configuration for the overlay. Uses defaults if omitted.
    public init(window: UIWindow, configuration: GesturePathKitConfiguration = .init()) {
        self.overlayView = TouchOverlayView(configuration: configuration)
        if let scene = window.windowScene {
            super.init(windowScene: scene)
        } else {
            super.init(frame: window.frame)
        }
        self.rootViewController = window.rootViewController
        self.windowLevel = window.windowLevel
        setupOverlay()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupOverlay() {
        overlayView.frame = bounds
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlayView.isUserInteractionEnabled = false
        addSubview(overlayView)
    }
    
    // MARK: - Ensure Overlay Stays on Top
    
    public override func addSubview(_ view: UIView) {
        super.addSubview(view)
        // Keep overlay always on top whenever a new subview is added
        if view !== overlayView {
            bringSubviewToFront(overlayView)
        }
    }
    
    // MARK: - Event Interception
    
    public override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        
        guard let touches = event.allTouches else { return }
        
        let directTouches = touches.filter { $0.type == .direct }
        
        for touch in directTouches {
            switch touch.phase {
            case .began:
                // Only track the very first finger that touches down
                if trackedTouch == nil {
                    trackedTouch = touch
                    handleTouch(touch)
                }
            case .moved:
                if touch === trackedTouch {
                    handleTouch(touch)
                }
            case .ended, .cancelled:
                if touch === trackedTouch {
                    handleTouch(touch)
                    trackedTouch = nil
                }
            default:
                break
            }
        }
    }
    
    // MARK: - Touch Forwarding
    
    private func handleTouch(_ touch: UITouch) {
        let point = touch.location(in: self)
        
        switch touch.phase {
        case .began:
            overlayView.begin(at: point)
        case .moved:
            overlayView.append(point)
        case .ended, .cancelled:
            overlayView.end()
        default:
            break
        }
    }
}
#endif
