// UIImageVIew+Extension.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

// Добавляет возможность загрузки изображения по строке ссылки.
extension UIImageView {
    func loadImageFromURL(urlString: String) {
        let networkService = NetworkService()
        networkService.fetchPhoto(by: urlString) { result in
            switch result {
            case let .success(success):
                DispatchQueue.main.async {
                    guard let downloadedImage = UIImage(data: success) else { return }
                    self.image = downloadedImage
                }
            case let .failure(failure):
                print(failure.localizedDescription)
            }
        }
    }
}
