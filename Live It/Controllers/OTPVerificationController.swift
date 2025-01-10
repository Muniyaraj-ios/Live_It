//
//  OTPVerificationController.swift
//  Live It
//
//  Created by Muniyaraj on 21/08/24.
//

import UIKit
import OTPFieldView
import Toaster

public typealias OTPField = OTPFieldView

final class OTPVerificationController: BaseController {
    
    @IBOutlet weak var titleLabel: AttributedLabel!
    
    @IBOutlet weak var OTPFields: OTPFieldView!
    @IBOutlet weak var errorLabel: AdavanceLabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var resendBtn: UIButton!
    
    private var OTP_fieldCount: CGFloat = 6
    
    private var remainingSeconds: Int = 0
    private var countTimer: Timer?
    var isTimerRunning: Bool = false
    var lastPauseTime: Date?
        
    private let bottomActionView = ToasterActionView()//BottomActionView()
    
    var timing_update: Int = 0{
        didSet{
            let time = (timing_update < 2 ? "second" : "seconds").localized(using: localizeService)
            timerLabel.text = "\(timing_update) \(time) " + "remain_to_resend".localized(using: localizeService)
        }
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
        setupAction()
        startTimer()
    }
    private func setupView(){
        OTPFields.fieldsCount = 6
        OTPFields.displayType = .roundedCorner
        OTPFields.defaultBorderColor = .borderColor
        OTPFields.filledBorderColor = .borderColor
        OTPFields.cursorColor = .PrimaryDarkColor
        OTPFields.fieldFont = .customFont(style: .regular, size: 16)
        OTPFields.shouldAllowIntermediateEditing = false
        
        let size = (OTPFields.frame.size.width / OTP_fieldCount) - 24
        print("size : \(size)")
        OTPFields.fieldSize = size
        OTPFields.separatorSpace = 18
        
        OTPFields.delegate = self
        OTPFields.initializeUI()
        
        errorLabel.isHidden = true
    }
    private func setupConstrainats(){
        
    }
    private func setupTheme(){
        titleLabel.titleColor = .TextPrimaryColor
        titleLabel.subTitleColor = .TextTeritaryColor
        timerLabel.textColor = .TextTeritaryColor
        resendBtn.setTitleColor(.PrimaryColor, for: .normal)
        resendBtn.setTitleColor(.TextTeritaryColor, for: .disabled)
    }
    internal override func setupLang(){
        super.setupLang()
        DispatchQueue.main.async { [weak self] in
            guard let self else{ return }
            titleLabel.seperatedText = "\n\n"
            titleLabel.titleText = "\t" + "enter_6_digit".localized(using: localizeService)
            titleLabel.subTitleText = "code_sent_to_num".localized(using: localizeService).replacingOccurrences(of: "[]", with: "+0123456789")
            let resend_codeText = "resend_code".localized(using: localizeService)
            resendBtn.setTitle(resend_codeText, for: .normal)
            resendBtn.setTitle(resend_codeText, for: .disabled)
            errorLabel.imageIndex = localizeService?.currentLanguage == .arabic ? 1 : 0
            
            view.updateTextAlignment(for: localizeService, isfromOTP: true)
//            OTPFields.updateTextAlignment(for: localizeService)
        }
    }
    private func setupFont(){
        titleLabel.titleFont = .customFont(style: .semiBold, size: 16)
        titleLabel.subTitleFont = .customFont(style: .regular, size: 14)
        timerLabel.font = .customFont(style: .regular, size: 14)
        resendBtn.titleLabel?.font = .customFont(style: .semiBold, size: 15)
    }
    private func navigationAction(){
        countTimer?.invalidate()
        countTimer = nil
        resendBtn.isEnabled = true
        isTimerRunning = false
        let dobController = DateofBirthController()
        navigationController?.pushToController(dobController, languageService: localizeService)
    }
    private func setupAction(){
        resendBtn.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    private func throwErrors(isError: Bool){
        if isError{
            errorLabel.isHidden = false
            errorLabel.ErrorText = "Verification code has expired or is incorrect"
        }else{
            errorLabel.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5){ [weak self] in
                self?.navigationAction()
            }
        }
    }
    deinit {
        countTimer = nil
        NotificationCenter.default.removeObserver(self)
    }
}
extension OTPVerificationController: OTPFieldViewDelegate{
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        print("OTP entered field : \(index)")
        return true
    }
    
    func enteredOTP(otp: String) {
        print("OTPString: \(otp)")
        let result = otp != "123456"// Bool.random()
        throwErrors(isError: result)
    }
    
    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        print("Has entered all OTP? \(hasEnteredAll)")
        return true
    }
}
extension OTPVerificationController{
    
    private func startTimer(){
        remainingSeconds = 50
        timing_update = remainingSeconds
        resendBtn.isEnabled = false
        isTimerRunning = true
        
        countTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    @objc private func updateTimer(){
        if remainingSeconds > 0{
            remainingSeconds -= 1
            timing_update = remainingSeconds
        }else{
            countTimer?.invalidate()
            countTimer = nil
            resendBtn.isEnabled = true
            isTimerRunning = false
        }
    }
    @objc func buttonAction(_ sender: UIButton){
        switch sender{
        case resendBtn:
            view.endEditing(true)
            addBottomView()
            startTimer()
        default: break
        }
    }
    @objc func applicationDidEnterBackground() {
        if isTimerRunning {
            lastPauseTime = Date()
            countTimer?.invalidate()
            countTimer = nil
        }
    }
    
    @objc func applicationWillEnterForeground() {
        if let lastPauseTime = lastPauseTime, isTimerRunning {
            let pauseDuration = Date().timeIntervalSince(lastPauseTime)
            remainingSeconds -= Int(pauseDuration)
            timing_update = remainingSeconds
            startResumeTimer()
        }
    }
    func startResumeTimer() {
        countTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
}

extension OTPVerificationController{
    
    private func addBottomView(){
        setupBottomActionView()
        setupKeyboardNotifications()
    }
    private func setupBottomActionView() {
        view.addSubview(bottomActionView)
        bottomActionView.alpha = 0
        bottomActionView.makeConstraints(top: nil, leading: nil, trailing: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor,edge: .init(top: 0, left: 0, bottom: 20, right: 0))
        bottomActionView.makeCenterConstraints(toView: view,centerY_axis: false)
        bottomActionView.cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        UIView.animate(withDuration: 1.5) { [weak self] in
            self?.bottomActionView.alpha = 1
        } completion: { [weak self] _ in
            self?.hideWithAnimation()
        }

    }
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        // Adjust the bottomActionView position above the keyboard
        let keyboardHeight = keyboardFrame.height
        bottomActionView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + 20)
    }
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        // Reset the position when the keyboard hides
        bottomActionView.transform = .identity
    }
    @objc private func cancelTapped() {
        hideWithAnimation()
    }
    private func hideWithAnimation() {
        NotificationCenter.default.removeObserver(self)
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.bottomActionView.alpha = 0
        }) { [weak self]_ in
            self?.bottomActionView.removeFromSuperview()
        }
    }

}
