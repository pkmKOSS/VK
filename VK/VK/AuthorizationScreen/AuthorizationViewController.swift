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
        static let accessTokenName = "access_token"
        static let fieldsValue = "city"
        static let fieldsName = "fields"
        static let blankPathName = "/blank.html"
        static let ampersanteCharName = "&"
        static let equalCharName = "="
        static let tabBarControllerSegueIDName = "FromAuthScreen"
    }

    // MARK: - Private properties

    private var networkService = NetworkService()

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        openAuthPage()
    }

    // MARK: - Private methods

    private func openAuthPage() {
        guard
            let url = networkService.getAuthPageRequest()
        else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    private func presentNextViewController() {
        performSegue(withIdentifier: Constants.tabBarControllerSegueIDName, sender: nil)
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

        presentNextViewController()
        decisionHandler(.cancel)
    }
}
