//
//  ViewController.swift
//  DocumentAuthorization
//
//  Created by Dzhami on 02.11.2023.
//

import SnapKit
import UIKit

final class LoginByDocumentViewController: UIViewController {
    
    var viewModel: LoginByDocumentViewModel?
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Привет! \nВойдите в Бэта-Банк"
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private lazy var documentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Серия и номер паспорта"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
        textField.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пароль"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        textField.enablePasswordToggle()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароль должен содержать от 6 до 20 символов"
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var documentErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "Документ должен содержать от 6 до 20 символов"
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var forgotPasswordLabel: UILabel = {
        let label = UILabel()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordLabelDidTapped))
        let forgotPasswordText = "Забыли пароль?"
        let attributedString = NSMutableAttributedString(string: forgotPasswordText)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0,
                                                     length: forgotPasswordText.count))
        label.textColor = UIColor.blue
        label.font = UIFont.systemFont(ofSize: 12)
        label.isUserInteractionEnabled = true
        label.attributedText = attributedString
        label.addGestureRecognizer(tapGestureRecognizer)
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.setTitle("Вперед", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.gray
        button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var noAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "У вас нет аккаунта?"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var registerLabel: UILabel = {
        let label = UILabel()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(registerLabelDidTapped))
        let forgotPasswordText = "Зарегестрируйтесь"
        let attributedString = NSMutableAttributedString(string: forgotPasswordText)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0,
                                                     length: forgotPasswordText.count))
        label.textColor = UIColor.blue
        label.font = UIFont.systemFont(ofSize: 12)
        label.isUserInteractionEnabled = true
        label.attributedText = attributedString
        label.addGestureRecognizer(tapGestureRecognizer)
        return label
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.addArrangedSubview(noAccountLabel)
        stackView.addArrangedSubview(registerLabel)
        return stackView
    }()
    // проверка на количество символов 
    private var isPasswordValid: Bool {
        if let password = passwordTextField.text, (6...20).contains(password.count) {
            return true
        }
        return false
    }
    
    private var isDocumentValid: Bool {
        if let document = documentTextField.text, (6...20).contains(document.count) {
            return true
        }
        return false
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        documentTextField.delegate = self
        passwordTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        viewModel = LoginByDocumentViewModel()
        
        setupConstraints()
        updateButtonState()
        
        
    }
    
    private func setupConstraints() {
        
        
        [logoImageView, titleLabel, documentTextField, passwordErrorLabel, documentErrorLabel, passwordTextField, forgotPasswordLabel, button, labelsStackView].forEach {view.addSubview($0)}
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(logoImageView.snp.bottom).offset(35)
        }
        
        documentTextField.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.height.equalTo(55)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalTo(documentTextField)
            make.trailing.equalTo(documentTextField)
            make.top.equalTo(documentTextField.snp.bottom).offset(16)
            make.height.equalTo(documentTextField)
        }
        
        documentErrorLabel.snp.makeConstraints { make in
            make.leading.equalTo(documentTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
        }
        
        passwordErrorLabel.snp.makeConstraints { make in
            make.leading.equalTo(documentTextField)
            make.top.equalTo(documentErrorLabel.snp.bottom).offset(5)
        }
        
        forgotPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordErrorLabel.snp.bottom).offset(10)
            make.trailing.equalTo(documentTextField)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(forgotPasswordLabel.snp.bottom).offset(25)
            make.leading.equalTo(documentTextField)
            make.trailing.equalTo(documentTextField)
            make.height.equalTo(documentTextField)
        }
        
        labelsStackView.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }
    }
    
    private func updateButtonState() {
        button.isUserInteractionEnabled = isPasswordValid && isDocumentValid
        button.backgroundColor = button.isUserInteractionEnabled ? UIColor.yellow : UIColor.gray
    }
    
    private func updateErrorLabels() {
        if isPasswordValid {
            passwordErrorLabel.isHidden = true
        } else {
            passwordErrorLabel.isHidden = false
        }
        if isDocumentValid {
            documentErrorLabel.isHidden = true
        } else {
            documentErrorLabel.isHidden = false
        }
    }
    
    
    // MARK: - @objc fun
    
    @objc func forgotPasswordLabelDidTapped() {
        print("Забыли пароль?")
    }
    
    @objc func registerLabelDidTapped() {
        print("Зарегистрируйтесь")
    }
    
    @objc func textFieldDidChange() {
        updateButtonState()
        updateErrorLabels()
    }
    
    @objc func buttonDidTapped() {
        print("Button did taped")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let buttonFrameInWindow = button.convert(button.bounds, to: nil)
            let bottomOfButton = buttonFrameInWindow.maxY
            
            let offset = bottomOfButton + 10 - (self.view.frame.size.height - keyboardSize.height)
            
            if offset > 0 {
                self.view.frame.origin.y -= offset
            }
        }
    }
    
    @objc func keybordWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}

extension LoginByDocumentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}



