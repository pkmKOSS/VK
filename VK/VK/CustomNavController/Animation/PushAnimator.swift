// PushAnimator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Класс аниматор перехода
final class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    // MARK: - Private constants

    private struct Constants {
        static let transitionDuration = 0.5
        static let destinationAnchorPoints = CGPoint(x: 1.0, y: 0.0)
        static let destinationOrigin = CGPoint(x: 0, y: 0)
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

        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = source.view.frame
        destination.view.layer.anchorPoint = Constants.destinationAnchorPoints
        destination.view.frame.origin = Constants.destinationOrigin
        let rotate = CGAffineTransform(rotationAngle: Constants.destinationRotationAngle)
        destination.view.transform = rotate

        setAnimation(context: transitionContext, destination: destination)
    }

    private func setAnimation(context: UIViewControllerContextTransitioning?, destination: UIViewController) {
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
                destination.view.transform = .identity
            }
        } completion: { result in
            if result, !context.transitionWasCancelled {
                destination.view.transform = .identity
                context.completeTransition(true)
            } else {
                context.completeTransition(false)
            }
        }
    }
}
