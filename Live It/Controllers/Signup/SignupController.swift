//
//  SignupController.swift
//  Live It
//
//  Created by Muniyaraj on 20/08/24.
//

import UIKit

final class SignupController: BaseController {
    
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var loginBtn: AppButton!
    @IBOutlet weak var signupBtn: AttributedButton!
    @IBOutlet weak var titleLabel: CustomizeLabel!
    @IBOutlet weak var signupView: SignupEmailView!
    
    enum PageType: String{
        case login
        case signup
    }
    
    var pageType: PageType
    
    init(pageType: PageType) {
        self.pageType = pageType
        super.init(nibName: "SignupController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButton()
        initalizeUI()
        print("Current Page : \(pageType.rawValue)")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func initalizeUI(){
        setupView()
        setupTheme()
        setupLang()
        setupFont()
        setupDelegate()
        setupAction()
    }
    private func setupView(){
        titleLabel.titleColor = .TextPlumColor
        titleLabel.subTitleColor = .TextPlumColor
        titleLabel.titleFont = .customFont(style: .medium, size: 36)
        titleLabel.subTitleFont = .customFont(style: .regular, size: 16)
        titleLabel.titleAlignment = .left
        titleLabel.subTitleAlignment = .left
        
        signupView.textFieldHeight = 55
        
        logoView.image = UIImage(named: "logo")
        
        #if DEBUG
        signupView.textField.text = "Muniyaraj@gmail.com"
        loginBtn.EnableButton()
        #else
        loginBtn.disbleButton()
        #endif
    }
    private func setupConstrainats(){
        
    }
    private func setupTheme(){
    }
    internal override func setupLang(){
        super.setupLang()
        DispatchQueue.main.async { [weak self] in
            guard let self else{ return }
            switch pageType {
            case .login:
                loginBtn.title = "login".localized(using: localizeService)
                signupBtn.titleText = "dont_have_ac".localized(using: localizeService)
                signupBtn.subTitleText = "signup".localized(using: localizeService)
            case .signup:
                loginBtn.title = "sign_up".localized(using: localizeService)
                signupBtn.titleText = "alerady_have_ac".localized(using: localizeService)
                signupBtn.subTitleText = "login".localized(using: localizeService)
            }
            
            signupView.TitleText = "phone_or_email".localized(using: localizeService)
            
            titleLabel.titleText = "live_it".localized(using: localizeService)
            titleLabel.subTitleText = "happly_to_have_here".localized(using: localizeService)
            
            view.updateTextAlignment(for: localizeService)
        }
    }
    private func setupFont(){
        
    }
    private func setupDelegate(){
        signupView.textField.delegate = self
    }
    private func setupAction(){
        loginBtn.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        signupBtn.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    @objc func buttonAction(_ sender: UIButton){
        switch (sender, pageType){
        case (loginBtn,.login):
            navigationOnOTP_Page()
            break
        case (loginBtn,.signup):
            navigationOnOTP_Page()
            break
            
        case (signupBtn, .login):
            let newPageType: PageType = .signup
            navigateToPage(with: newPageType)
            break
            
        case (signupBtn, .signup):
            let newPageType: PageType = .login
            navigateToPage(with: newPageType)
            break
            default: break
        }
    }
    
    private func navigateToPage(with pageType: PageType) {
        if let navigationController = self.navigationController {
            for controller in navigationController.viewControllers {
                if let signupController = controller as? SignupController, signupController.pageType == pageType {
                    navigationController.popToViewController(signupController, animated: true)
                    return
                }
            }
            
            let signupController = SignupController(pageType: pageType)
            navigationController.pushToController(signupController, languageService: localizeService)
        }
    }
    private func navigationOnOTP_Page(){
        guard let text = signupView.textField.text,(text == "Muniyaraj@gmail.com" || text == "1234567890") else{
            signupView.errorText = "We could not find an account linked to this email address"
            signupView.throwError = true
            signupView.headLabel.textAlignment = localizeService?.currentLanguage == .arabic ? .right : .left
            signupView.errorLabel.textAlignment = localizeService?.currentLanguage == .arabic ? .right : .left
            return
        }
        signupView.throwError = false
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [weak self] in
            let verificationPage = OTPVerificationController()
            self?.navigationController?.pushToController(verificationPage, languageService: self?.localizeService)
        }
    }
}
extension SignupController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = (textField.text as? NSString)?.replacingCharacters(in: range, with: string) ?? ""
        let isValid = validateEmailPhone(currentString)
        isValid ? loginBtn.EnableButton() : loginBtn.disbleButton()
        return true
    }
    func validateEmailPhone(_ string: String) -> Bool{
        return string.isValidEmail() || string.isValidPhoneNumber()
    }
}
