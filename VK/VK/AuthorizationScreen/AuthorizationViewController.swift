// AuthorizationViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit
import WebKit

/// Экран авторизации.
final class AuthorizationViewController: UIViewController {
    // MARK: - Private visual components

    @IBOutlet private var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }

    // MARK: - Private constants

    private struct Constants {
        static let friendListMethodName = "friends.get"
        static let photoMethodName = "photos.getUserPhotos"
        static let groupsListMethodName = "groups.get"
        static let clientIDName = "client_id"
        static let clientIDValue = "51483244"
        static let redirectURLName = "redirect_url"
        static let redirectURLValue = "https://oauth.vk.com/blank.html"
        static let responseTypeName = "response_type"
        static let responseTypeValue = "token"
        static let accessTokenName = "access_token"
        static let versionName = "v"
        static let versionValue = "5.131"
        static let searchParamName = "q"
        static let searchParamValue = "Новости"
        static let searchMethodName = "groups.search"
        static let blankPathName = "/blank.html"
        static let ampersanteCharName = "&"
        static let equalCharName = "="
    }

    // MARK: - Private properties

    private let networkService = NetworkServiceImplementation()

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        openAuthPage()
    }

    // MARK: - Private methods

    private func openAuthPage() {
        let queryItems = [
            URLQueryItem(name: Constants.clientIDName, value: Constants.clientIDValue),
            URLQueryItem(name: Constants.redirectURLName, value: Constants.redirectURLValue),
            URLQueryItem(name: Constants.responseTypeName, value: Constants.responseTypeValue)
        ]

        guard
            let url = networkService.getAuthPageRequest(queryItems: queryItems)
        else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    private func getFriendsIDList() {
        guard let token = Session.shared.accessToken else { return }
        let queryItems = [
            URLQueryItem(name: Constants.clientIDName, value: Constants.clientIDValue),
            URLQueryItem(name: Constants.accessTokenName, value: token),
            URLQueryItem(name: Constants.versionName, value: Constants.versionValue)
        ]
        networkService.getInfoFor(method: Constants.friendListMethodName, queryItems: queryItems)
    }

    private func getPhotos() {
        guard let token = Session.shared.accessToken else { return }
        let queryItems = [
            URLQueryItem(name: Constants.clientIDName, value: Constants.clientIDValue),
            URLQueryItem(name: Constants.accessTokenName, value: token),
            URLQueryItem(name: Constants.versionName, value: Constants.versionValue)
        ]
        networkService.getInfoFor(method: Constants.photoMethodName, queryItems: queryItems)
    }

    private func getGroupsList() {
        guard let token = Session.shared.accessToken else { return }
        let queryItems = [
            URLQueryItem(name: Constants.clientIDName, value: Constants.clientIDValue),
            URLQueryItem(name: Constants.accessTokenName, value: token),
            URLQueryItem(name: Constants.versionName, value: Constants.versionValue)
        ]
        networkService.getInfoFor(method: Constants.groupsListMethodName, queryItems: queryItems)
    }

    private func searchGroups() {
        guard let token = Session.shared.accessToken else { return }
        let queryItems = [
            URLQueryItem(name: Constants.clientIDName, value: Constants.clientIDValue),
            URLQueryItem(name: Constants.accessTokenName, value: token),
            URLQueryItem(name: Constants.versionName, value: Constants.versionValue),
            URLQueryItem(name: Constants.searchParamName, value: Constants.searchParamValue),
        ]
        networkService.getInfoFor(method: Constants.searchMethodName, queryItems: queryItems)
    }
}

// WKNavigationDelegate methods
extension AuthorizationViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
    ) {
        guard
            let url = navigationResponse.response.url,
            url.path == Constants.blankPathName,
            let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }

        let params = fragment
            .components(separatedBy: Constants.ampersanteCharName)
            .map { $0.components(separatedBy: Constants.equalCharName) }
            .reduce([String: String]()) { result, param in
                guard
                    let key = param[safe: 0],
                    let value = param[safe: 1]
                else { return [:] }
                var dict = result
                dict[key] = value
                return dict
            }

        Session.shared.accessToken = params[Constants.accessTokenName]
        print("token \(params[Constants.accessTokenName])")

        // TODO: - Сделать загрузку данных на профильных экранах.
        getFriendsIDList()
        getPhotos()
        getGroupsList()
        searchGroups()
        decisionHandler(.cancel)
    }
}
