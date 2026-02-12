
//
//  GesturePathKitConfiguration.swift
//  GesturePathKit
//
//  Created by Pranav Singh
//

#if DEBUG
import UIKit

/// Defines the position of the interaction-coordinate HUD within the touch overlay.
///
/// Use this enum when constructing a ``GesturePathKitConfiguration`` to
/// place the coordinate label at the desired screen corner or edge.
///
/// ```swift
/// let config = GesturePathKitConfiguration(
///     interactionCoordinateAlignment: .bottomRight
/// )
/// ```
public enum GesturePathKitInteractionCoordinateAlignment {
    /// Top-right corner.
    case topRight
    /// Top-left corner (default).
    case topLeft
    /// Bottom-left corner.
    case bottomLeft
    /// Bottom-right corner.
    case bottomRight
    /// Vertically centered on the left edge.
    case centerLeft
    /// Vertically centered on the right edge.
    case centerRight
}

/// Configuration for customizing the appearance of the touch overlay.
///
/// All properties have sensible defaults matching the original overlay colors.
/// Override only the properties you want to change.
///
/// ```swift
/// let config = GesturePathKitConfiguration(
///     gradientStartColor: .systemPurple,
///     gradientEndColor: .systemOrange,
///     interactionCoordinateAlignment: .bottomLeft
/// )
/// ```
public struct GesturePathKitConfiguration {
    
    // MARK: - Default Values
    
    /// Default text color for the interaction-coordinate HUD.
    public static let defaultInteractionCoordinateTextColor: UIColor = .white
    
    /// Default background color for the interaction-coordinate HUD.
    public static let defaultInteractionCoordinateBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.7)
    
    /// Default start color for the gradient trail.
    public static let defaultGradientStartColor: UIColor = .systemRed
    
    /// Default end color for the gradient trail.
    public static let defaultGradientEndColor: UIColor = .systemBlue
    
    /// Default alignment for the interaction-coordinate HUD.
    public static let defaultInteractionCoordinateAlignment: GesturePathKitInteractionCoordinateAlignment = .topLeft
    
    // MARK: - Properties
    
    /// Text color for the interaction-coordinate HUD that displays touch coordinates.
    /// Default: `.white`
    public var interactionCoordinateTextColor: UIColor
    
    /// Background color for the interaction-coordinate HUD.
    /// Default: `UIColor.black` with 70% opacity
    public var interactionCoordinateBackgroundColor: UIColor
    
    /// Start color (left) for the gradient trail drawn along the touch path.
    /// Default: `.systemRed`
    public var gradientStartColor: UIColor
    
    /// End color (right) for the gradient trail drawn along the touch path.
    /// Default: `.systemBlue`
    public var gradientEndColor: UIColor
    
    /// Position of the interaction-coordinate HUD within the overlay.
    /// Default: `.topRight`
    public var interactionCoordinateAlignment: GesturePathKitInteractionCoordinateAlignment
    
    public init(
        interactionCoordinateTextColor: UIColor = defaultInteractionCoordinateTextColor,
        interactionCoordinateBackgroundColor: UIColor = defaultInteractionCoordinateBackgroundColor,
        gradientStartColor: UIColor = defaultGradientStartColor,
        gradientEndColor: UIColor = defaultGradientEndColor,
        interactionCoordinateAlignment: GesturePathKitInteractionCoordinateAlignment = defaultInteractionCoordinateAlignment
    ) {
        self.interactionCoordinateTextColor = interactionCoordinateTextColor
        self.interactionCoordinateBackgroundColor = interactionCoordinateBackgroundColor
        self.gradientStartColor = gradientStartColor
        self.gradientEndColor = gradientEndColor
        self.interactionCoordinateAlignment = interactionCoordinateAlignment
    }
}
#endif
