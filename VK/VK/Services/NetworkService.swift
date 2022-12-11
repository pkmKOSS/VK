// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Alamofire
import PromiseKit

/// Сервис загрузки данных из Вконтакте
final class NetworkService: NetworkServicable {
    // MARK: - Public properties

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
        case clientIDValue = "51491322"
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
        case wallPostMethodName = "wall.get"
        case newsPostsFeildsValue = "date, text, comments, likes, attachments"
    }

    private lazy var defaultQueryItems = [
        URLQueryItem(
            name: QueryItems.accessToken.rawValue,
            value: Session.shared.accessToken ?? QueryItems.emptyString.rawValue
        ),
        URLQueryItem(name: QueryItems.clientID.rawValue, value: QueryItems.clientIDValue.rawValue),
        URLQueryItem(name: QueryItems.appVersionName.rawValue, value: QueryItems.appVersionValue.rawValue)
    ]

    private let authorizationDefaultQueryItems = [
        URLQueryItem(name: QueryItems.redirectURLName.rawValue, value: QueryItems.redirectURLValue.rawValue),
        URLQueryItem(name: QueryItems.responseTypeName.rawValue, value: QueryItems.responseTypeValue.rawValue),
        URLQueryItem(name: QueryItems.clientID.rawValue, value: QueryItems.clientIDValue.rawValue),
        URLQueryItem(name: QueryItems.scopeTypeName.rawValue, value: QueryItems.scropeTypeValue.rawValue),
    ]

    private let dataCashService = DataCashService()

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

    func fetchFriends(completion: @escaping (Swift.Result<FriendsResponse, Error>) -> ()) {
        let parametersMap = [
            QueryItems.fields.rawValue: QueryItems.fieldsValue.rawValue,
        ]
        var urlComponents = URLComponents()
        urlComponents.scheme = QueryItems.schemeName.rawValue
        urlComponents.host = QueryItems.apiHostName.rawValue
        urlComponents.path = QueryItems.apiPathName.rawValue + QueryItems.friendListMethodName.rawValue
        urlComponents.queryItems = defaultQueryItems + makeURLQueryItems(itemsMap: parametersMap)

        guard let url = urlComponents.url else { return }
        sendRequest(url: url, method: HTTPMethod.get, model: FriendsResponse.self, completion: completion)
    }

    func fetchClientsGroups() -> Promise<[Group]>? {
        let parametersMap = [
            QueryItems.modeParamName.rawValue: QueryItems.modeParamValue.rawValue,
            QueryItems.fields.rawValue: QueryItems.modeParamValue.rawValue
        ]
        var urlComponents = URLComponents()
        urlComponents.scheme = QueryItems.schemeName.rawValue
        urlComponents.host = QueryItems.apiHostName.rawValue
        urlComponents.path = QueryItems.apiPathName.rawValue + QueryItems.groupsListMethodName.rawValue
        urlComponents.queryItems = defaultQueryItems + makeURLQueryItems(itemsMap: parametersMap)

        guard let url = urlComponents.url else { return nil }

        let promise = Promise<[Group]> { resolver in
            AF.request(url, method: HTTPMethod.get).responseData { response in
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let items = try decoder.decode(GroupsResponse.self, from: data)
                    resolver.fulfill(items.response.items)
                } catch {
                    resolver.reject(error)
                }
            }
        }
        return promise
    }

    func fetchFoundGroups(
        parametrsMap: [String: String],
        completion: @escaping (Swift.Result<GroupsResponse, Error>) -> ()
    ) {
        var urlComponents = URLComponents()
        urlComponents.scheme = QueryItems.schemeName.rawValue
        urlComponents.host = QueryItems.apiHostName.rawValue
        urlComponents.path = QueryItems.apiPathName.rawValue + QueryItems.searchMethodName.rawValue
        urlComponents.queryItems = defaultQueryItems + makeURLQueryItems(itemsMap: parametrsMap)

        guard let url = urlComponents.url else { return }

        sendRequest(url: url, method: HTTPMethod.get, model: GroupsResponse.self, completion: completion)
    }

    func fetchPosts(by id: Int, completion: @escaping (Swift.Result<NewsPostResponse, Error>) -> ()) {
        let parametersMap = [
            QueryItems.modeParamName.rawValue: QueryItems.modeParamValue.rawValue,
            QueryItems.fields.rawValue: QueryItems.newsPostsFeildsValue.rawValue,
            QueryItems.ownerIDName.rawValue: String(id)
        ]
        var urlComponents = URLComponents()
        urlComponents.scheme = QueryItems.schemeName.rawValue
        urlComponents.host = QueryItems.apiHostName.rawValue
        urlComponents.path = QueryItems.apiPathName.rawValue + QueryItems.wallPostMethodName.rawValue
        urlComponents.queryItems = defaultQueryItems + makeURLQueryItems(itemsMap: parametersMap)

        guard let url = urlComponents.url else { return }
        sendRequest(url: url, method: HTTPMethod.get, model: NewsPostResponse.self, completion: completion)
    }

    func fetchAllPhoto(by id: Int, completion: @escaping (Swift.Result<PhotoResponse, Error>) -> ()) {
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
        sendRequest(url: url, method: HTTPMethod.get, model: PhotoResponse.self, completion: completion)
    }

    func fetchPhoto(isCashingEnable: Bool, by urlString: String, completion: @escaping (Swift.Result<Data, Swift.Error>) -> ()) {
        var fetchedData: Data?

        if isCashingEnable {
            dataCashService.loadDataFromCache(fileURL: urlString, cashDataType: .images) { result in
                switch result {
                case let .success(data):
                    fetchedData = data
                    completion(.success(data))
                case let .failure(error):
                    print("\(error)")
                }
            }
        }

        guard
            fetchedData == nil,
            let url = URL(string: urlString)
        else { return }

        DispatchQueue.global().async {
            AF.request(url, method: .get).responseData { response in
                switch response.result {
                case let .success(data):
                    self.dataCashService.saveDataToCache(fileURL: urlString, data: data, cashDataType: .images)
                    completion(.success(data))
                case let .failure(afError):
                    completion(.failure(afError))
                }
            }
        }
    }

    // MARK: - Private methods

    private func sendRequest<T: Decodable>(
        url: URL,
        method: HTTPMethod,
        model: T.Type,
        completion: @escaping (Swift.Result<T, Error>) -> ()
    ) {
        AF.request(url, method: .get).responseDecodable(of: T.self) { response in
            switch response.result {
            case let .success(data):
                completion(.success(data))
            case let .failure(afError):
                completion(.failure(afError))
            }
        }
    }

    private func makeURLQueryItems(itemsMap: [String: String]) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []

        for item in itemsMap {
            queryItems.append(URLQueryItem(name: item.key, value: item.value))
        }

        return queryItems
    }
}
