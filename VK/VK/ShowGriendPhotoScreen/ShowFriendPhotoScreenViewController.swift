// ShowFriendPhotoScreenViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран просмотра фотографии друга.
final class ShowFriendPhotoScreenViewController: UIViewController {
    // MARK: - Privta @IBOutlet

    @IBOutlet var showPhotoScrollView: UIScrollView!
    @IBOutlet var pageControllView: UIPageControl!

    // MARK: - Public properties

    var friend: NetworkUnit?

    // MARK: - Private properties

    private var currentSlideCounter = 0
    private var slides: [ShowPhotoView]?
    private var tapHandler: (() -> ())?

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
        slides = configureSlides()
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
            slide.photoImageView.image = UIImage(named: image)
            let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(gestoreAction))
            recognizer.direction = .down
            slide.photoImageView.addGestureRecognizer(recognizer)
            slide.photoImageView.isUserInteractionEnabled = true
            slides.append(slide)
        }

        return slides
    }

    private func configureScrollView() {
        guard let slidesForScroll = slides else { return }
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
        pageControllView.numberOfPages = slides?.count ?? 0
        pageControllView.currentPage = 0
        view.bringSubviewToFront(pageControllView)
    }

    private func configureTapHandler() {
        tapHandler = {
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
        guard let slides = slides else { return }
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControllView.currentPage = Int(pageIndex)

        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x

        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y

        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset

        let percentOffset = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)

        if percentOffset.x > 0, percentOffset.x <= 0.25 {
            slides[0].photoImageView
                .transform = CGAffineTransform(
                    scaleX: (0.25 - percentOffset.x) / 0.25,
                    y: (0.25 - percentOffset.x) / 0.25
                )
            slides[1].photoImageView
                .transform = CGAffineTransform(scaleX: percentOffset.x / 0.25, y: percentOffset.x / 0.25)

        } else if percentOffset.x > 0.25, percentOffset.x <= 0.50 {
            slides[1].photoImageView
                .transform = CGAffineTransform(
                    scaleX: (0.50 - percentOffset.x) / 0.25,
                    y: (0.50 - percentOffset.x) / 0.25
                )
            slides[2].photoImageView
                .transform = CGAffineTransform(scaleX: percentOffset.x / 0.50, y: percentOffset.x / 0.50)

        } else if percentOffset.x > 0.50, percentOffset.x <= 0.75 {
            slides[2].photoImageView
                .transform = CGAffineTransform(
                    scaleX: (0.75 - percentOffset.x) / 0.25,
                    y: (0.75 - percentOffset.x) / 0.25
                )
            slides[3].photoImageView
                .transform = CGAffineTransform(scaleX: percentOffset.x / 0.75, y: percentOffset.x / 0.75)

        } else if percentOffset.x > 0.75, percentOffset.x <= 1 {
            slides[3].photoImageView
                .transform = CGAffineTransform(scaleX: (1 - percentOffset.x) / 0.25, y: (1 - percentOffset.x) / 0.25)
            slides[4].photoImageView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
        }
    }
}
