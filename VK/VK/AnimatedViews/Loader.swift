// Loader.swift
// Copyright © RoadMap. All rights reserved.

// CommonGroupTableViewCell.swift
// Copyright © RoadMap. All rights reserved.
import UIKit

/// Представление "Три анимированных точки"
final class Loader: UIView {
    // MARK: - Public properties

    override public var tintColor: UIColor! {
        willSet {
            dotColor = newValue
            layer.sublayers?.removeAll()
            drawIndicatorView()
        }
    }

    // MARK: - Private properties

    private let dotSize: CGFloat = 6.0
    private var dotColor: UIColor = .darkGray
    private var defaultFrame: CGRect { CGRect(x: 0, y: 0, width: dotSize * 5, height: dotSize * 2) }

    // MARK: - Init

    public convenience init() {
        self.init(frame: .zero, tintColor: nil)
    }

    public convenience init(tintColor: UIColor) {
        self.init(frame: .zero, tintColor: tintColor)
    }

    init(frame: CGRect, tintColor: UIColor?) {
        super.init(frame: CGRect(x: 0, y: 0, width: dotSize * 5, height: dotSize * 2))

        if let color = tintColor { self.tintColor = color }
        drawIndicatorView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        if let color = super.tintColor { tintColor = color }
        drawIndicatorView()
    }

    // MARK: - Private methods

    private func drawIndicatorView() {
        makeDotsLayout()

        let startTime = CACurrentMediaTime()
        let startTimes: [CFTimeInterval] = [0.2, 0.4, 0.6]
        let duration: CFTimeInterval = startTimes.last ?? 1.0
        let accelerateType = CAMediaTimingFunction(name: .easeInEaseOut)

        let animation = CAKeyframeAnimation(keyPath: StringConstants.animationKeyPath)
        animation.timingFunctions = [accelerateType, accelerateType, accelerateType]
        animation.values = [0, -dotSize]
        animation.duration = duration
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false

        for iterator in 0 ..< 3 {
            let dotLayer = layerWith(size: CGSize(width: dotSize, height: dotSize), color: dotColor)
            let frame = CGRect(
                x: dotSize * CGFloat(iterator) + dotSize * CGFloat(iterator),
                y: layer.bounds.size.height - dotSize,
                width: dotSize,
                height: dotSize
            )

            animation.beginTime = startTime + startTimes[iterator]
            dotLayer.frame = frame
            dotLayer.add(animation, forKey: StringConstants.animationKey)
            layer.addSublayer(dotLayer)
        }
    }

    private func layerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer = CAShapeLayer()
        let path = UIBezierPath()

        path.addArc(
            withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
            radius: size.width / 2,
            startAngle: 0,
            endAngle: CGFloat(2 * Double.pi),
            clockwise: false
        )

        layer.fillColor = color.cgColor
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        return layer
    }

    private func makeDotsLayout() {
        widthAnchor.constraint(equalToConstant: dotSize * 5).isActive = true
        heightAnchor.constraint(equalToConstant: dotSize * 2).isActive = true
    }
}
