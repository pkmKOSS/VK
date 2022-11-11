// PopAnimator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Кастомный аниматор перехода
class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    // MARK: - Public methods

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to)
        else { return }

        transitionContext.containerView.insertSubview(destination.view, at: 0)
        destination.view.frame = source.view.frame
        source.view.layer.anchorPoint = CGPoint(
            x: 1.0,
            y: 0.0
        )
        source.view.frame.origin = CGPoint(x: 0, y: 0)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveLinear
        ) {
            UIView.addKeyframe(
                withRelativeStartTime: 0.0,
                relativeDuration: 1.0
            ) {
                let rotate = CGAffineTransform(rotationAngle: .pi / -2)
                source.view.transform = rotate
            }
        } completion: { result in
            if result, !transitionContext.transitionWasCancelled {
                source.removeFromParent()
                transitionContext.completeTransition(true)
            } else if transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(result && !transitionContext.transitionWasCancelled)
        }
    }
}
