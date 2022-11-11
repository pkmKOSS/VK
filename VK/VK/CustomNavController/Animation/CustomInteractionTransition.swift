// CustomInteractionTransition.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Кастомное интерактивное закрытие экрана
final class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {
    // MARK: - Public properties

    var viewController: UIViewController? {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgeGestoreAction))
            recognizer.edges = [.left]
            (viewController as? FriendPhotoCollectionViewController)?.collectionView.addGestureRecognizer(recognizer)
        }
    }

    var isStarted: Bool = false
    var isFinished: Bool = false

    // MARK: - Private methods

    @objc private func handleEdgeGestoreAction(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            isStarted = true
            viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            let relativeTranslation = translation.y / (recognizer.view?.bounds.width ?? 1)
            let progress = max(0, min(1, relativeTranslation))
            isFinished = progress > 0.33
            update(progress)
        case .ended:
            isStarted = false
            _ = isFinished ? finish() : cancel()
        case .cancelled:
            isStarted = false
            cancel()
        default: return
        }
    }
}
