//
//  AddPersonalInfoController.swift
//  Live It
//
//  Created by Muniyaraj on 22/08/24.
//

import UIKit

final class AddPersonalInfoController: BaseController {
    
    @IBOutlet weak var nameFieldView: TextNameView!
    @IBOutlet weak var nextBtn: LoadingButton!
    
    @IBOutlet weak var  buttonBottomConstraint: NSLayoutConstraint!
    
    var personalInfo: PersonalInfo
    
    var userNameAvailabilityWorkItem: DispatchWorkItem?
    
    init(personalInfo: PersonalInfo) {
        self.personalInfo = personalInfo
        super.init(nibName: "AddPersonalInfoController", bundle: Bundle.main)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButton()
        initalizeUI()
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
        observeNotification()
    }
    private func setupView(){
        
    }
    private func setupTheme(){
        
    }
    internal override func setupLang(){
        super.setupLang()
        DispatchQueue.main.async { [weak self] in
            guard let self else{ return }
            let details = personalInfo.details
            navigationItem.title = details.pageTitle.localized(using: localizeService)
            nameFieldView.TitleText = details.textFieldTitle.localized(using: localizeService)
            nameFieldView.placeholderText = details.placeholder.localized(using: localizeService)
            nextBtn.enableTitle_Text = details.nextButtonTitle.localized(using: localizeService)
            nextBtn.disbleTitle_Text = details.nextButtonTitle.localized(using: localizeService)
            
            view.updateTextAlignment(for: localizeService)
        }
    }
    private func setupFont(){
        let attributes = NSAttributedString.createAttributes(font: .customFont(style: .semiBold, size: 16), color: .TextPrimaryColor, lineSpacing: 0)
        setNavigationBarTitleAttributes(attributes)
    }
    private func setupDelegate(){
        nameFieldView.textField.delegate = self
    }
    private func setupAction(){
        nextBtn.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    private func observeNotification(){
        // Add keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc private func buttonAction(_ sender: UIButton){
        switch sender{
            case nextBtn:
                setupNavigationPages()
                break
            default: break
        }
    }
    private func setupNavigationPages(){
        nextBtn.startLoading()
        let newPersonPage: PersonalInfo
        switch personalInfo {
        case .firstname:
            newPersonPage = .lastname
            break
        case .lastname:
            newPersonPage = .username
            break
        case .username:
            newPersonPage = .username
            break
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){ [weak self] in
            self?.nextBtn.stopLoading()
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                guard let self = self else { return }
                if self.personalInfo != .username{
                        let personalPage = AddPersonalInfoController(personalInfo: newPersonPage)
                    self.navigationController?.pushToController(personalPage, languageService: self.localizeService)
                }else{
                    let personalizePage = PersonalizeProfileController()
                    self.navigationController?.pushToController(personalizePage, languageService: self.localizeService)
                }
            }
            self?.nameFieldView.textField.resignFirstResponder()
        }
    }
    deinit {
        // Remove keyboard observers
        NotificationCenter.default.removeObserver(self)
    }
}
extension AddPersonalInfoController{
        
        @objc private func keyboardWillShow(_ notification: Notification) {
            adjustButtonForKeyboard(notification: notification, show: true)
        }
        
        @objc private func keyboardWillHide(_ notification: Notification) {
            adjustButtonForKeyboard(notification: notification, show: false)
        }
        
        private func adjustButtonForKeyboard(notification: Notification, show: Bool) {
            guard let userInfo = notification.userInfo,
                  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                  let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
            
            // Adjust the bottom constraint
            buttonBottomConstraint?.constant = show ? keyboardFrame.height + 20 : 30
            
            // Animate the layout changes
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
}
extension AddPersonalInfoController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let minLength: Int = 3
        let maxLength: Int = personalInfo == .username ? 30 : 50
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        do{
            try validate(text: currentText, forField: personalInfo, minLength: minLength, maxLength: maxLength)
            nameFieldView.exp_TextCount = ""
            nameFieldView.current_TextCount = ""
            nameFieldView.errorText = ""
            nameFieldView.throwError = false
            nextBtn.buttonEnabled = true
        }catch let error as TextFieldError{
            print("errors : \(error.errorDescription)")
            switch error {
            case .tooShort( _, _),.uppercaseNotAllowed( _),.invalidCharacters( _):
                nameFieldView.exp_TextCount = ""
                nameFieldView.current_TextCount = ""
                break
            case .tooLong( _, let maxLength):
                nameFieldView.exp_TextCount = maxLength.description
                nameFieldView.current_TextCount = currentText.count.description
                break
            }
            var errorDescription = error.errorDescription.localized(using: localizeService)
            let textFieldTitle = personalInfo.details.textFieldTitle.localized(using: localizeService)
            
            errorDescription = errorDescription.replacingOccurrences(of: "[]", with: "\(textFieldTitle)")
            errorDescription = errorDescription.replacingOccurrences(of: "[)", with: "\(textFieldTitle.lowercased())")
            errorDescription = errorDescription.replacingOccurrences(of: "{}", with: "\(minLength)")
            
            nameFieldView.errorText = errorDescription
            nameFieldView.throwError = true
            nextBtn.buttonEnabled = false
        }catch{
            print("unwanted error : \(error.localizedDescription)")
        }
        return true
    }
    func validate(text: String, forField field: PersonalInfo,minLength: Int,maxLength: Int) throws{
        if text.count < minLength{
            throw TextFieldError.tooShort(field: field, minLength: minLength)
        }else if text.count > maxLength{
            throw TextFieldError.tooLong(field: field, maxLength: maxLength)
        }
        if text.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil && field == .username{
            throw TextFieldError.uppercaseNotAllowed(field: field)
        }
        let invalidCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789._").inverted
        if text.rangeOfCharacter(from: invalidCharacters) != nil && field == .username{
            throw TextFieldError.invalidCharacters(field: field)
        }
    }
    func checkUserNameAvailable(_ userName: String){
        userNameAvailabilityWorkItem?.cancel()
        let workItem: DispatchWorkItem = DispatchWorkItem{
            
            // checks the place for username availablity ( API Call )
        }
        userNameAvailabilityWorkItem = workItem
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1), execute: workItem)
    }
}

enum TextFieldError: Error{
    case tooShort(field: PersonalInfo, minLength: Int)
    case tooLong(field: PersonalInfo, maxLength: Int)
    case uppercaseNotAllowed(field: PersonalInfo)
    case invalidCharacters(field: PersonalInfo)
    
    var errorDescription: String{
        switch self {
        case .tooShort(_, _):
//            [] - TextfieldTile
//            [) - TextfieldTile lowercased
//            {} - length
//            {} - length
            //return "\(field.details.textFieldTitle) must contain at least \(minLength) characters"
            return "name_must_contain_atleast_characters"
        case .tooLong(let field, _):
            //return field == .username ? "Please make your \(field.details.textFieldTitle) shorter." : "Please enter a shorter \(field.details.textFieldTitle.lowercased())"
            return field == .username ? "please_make_your_username_shorter" : "please enter_shorter_"
        case .uppercaseNotAllowed(_):
            //return "\(field.details.textFieldTitle) cannot contain uppercase letters"
            return "cannot_contain_uppercase"
        case .invalidCharacters(_):
            //return "Usernames can only use letters, numbers, underscores (_) and periods (.)"
            return "username_allowed_chars"
        }
    }
}



enum PersonalInfo{
    case firstname
    case lastname
    case username
    
    var details: PersonalDetails{
        switch self {
        case .firstname:
            return PersonalDetails(pageTitle: "what_first_name", textFieldTitle: "first_name", placeholder: "enter_your_name", nextButtonTitle: "next_add_last_name")
        case .lastname:
            return PersonalDetails(pageTitle: "what_last_name", textFieldTitle: "last_name", placeholder: "enter_your_name", nextButtonTitle: "next_create_user_name")
        case .username:
            return PersonalDetails(pageTitle: "create_user_name", textFieldTitle: "user_name", placeholder: "enter_user_name", nextButtonTitle: "next_upload_picture")
        }
    }
}

struct PersonalDetails{
    let pageTitle: String
    let textFieldTitle: String
    let placeholder: String
    let nextButtonTitle: String
}
