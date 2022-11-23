// NetworkServiceImp.swift
// Copyright © RoadMap. All rights reserved.

import Alamofire
import Foundation

/// Сервис загрузки данных из Вконтакте
final class NetworkServiceImplementation {
    // MARK: - Private constants

    private struct Constants {
        static let schemeName = "https"
        static let hostName = "oauth.vk.com"
        static let authPathName = "/authorize/"
        static let apiHostName = "api.vk.com"
        static let apiPathName = "/method/"
    }
}

extension NetworkServiceImplementation: NetworkService {
    func getAuthPageRequest(queryItems: [URLQueryItem]) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.schemeName
        urlComponents.host = Constants.hostName
        urlComponents.path = Constants.authPathName
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else { return nil }
        return url
    }

    func getInfoFor(method: String, queryItems: [URLQueryItem]) {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.schemeName
        urlComponents.host = Constants.apiHostName
        urlComponents.path = Constants.apiPathName + method
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else { return }

        AF.request(url, method: .get).responseJSON { response in
            print("\(method) \(String(describing: response.value))")
        }
    }
}
