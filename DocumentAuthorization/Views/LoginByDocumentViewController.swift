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
        textField.delegate = self
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
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel = LoginByDocumentViewModel()
    
        setupConstraints()
        setupKeyboardNotifications()
    }
    
    private func setupConstraints() {
        [logoImageView, titleLabel, documentTextField, errorLabel, passwordTextField, forgotPasswordLabel, button, labelsStackView].forEach {view.addSubview($0)}
        
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
        
        errorLabel.snp.makeConstraints { make in
            make.leading.equalTo(documentTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
        }
        
        forgotPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(10)
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
    
    // MARK: - Funcs
    
    // метод для управления отображением клавиатуры и сдвигом экрана
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // проверка на количество символов
    private func validateInput(_ inputText: String, for range: ClosedRange<Int>) -> Bool {
        return range.contains(inputText.count)
    }
    
    private func updateErrorLabel(_ errorText: String) {
        errorLabel.text = errorText
    }
    
    private func updateButtonState(_ isEnabled: Bool) {
        button.isUserInteractionEnabled = isEnabled
        button.backgroundColor = isEnabled ? UIColor.yellow : UIColor.gray
    }
    
    // MARK: - @objc fun
    
    @objc func forgotPasswordLabelDidTapped() {
        print("Забыли пароль?")
    }
    
    @objc func registerLabelDidTapped() {
        print("Зарегистрируйтесь")
    }
    
    @objc func textFieldDidChange() {
        let documentNumber = documentTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        let isDocumentValid = validateInput(documentNumber, for: 6...20)
        let isPasswordValid = validateInput(password, for: 6...20)
        
        let documentError = isDocumentValid ? "" : "Документ должен содержать от 6 до 20 символов"
        let passwordError = isPasswordValid ? "" : "Пароль должен содержать от 6 до 20 символов"
        
        updateErrorLabel(documentError + "\n" + passwordError)
        updateButtonState(isDocumentValid && isPasswordValid)
    }
    
    @objc func buttonDidTapped() {
        let documentNumber = documentTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let message = viewModel?.authentificateUserBy(documentNumber: documentNumber, password: password)
        errorLabel.text = message
    }
    
    // метод скрытия клавиатуры
    @objc func keybordWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    // метод показа клавиатуры и подъёма экрана наверх
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
}

// MARK: - Extensions
extension LoginByDocumentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}



