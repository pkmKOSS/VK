// PushAnimator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Класс аниматор перехода
final class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    // MARK: - Public methods

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to)
        else { return }

        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = source.view.frame
        destination.view.layer.anchorPoint = CGPoint(
            x: 1.0,
            y: 0.0
        )
        destination.view.frame.origin = CGPoint(x: 0, y: 0)
        let rotate = CGAffineTransform(rotationAngle: -.pi / 2)
        destination.view.transform = rotate

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveLinear
        ) {
            UIView.addKeyframe(
                withRelativeStartTime: 0.0,
                relativeDuration: 1.0
            ) {
                destination.view.transform = .identity
            }
        } completion: { result in
            if result, !transitionContext.transitionWasCancelled {
                destination.view.transform = .identity
                transitionContext.completeTransition(true)
            } else {
                transitionContext.completeTransition(false)
            }
        }
    }
}
