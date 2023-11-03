//
//  Extensions.swift
//  DocumentAuthorization
//
//  Created by Dzhami on 02.11.2023.
//

import UIKit

extension UITextField {
    fileprivate func setPasswordToggleImage(_ button: UIButton) {
        if isSecureTextEntry {
            button.setImage(UIImage(systemName: "eye.slash")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal), for: .normal)
        }else{
            button.setImage(UIImage(systemName: "eye")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal), for: .normal)
        }
    }

    func enablePasswordToggle() {
        let button = UIButton(type: .custom)
        setPasswordToggleImage(button)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
        self.rightView = button
        self.rightViewMode = .always
    }

    @objc func togglePasswordView(_ sender: Any) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        setPasswordToggleImage(sender as! UIButton)
    }
}


