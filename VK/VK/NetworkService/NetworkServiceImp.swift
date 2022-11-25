// NetworkServiceImp.swift
// Copyright © RoadMap. All rights reserved.

import Alamofire
import Foundation

/// Сервис загрузки данных из Вконтакте
final class NetworkServiceble {
    // MARK: - Private constants

    private struct Constants {
        static let schemeName = "https"
        static let hostName = "oauth.vk.com"
        static let authPathName = "/authorize/"
        static let apiHostName = "api.vk.com"
        static let apiPathName = "/method/"
        static let accesTokenName = "access_token"
    }
}

extension NetworkServiceble: NetworkService {
    func getAuthPageRequest(queryItems: [URLQueryItem]) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.schemeName
        urlComponents.host = Constants.hostName
        urlComponents.path = Constants.authPathName
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else { return nil }
        return url
    }

    func fetchFriendsID(method: String, queryItems: [URLQueryItem]) {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.schemeName
        urlComponents.host = Constants.apiHostName
        urlComponents.path = Constants.apiPathName + method
        urlComponents.queryItems?.append(URLQueryItem(name: Constants.accesTokenName, value: Session.shared.accessToken))
        urlComponents.queryItems?.append(contentsOf: queryItems)

        guard let url = urlComponents.url else { return }

        AF.request(url, method: .get).responseJSON { response in
            print("\(method) \(String(describing: response.value))")
        }
    }
}
