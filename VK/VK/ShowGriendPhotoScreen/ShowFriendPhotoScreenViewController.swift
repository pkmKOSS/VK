// ShowFriendPhotoScreenViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

typealias TapHandlerAction = (() -> ())?

/// Экран просмотра фотографии друга.
final class ShowFriendPhotoScreenViewController: UIViewController {
    // MARK: - Privta @IBOutlet

    @IBOutlet private var showPhotoScrollView: UIScrollView!
    @IBOutlet private var pageControllView: UIPageControl!

    // MARK: - Public properties

    var friend: NetworkUnit?

    // MARK: - Private properties

    private var currentSlideCounter = 0
    private var slidesViews: [ShowPhotoView]?
    private var tapHandler: TapHandlerAction = nil

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToTop()
    }

    // MARK: - Private methods

    private func scrollToTop() {
        showPhotoScrollView.setContentOffset(CGPoint.zero, animated: true)
    }

    private func configureScreen() {
        configureTapHandler()
        makeDelegates()
        slidesViews = configureSlides()
        configureScrollView()
        configurePageControlView()
    }

    private func makeDelegates() {
        showPhotoScrollView.delegate = self
    }

    private func configureSlides() -> [ShowPhotoView] {
        var slides: [ShowPhotoView] = []
        var imageNames: [String] = []
        for imageName in UserAvatarImageNames.avatarImageNames[0 ... 4] {
            imageNames.append(imageName)
        }

        for image in imageNames {
            guard let slide: ShowPhotoView = Bundle.main.loadNibNamed(
                NibNames.showPhotoViewNibNameText,
                owner: self,
                options: nil
            )?
                .first as? ShowPhotoView else { return [] }
            let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(gestoreAction))
            recognizer.direction = .down
            slide.configurePhotoImage(
                image: UIImage(named: image),
                recognizer: recognizer,
                isHiden: true
            )
            slides.append(slide)
        }

        return slides
    }

    private func configureScrollView() {
        guard let slidesForScroll = slidesViews else { return }
        showPhotoScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        showPhotoScrollView.contentSize = CGSize(
            width: view.frame.width * CGFloat(slidesForScroll.count),
            height: view.frame.height
        )
        showPhotoScrollView.isPagingEnabled = true

        for index in 0 ..< slidesForScroll.count {
            slidesForScroll[index]
                .frame = CGRect(
                    x: view.frame.width * CGFloat(index),
                    y: 0,
                    width: view.frame.width,
                    height: view.frame.height
                )
            showPhotoScrollView.addSubview(slidesForScroll[index])
        }
    }

    private func configurePageControlView() {
        pageControllView.numberOfPages = slidesViews?.count ?? 0
        pageControllView.currentPage = 0
        view.bringSubviewToFront(pageControllView)
    }

    private func configureTapHandler() {
        tapHandler = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
    }

    @objc private func gestoreAction() {
        guard let action = tapHandler else { return }
        action()
    }
}

// MARK: - UIScrollViewDelegate

extension ShowFriendPhotoScreenViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let slides = slidesViews else { return }
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControllView.currentPage = Int(pageIndex)

        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x

        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y

        var percentageHorizontalOffset = CGFloat()
        var percentageVerticalOffset = CGFloat()

        if maximumHorizontalOffset > 0 {
            percentageHorizontalOffset = currentHorizontalOffset / maximumHorizontalOffset
        }

        if maximumVerticalOffset > 0 {
            percentageVerticalOffset = currentVerticalOffset / maximumVerticalOffset
        }

        let percentOffset = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        configureAffineTransform(percentOffset: percentOffset, slides: slides)
    }

    private func configureAffineTransform(percentOffset: CGPoint, slides: [ShowPhotoView]) {
        if percentOffset.x > 0, percentOffset.x <= 0.25 {
            let zeroTransform = CGAffineTransform(
                scaleX: (0.25 - percentOffset.x) / 0.25,
                y: (0.25 - percentOffset.x) / 0.25
            )
            slides[safe: 0]?.configureImageAnimation(transform: zeroTransform)

            let firstTransform = CGAffineTransform(
                scaleX: percentOffset.x / 0.25,
                y: percentOffset.x / 0.25
            )

            slides[safe: 1]?.configureImageAnimation(transform: firstTransform)

        } else if percentOffset.x > 0.25, percentOffset.x <= 0.50 {
            let firstTransform = CGAffineTransform(
                scaleX: (0.50 - percentOffset.x) / 0.25,
                y: (0.50 - percentOffset.x) / 0.25
            )
            slides[safe: 1]?.configureImageAnimation(transform: firstTransform)

            let secondTransform = CGAffineTransform(scaleX: percentOffset.x / 0.50, y: percentOffset.x / 0.50)
            slides[safe: 2]?.configureImageAnimation(transform: secondTransform)

        } else if percentOffset.x > 0.50, percentOffset.x <= 0.75 {
            let secondTransform = CGAffineTransform(
                scaleX: (0.75 - percentOffset.x) / 0.25,
                y: (0.75 - percentOffset.x) / 0.25
            )
            slides[safe: 2]?.configureImageAnimation(transform: secondTransform)

            let thirdTransform = CGAffineTransform(scaleX: percentOffset.x / 0.75, y: percentOffset.x / 0.75)
            slides[safe: 3]?.configureImageAnimation(transform: thirdTransform)

        } else if percentOffset.x > 0.75, percentOffset.x <= 1 {
            let thirdTransform = CGAffineTransform(
                scaleX: (1 - percentOffset.x) / 0.25,
                y: (1 - percentOffset.x) / 0.25
            )
            slides[safe: 3]?.configureImageAnimation(transform: thirdTransform)

            let fourTransform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
            slides[safe: 4]?.configureImageAnimation(transform: fourTransform)
        }
    }
}
