// CustomInteractionTransition.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Кастомное интерактивное закрытие экрана
final class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {
    // MARK: - Private constants

    private struct Constants {
        static let defaultRecognizerWidth: CGFloat = 1
        static let maxRelativeProgress: CGFloat = 1
        static let minRelativeProgress: CGFloat = 0
        static let finishedProgress: CGFloat = 0.33
    }

    // MARK: - Public properties

    var viewController: UIViewController? {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgeGestoreAction))
            recognizer.edges = [.left]
            (viewController as? FriendPhotoCollectionViewController)?.collectionView.addGestureRecognizer(recognizer)
        }
    }

    // MARK: - Public properties

    var isStarted = false
    var isFinished = false

    // MARK: - Private methods

    @objc private func handleEdgeGestoreAction(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            isStarted = true
            viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            let relativeTranslation = translation
                .y / (recognizer.view?.bounds.width ?? Constants.defaultRecognizerWidth)
            let progress = max(Constants.maxRelativeProgress, min(Constants.minRelativeProgress, relativeTranslation))
            isFinished = progress > Constants.finishedProgress
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
