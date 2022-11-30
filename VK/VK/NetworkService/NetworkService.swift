// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Alamofire
import Foundation

/// Сервис загрузки данных из Вконтакте
final class NetworkService: NetworkServicable {
    // MARK: - Public properties

    static let shared = NetworkService()
    var token: String?

    // MARK: - Private properties

    /// Виды полей
    private enum QueryItems: String {
        case schemeName = "https"
        case hostName = "oauth.vk.com"
        case authPathName = "/authorize/"
        case apiHostName = "api.vk.com"
        case apiPathName = "/method/"
        case clientID = "client_id"
        case clientIDValue = "51489508"
        case appVersionName = "v"
        case accessToken = "access_token"
        case fields
        case friendListMethodName = "friends.get"
        case photoMethodName = "photos.getUserPhotos"
        case groupsListMethodName = "groups.get"
        case redirectURLName = "redirect_url"
        case redirectURLValue = "https://oauth.vk.com/blank.html"
        case responseTypeName = "response_type"
        case responseTypeValue = "token"
        case appVersionValue = "5.131"
        case searchMethodName = "groups.search"
        case scopeTypeName = "scope"
        case scropeTypeValue = "photos"
        case getPhotoMethodName = "photos.getAll"
        case ownerIDName = "owner_id"
        case modeParamName = "extended"
        case modeParamValue = "1"
        case fieldsValue = "city, photo_200_orig"
        case groupFieldsValue = "description"
        case emptyString = ""
    }

    private lazy var defaultQueryItems = [
        URLQueryItem(name: QueryItems.accessToken.rawValue, value: token ?? QueryItems.emptyString.rawValue),
        URLQueryItem(name: QueryItems.clientID.rawValue, value: QueryItems.clientIDValue.rawValue),
        URLQueryItem(name: QueryItems.appVersionName.rawValue, value: QueryItems.appVersionValue.rawValue)
    ]

    private let authorizationDefaultQueryItems = [
        URLQueryItem(name: QueryItems.redirectURLName.rawValue, value: QueryItems.redirectURLValue.rawValue),
        URLQueryItem(name: QueryItems.responseTypeName.rawValue, value: QueryItems.responseTypeValue.rawValue),
        URLQueryItem(name: QueryItems.clientID.rawValue, value: QueryItems.clientIDValue.rawValue),
        URLQueryItem(name: QueryItems.scopeTypeName.rawValue, value: QueryItems.scropeTypeValue.rawValue),
    ]

    // MARK: - Private init

    private init() {}

    // MARK: - Public methods

    func getAuthPageRequest() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = QueryItems.schemeName.rawValue
        urlComponents.host = QueryItems.hostName.rawValue
        urlComponents.path = QueryItems.authPathName.rawValue
        urlComponents.queryItems = authorizationDefaultQueryItems

        guard let url = urlComponents.url else { return nil }
        return url
    }

    func fetchFriends(complition: @escaping (Decodable) -> ()) {
        let parametersMap = [
            QueryItems.fields.rawValue: QueryItems.fieldsValue.rawValue,
        ]
        var urlComponents = URLComponents()
        urlComponents.scheme = QueryItems.schemeName.rawValue
        urlComponents.host = QueryItems.apiHostName.rawValue
        urlComponents.path = QueryItems.apiPathName.rawValue + QueryItems.friendListMethodName.rawValue
        urlComponents.queryItems = defaultQueryItems + makeURLQueryItems(itemsMap: parametersMap)

        guard let url = urlComponents.url else { return }
        sendRequest(url: url, method: .get, model: ResponseWithFriends.self) { result in
            complition(result)
        }
    }

    func fetchClientsGroups(complition: @escaping (ResponseWithGroups) -> ()) {
        let parametersMap = [
            QueryItems.modeParamName.rawValue: QueryItems.modeParamValue.rawValue,
            QueryItems.fields.rawValue: QueryItems.modeParamValue.rawValue
        ]
        var urlComponents = URLComponents()
        urlComponents.scheme = QueryItems.schemeName.rawValue
        urlComponents.host = QueryItems.apiHostName.rawValue
        urlComponents.path = QueryItems.apiPathName.rawValue + QueryItems.groupsListMethodName.rawValue
        urlComponents.queryItems = defaultQueryItems + makeURLQueryItems(itemsMap: parametersMap)

        guard let url = urlComponents.url else { return }
        sendRequest(url: url, method: .get, model: ResponseWithGroups.self) { result in
            complition(result)
        }
    }

    func fetchFoundGroups(parametrsMap: [String: String], complition: @escaping (ResponseWithGroups) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.scheme = QueryItems.schemeName.rawValue
        urlComponents.host = QueryItems.apiHostName.rawValue
        urlComponents.path = QueryItems.apiPathName.rawValue + QueryItems.searchMethodName.rawValue
        urlComponents.queryItems = defaultQueryItems + makeURLQueryItems(itemsMap: parametrsMap)

        guard let url = urlComponents.url else { return }

        sendRequest(url: url, method: .get, model: ResponseWithGroups.self) { result in
            complition(result)
        }
    }

    func fetchAllPhoto(by id: Int, complition: @escaping (Decodable) -> ()) {
        let parametersMap = [
            QueryItems.ownerIDName.rawValue: "\(id)",
            QueryItems.modeParamName.rawValue: QueryItems.modeParamValue.rawValue
        ]

        var urlComponents = URLComponents()
        urlComponents.scheme = QueryItems.schemeName.rawValue
        urlComponents.host = QueryItems.apiHostName.rawValue
        urlComponents.path = QueryItems.apiPathName.rawValue + QueryItems.getPhotoMethodName.rawValue
        urlComponents.queryItems = defaultQueryItems + makeURLQueryItems(itemsMap: parametersMap)

        guard let url = urlComponents.url else { return }
        sendRequest(url: url, method: .get, model: ResponseWithPhoto.self) { result in
            complition(result)
        }
    }

    func fetchPhoto(by urlString: String, completion: @escaping (Data) -> ()) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            AF.request(url).responseData { response in
                guard let data = response.data else { return }
                completion(data)
            }
        }
    }

    // MARK: - Private methods

    private func sendRequest<T: Decodable>(
        url: URL,
        method: HTTPMethod,
        model: T.Type,
        complition: @escaping (T) -> ()
    ) {
        AF.request(url, method: .get).responseData(completionHandler: { response in
            guard
                let data = response.value,
                let decodedData = try? JSONDecoder().decode(model, from: data)
            else { return }
            complition(decodedData)
        })
    }

    private func makeURLQueryItems(itemsMap: [String: String]) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []

        for item in itemsMap {
            queryItems.append(URLQueryItem(name: item.key, value: item.value))
        }

        return queryItems
    }
}
