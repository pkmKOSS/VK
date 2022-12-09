// AsyncOperation.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Асинхронная операция
class AsyncOperation: Operation {
    // MARK: - Public enum

    enum State: String {
        case ready, executing, finished

        fileprivate var keyPath: String {
            Constants.keyPathPrefix + rawValue.capitalized
        }
    }

    // MARK: - Private constants

    private enum Constants {
        static let keyPathPrefix = "is"
    }

    // MARK: - Public properties

    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }

        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }

    override var isAsynchronous: Bool {
        true
    }

    override var isReady: Bool {
        super.isReady && state == .ready
    }

    override var isFinished: Bool {
        state == .finished
    }

    // MARK: - Private methods

    override func start() {
        guard isCancelled else {
            main()
            state = .executing
            return
        }
        state = .finished
    }

    override func cancel() {
        super.cancel()
        state = .finished
    }
}
