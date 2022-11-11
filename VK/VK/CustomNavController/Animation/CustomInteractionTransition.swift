// CustomInteractionTransition.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Кастомное интерактивное закрытие экрана
final class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {
    // MARK: - Public properties

    var viewController: UIViewController? {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgeGestore))
            recognizer.edges = [.left]
            (viewController as? FriendPhotoCollectionViewController)?.collectionView.addGestureRecognizer(recognizer)
        }
    }

    var hasStarted: Bool = false
    var shouldGinish: Bool = false

    // MARK: - Private methods

    @objc private func handleEdgeGestore(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            hasStarted = true
            viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            let relativeTranslation = translation.y / (recognizer.view?.bounds.width ?? 1)
            let progress = max(0, min(1, relativeTranslation))
            shouldGinish = progress > 0.33
            update(progress)
        case .ended:
            hasStarted = false
            _ = shouldGinish ? finish() : cancel()
        case .cancelled:
            hasStarted = false
            cancel()
        default: return
        }
    }
}
