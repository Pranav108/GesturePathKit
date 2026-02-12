
//
//  TouchOverlayView.swift
//  GesturePathKit
//
//  Created by Pranav Singh
//

#if DEBUG
import UIKit

// MARK: - TouchOverlayView

/// Internal view that renders the touch visualization layers:
/// gradient trail, crosshair lines, touch circle, and interaction-coordinate HUD.
///
/// This view is not user-interactable — it only draws.
final class TouchOverlayView: UIView {
    
    // MARK: - Constants
    
    private enum Constants {
        
        // Path / Gradient
        static let pathLineWidth: CGFloat = 4
        static let gradientStartPoint = CGPoint(x: 0, y: 0.5)
        static let gradientEndPoint = CGPoint(x: 1, y: 0.5)
        
        // Crosshair
        static let crosshairStrokeColor: UIColor = .systemGreen
        static let crosshairLineWidth: CGFloat = 1
        
        // Touch Circle
        static let circleStrokeColor: UIColor = UIColor.gray.withAlphaComponent(0.75)
        static let circleLineWidth: CGFloat = 2
        static let circleRadius: CGFloat = 8
        
        // Interaction Coordinate HUD
        static let hudFontSize: CGFloat = 13
        static let hudCornerRadius: CGFloat = 8
        static let hudDefaultText = "x: –  y: –  dx: –  dy: –"
        
        // Layout
        static let hudPadding: CGFloat = 12
        static let hudLabelWidthInset: CGFloat = 16
        static let hudLabelHeightInset: CGFloat = 10
        
        // Animation
        static let trailFadeDuration: TimeInterval = 0.3
    }
    
    // MARK: - Path (Gradient)
    
    private let path = UIBezierPath()
    private let pathMaskLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - Crosshair + Circle
    
    private let crosshairLayer = CAShapeLayer()
    private let circleLayer = CAShapeLayer()
    
    // MARK: - Interaction Coordinate HUD
    
    private let interactionCoordinateLabel = UILabel()
    
    // MARK: - State
    
    private var startPoint: CGPoint?
    private var points: [CGPoint] = []
    private var workDispatchItem: DispatchWorkItem?
    
    /// Maximum number of points retained in the trail.
    /// Older points are dropped to keep memory bounded during long drags.
    private static let maxTrailPoints = 500
    
    // MARK: - Configuration
    
    private let configuration: GesturePathKitConfiguration
    
    // MARK: - Init
    
    init(configuration: GesturePathKitConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func commonInit() {
        isUserInteractionEnabled = false
        backgroundColor = .clear
        
        // ---- Gradient Path ----
        
        pathMaskLayer.fillColor = UIColor.clear.cgColor
        pathMaskLayer.strokeColor = UIColor.black.cgColor
        pathMaskLayer.lineWidth = Constants.pathLineWidth
        
        gradientLayer.colors = [
            configuration.gradientStartColor.cgColor,
            configuration.gradientEndColor.cgColor
        ]
        gradientLayer.startPoint = Constants.gradientStartPoint
        gradientLayer.endPoint = Constants.gradientEndPoint
        gradientLayer.mask = pathMaskLayer
        
        // ---- Crosshair ----
        
        crosshairLayer.strokeColor = Constants.crosshairStrokeColor.cgColor
        crosshairLayer.lineWidth = Constants.crosshairLineWidth
        crosshairLayer.fillColor = UIColor.clear.cgColor
        
        // ---- Touch Circle ----
        
        circleLayer.strokeColor = Constants.circleStrokeColor.cgColor
        circleLayer.lineWidth = Constants.circleLineWidth
        circleLayer.fillColor = UIColor.clear.cgColor
        
        layer.addSublayer(gradientLayer)
        layer.addSublayer(crosshairLayer)
        layer.addSublayer(circleLayer)
        
        // ---- Interaction Coordinate HUD ----
        
        interactionCoordinateLabel.font = .monospacedSystemFont(ofSize: Constants.hudFontSize, weight: .medium)
        interactionCoordinateLabel.textColor = configuration.interactionCoordinateTextColor
        interactionCoordinateLabel.backgroundColor = configuration.interactionCoordinateBackgroundColor
        interactionCoordinateLabel.layer.cornerRadius = Constants.hudCornerRadius
        interactionCoordinateLabel.layer.masksToBounds = true
        interactionCoordinateLabel.text = Constants.hudDefaultText
        
        addSubview(interactionCoordinateLabel)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
        pathMaskLayer.frame = bounds
        crosshairLayer.frame = bounds
        circleLayer.frame = bounds
        
        let padding = Constants.hudPadding
        interactionCoordinateLabel.sizeToFit()
        
        let labelWidth = interactionCoordinateLabel.bounds.width + Constants.hudLabelWidthInset
        let labelHeight = interactionCoordinateLabel.bounds.height + Constants.hudLabelHeightInset
        
        let labelOrigin: CGPoint
        
        switch configuration.interactionCoordinateAlignment {
        case .topLeft:
            labelOrigin = CGPoint(
                x: padding,
                y: safeAreaInsets.top + padding
            )
        case .topRight:
            labelOrigin = CGPoint(
                x: bounds.width - labelWidth - padding,
                y: safeAreaInsets.top + padding
            )
        case .bottomLeft:
            labelOrigin = CGPoint(
                x: padding,
                y: bounds.height - safeAreaInsets.bottom - labelHeight - padding
            )
        case .bottomRight:
            labelOrigin = CGPoint(
                x: bounds.width - labelWidth - padding,
                y: bounds.height - safeAreaInsets.bottom - labelHeight - padding
            )
        case .centerLeft:
            labelOrigin = CGPoint(
                x: padding,
                y: (bounds.height - labelHeight) / 2
            )
        case .centerRight:
            labelOrigin = CGPoint(
                x: bounds.width - labelWidth - padding,
                y: (bounds.height - labelHeight) / 2
            )
        }
        
        interactionCoordinateLabel.frame = CGRect(
            x: labelOrigin.x,
            y: labelOrigin.y,
            width: labelWidth,
            height: labelHeight
        )
    }
    
    // MARK: - Touch Lifecycle
    
    func begin(at point: CGPoint) {
        workDispatchItem?.cancel()
        points.removeAll(keepingCapacity: true)
        points.append(point)
        rebuildPath()
        
        startPoint = point
        
        updateCrosshair(at: point)
        updateCircle(at: point)
        updateHUD(current: point)
    }
    
    func append(_ point: CGPoint) {
        points.append(point)
        
        // Trim old points so the trail doesn't grow unboundedly during long drags
        if points.count > Self.maxTrailPoints {
            points.removeFirst(points.count - Self.maxTrailPoints)
        }
        
        rebuildPath()
        
        updateCrosshair(at: point)
        updateCircle(at: point)
        updateHUD(current: point)
    }
    
    func end() {
        workDispatchItem?.cancel()
        let item = DispatchWorkItem { [weak self] in
            self?.startPoint = nil
            self?.points.removeAll(keepingCapacity: true)
            self?.crosshairLayer.path = nil
            self?.circleLayer.path = nil
        }
        workDispatchItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.trailFadeDuration, execute: item)
    }
    
    // MARK: - Path Rebuild
    
    private func rebuildPath() {
        path.removeAllPoints()
        guard let first = points.first else {
            pathMaskLayer.path = nil
            return
        }
        path.move(to: first)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        pathMaskLayer.path = path.cgPath
    }
    
    // MARK: - Visual Updates
    
    private func updateCrosshair(at point: CGPoint) {
        let crosshairPath = UIBezierPath()
        crosshairPath.move(to: CGPoint(x: point.x, y: 0))
        crosshairPath.addLine(to: CGPoint(x: point.x, y: bounds.height))
        crosshairPath.move(to: CGPoint(x: 0, y: point.y))
        crosshairPath.addLine(to: CGPoint(x: bounds.width, y: point.y))
        crosshairLayer.path = crosshairPath.cgPath
    }
    
    private func updateCircle(at point: CGPoint) {
        let circlePath = UIBezierPath(
            arcCenter: point,
            radius: Constants.circleRadius,
            startAngle: 0,
            endAngle: .pi * 2,
            clockwise: true
        )
        circleLayer.path = circlePath.cgPath
    }
    
    private func updateHUD(current: CGPoint) {
        guard let start = startPoint else { return }
        
        let dx = current.x - start.x
        let dy = current.y - start.y
        
        interactionCoordinateLabel.text =
            "x: \(Int(current.x))  y: \(Int(current.y))  dx: \(Int(dx))  dy: \(Int(dy))"
        
        setNeedsLayout()
    }
}
#endif
