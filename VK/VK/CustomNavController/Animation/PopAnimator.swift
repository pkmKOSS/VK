// PopAnimator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Кастомный аниматор перехода
final class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    // MARK: - Private constants

    private struct Constants {
        static let transitionDuration: CGFloat = 0.5
        static let destinationIndex = 0
        static let sourceAnchorPoint = CGPoint(x: 1.0, y: 0.0)
        static let sourceOrigin = CGPoint(x: 0, y: 0)
        static let destinationRotationAngle = -(3.14 / 2)
        static let relativeStartTime = 0.0
        static let relativeDuration = 1.0
    }

    // MARK: - Public methods

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        Constants.transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to)
        else { return }

        transitionContext.containerView.insertSubview(destination.view, at: Constants.destinationIndex)
        destination.view.frame = source.view.frame
        source.view.layer.anchorPoint = Constants.sourceAnchorPoint
        source.view.frame.origin = Constants.sourceOrigin

        setAnimation(context: transitionContext, source: source)
    }

    private func setAnimation(context: UIViewControllerContextTransitioning?, source: UIViewController) {
        guard let context = context else {
            return
        }

        UIView.animate(
            withDuration: transitionDuration(using: context),
            delay: 0,
            options: .curveLinear
        ) {
            UIView.addKeyframe(
                withRelativeStartTime: Constants.relativeStartTime,
                relativeDuration: Constants.relativeDuration
            ) {
                let rotate = CGAffineTransform(rotationAngle: Constants.destinationRotationAngle)
                source.view.transform = rotate
            }
        } completion: { result in
            if result, !context.transitionWasCancelled {
                source.removeFromParent()
                context.completeTransition(true)
            } else if context.transitionWasCancelled {
                source.view.transform = .identity
            }
            context.completeTransition(result && !context.transitionWasCancelled)
        }
    }
}
