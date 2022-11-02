// AuthorizationViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран авторизации.
final class AuthorizationViewController: UIViewController {
    // MARK: - private visual components

    @IBOutlet private var authorizationScrollView: UIScrollView!
    @IBOutlet private var loginWithAppleButton: UIButton!
    @IBOutlet private var loginTextField: UITextField!

    // MARK: - life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserves()
        configLoginWithAppleButton()
        addTapGestoreRecognizer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObsevers()
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard
            identifier == StringConstants.segueIdentifier,
            let loginTextFieldText = loginTextField.text
        else { return false }
        guard loginTextFieldText == StringConstants.trueLogin else { return false }
        return true
    }

    // MARK: - private methods

    private func addTapGestoreRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        authorizationScrollView.addGestureRecognizer(tapGesture)
    }

    private func addObserves() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShown),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShown),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func removeObsevers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )

        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
    }

    private func configLoginWithAppleButton() {
        loginWithAppleButton.layer.borderWidth = 1
        loginWithAppleButton.layer.borderColor = UIColor.black.cgColor
    }

    @objc private func keyboardWillShown(notification: Notification) {
        guard let info = notification.userInfo as? NSDictionary else { return }
        guard let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue)?.cgRectValue.size
        else { return }
        let contentInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: kbSize.height,
            right: 0
        )
        authorizationScrollView.contentInset = contentInsets
        authorizationScrollView.scrollIndicatorInsets = contentInsets
    }

    @objc private func keyboardWillHide(notification: Notification) {
        authorizationScrollView.contentInset = UIEdgeInsets.zero
        authorizationScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }

    @objc private func hideKeyboard() {
        authorizationScrollView.endEditing(true)
    }
}
