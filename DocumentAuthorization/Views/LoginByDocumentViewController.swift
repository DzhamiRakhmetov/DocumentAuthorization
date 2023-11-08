//
//  LoginByDocumentViewController.swift
//  DocumentAuthorization
//
//  Created by Dzhami on 02.11.2023.
//

import SnapKit
import UIKit

private enum Sizes {
    static let zero: CGFloat = 0
    static let stackViewSpacing: CGFloat = 5
    static let cornerRadius: CGFloat = 8
    static let errorLabelTopOffset: CGFloat = 10
    static let forgotPasswordTopOffset: CGFloat = 10
    static let keyboardOffset: CGFloat = 10
    static let segmentControlTopOffset: CGFloat = 20
    static let textFieldTopOffset: CGFloat = 20
    static let titleLabelTopOffset: CGFloat = 35
    static let segmentControlHeight: CGFloat = 40
    static let logoTopOffset: CGFloat = 50
    static let buttonTopOffset: CGFloat = 25
    static let labelsStackViewTopOffset: CGFloat = 25
    static let leadingOffset: CGFloat = 16
    static let trailingOffset: CGFloat = -16
    static let textFieldHeight: CGFloat = 55
    static let buttonHeight: CGFloat = 55
}

private enum Numbers {
    static let zero = 0
    static let inputTextRange = 6...20
}

private enum Styles {
    static let titleLabelFont = UIFont.boldSystemFont(ofSize: 24)
    static let segmentControlFont = UIFont.systemFont(ofSize: 18)
    static let errorLabelFont = UIFont.systemFont(ofSize: 12)
    static let labelFont = UIFont.systemFont(ofSize: 12)
    static let buttonFont = UIFont.systemFont(ofSize: 12)
    static let buttonTextColor = UIColor.black
    static let errorLabelTextRedColor = UIColor.red
    static let labelTextBlueColor = UIColor.blue
    static let buttonBackgroundColor = UIColor.gray
    static let segmentControlSelectedTextColor = UIColor.systemBlue
    static let segmentControlNormalTextColor = UIColor.black
    static let segmentControlBackgroundColor = UIColor.clear
    static let textFieldBackgroundColor = UIColor(white: 0.9, alpha: 1.0)
    static let logoImage = UIImage(named: "logo")
}

// MARK: - LoginByDocumentViewController Class

final class LoginByDocumentViewController: UIViewController {
    
    var viewModel: LoginByDocumentViewModel?
    var coordinator: AppCoordinator?
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Styles.logoImage
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLabels.LoginByDocumentVC.welcomeText
        label.numberOfLines = Numbers.zero
        label.font = Styles.titleLabelFont
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = TextLabels.LoginByDocumentVC.email
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Styles.textFieldBackgroundColor
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = TextLabels.LoginByDocumentVC.password
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Styles.textFieldBackgroundColor
        textField.enablePasswordToggle()
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = Numbers.zero
        label.textColor = Styles.errorLabelTextRedColor
        label.font = Styles.errorLabelFont
        return label
    }()
    
    private lazy var forgotPasswordLabel: UILabel = {
        let label = UILabel()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordLabelDidTapped))
        let forgotPasswordText = TextLabels.LoginByDocumentVC.forgotPassword
        let attributedString = NSMutableAttributedString(string: forgotPasswordText)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: Numbers.zero,
                                                     length: forgotPasswordText.count))
        label.textColor = Styles.labelTextBlueColor
        label.font = Styles.labelFont
        label.isUserInteractionEnabled = true
        label.attributedText = attributedString
        label.addGestureRecognizer(tapGestureRecognizer)
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Sizes.cornerRadius
        button.setTitle(TextLabels.LoginByDocumentVC.next, for: .normal)
        button.setTitleColor(Styles.buttonTextColor, for: .normal)
        button.backgroundColor = Styles.buttonBackgroundColor
        button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var noAccountLabel: UILabel = {
        let label = UILabel()
        label.text = TextLabels.LoginByDocumentVC.noAccount
        label.font = Styles.labelFont
        return label
    }()
    
    private lazy var registerLabel: UILabel = {
        let label = UILabel()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(registerLabelDidTapped))
        let forgotPasswordText = TextLabels.LoginByDocumentVC.register
        let attributedString = NSMutableAttributedString(string: forgotPasswordText)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: Numbers.zero,
                                                     length: forgotPasswordText.count))
        label.textColor = Styles.labelTextBlueColor
        label.font = Styles.labelFont
        label.isUserInteractionEnabled = true
        label.attributedText = attributedString
        label.addGestureRecognizer(tapGestureRecognizer)
        return label
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Sizes.stackViewSpacing
        stackView.addArrangedSubview(noAccountLabel)
        stackView.addArrangedSubview(registerLabel)
        return stackView
    }()
    
    private lazy var segmentControll: UISegmentedControl = {
        let sc = UISegmentedControl(items: [TextLabels.LoginByDocumentVC.phone, TextLabels.LoginByDocumentVC.document])
        sc.setTitleTextAttributes([.font: Styles.segmentControlFont,
                                   .foregroundColor: Styles.segmentControlNormalTextColor],
                                   for: .normal)
        sc.setTitleTextAttributes([.font: Styles.segmentControlFont,
                                   .foregroundColor: Styles.segmentControlSelectedTextColor],
                                   for: .selected)
        sc.setTitleTextAttributes([.foregroundColor: UIColor.systemYellow],
                                   for: .selected)
        sc.backgroundColor = .clear
        sc.layer.borderWidth = Sizes.zero
        sc.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return sc
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupConstraints()
        setupKeyboardNotifications()
    }
    
    init(viewModel: LoginByDocumentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        [logoImageView, titleLabel, emailTextField, errorLabel, passwordTextField, forgotPasswordLabel, button, labelsStackView, segmentControll].forEach {view.addSubview($0)}
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Sizes.logoTopOffset)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Sizes.leadingOffset)
            make.top.equalTo(logoImageView.snp.bottom).offset(Sizes.titleLabelTopOffset)
        }
        
        segmentControll.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Sizes.segmentControlTopOffset)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Sizes.leadingOffset)
            make.height.equalTo(Sizes.segmentControlHeight)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(Sizes.trailingOffset)
            make.top.equalTo(segmentControll.snp.bottom).offset(Sizes.textFieldTopOffset)
            make.height.equalTo(Sizes.textFieldHeight)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalTo(emailTextField)
            make.trailing.equalTo(emailTextField)
            make.top.equalTo(emailTextField.snp.bottom).offset(Sizes.textFieldTopOffset)
            make.height.equalTo(emailTextField)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.leading.equalTo(emailTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(Sizes.errorLabelTopOffset)
        }
        
        forgotPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(Sizes.forgotPasswordTopOffset)
            make.trailing.equalTo(emailTextField)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(forgotPasswordLabel.snp.bottom).offset(Sizes.buttonTopOffset)
            make.leading.equalTo(emailTextField)
            make.trailing.equalTo(emailTextField)
            make.height.equalTo(emailTextField)
        }
        
        labelsStackView.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(Sizes.labelsStackViewTopOffset)
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
        print(TextLabels.LoginByDocumentVC.forgotPassword)
    }
    
    @objc func registerLabelDidTapped() {
        print(TextLabels.LoginByDocumentVC.register)
    }
    
    @objc func textFieldDidChange() {
        let documentNumber = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        let isDocumentValid = validateInput(documentNumber, for: Numbers.inputTextRange)
        let isPasswordValid = validateInput(password, for: Numbers.inputTextRange)
        
        let emailError = isDocumentValid ? "" : TextLabels.LoginByDocumentVC.emailError
        let passwordError = isPasswordValid ? "" : TextLabels.LoginByDocumentVC.passwordError
        
        updateErrorLabel(emailError + "\n" + passwordError)
        updateButtonState(isDocumentValid && isPasswordValid)
    }
    
    @objc func handleSegmentChange() {
        switch segmentControll.selectedSegmentIndex {
        case 0:
            emailTextField.placeholder = TextLabels.LoginByDocumentVC.phoneNumber
        case 1:
            emailTextField.placeholder = TextLabels.LoginByDocumentVC.email
        default:
            break
        }
    }
    
    @objc func buttonDidTapped() {
        let documentNumber = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let message = viewModel?.authentificateUserBy(documentNumber: documentNumber, password: password)
        errorLabel.text = message
    }
    
    // метод скрытия клавиатуры
    @objc func keybordWillHide(notification: NSNotification) {
        self.view.frame.origin.y = Sizes.zero
    }
    
    // метод показа клавиатуры и подъёма экрана наверх
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let buttonFrameInWindow = button.convert(button.bounds, to: nil)
            let bottomOfButton = buttonFrameInWindow.maxY
            let offset = bottomOfButton + Sizes.keyboardOffset - (self.view.frame.size.height - keyboardSize.height)
            
            if offset > Sizes.zero {
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



