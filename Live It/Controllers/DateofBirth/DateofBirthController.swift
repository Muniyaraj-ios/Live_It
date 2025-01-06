//
//  DateofBirthController.swift
//  Live It
//
//  Created by Muniyaraj on 21/08/24.
//

import UIKit

final class DateofBirthController: BaseController {
    
    @IBOutlet weak var dateOfBirthView : DateofBirthView!
    
    internal var userDOB: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        initalizeUI()
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
        
    }
    private func setupConstrainats(){
        
    }
    private func setupTheme(){
        
    }
    internal override func setupLang(){
        super.setupLang()
        DispatchQueue.main.async { [weak self] in
            guard let self else{ return }
            navigationItem.title = "confirm_birthday".localized(using: localizeService)
            dateOfBirthView.TitleText = "date_of_birth".localized(using: localizeService)
            dateOfBirthView.errorText = "you_must_18_or_older".localized(using: localizeService)
            dateOfBirthView.SubTitleText = "by_verify_age".localized(using: localizeService)
            
            view.updateTextAlignment(for: localizeService)
        }
    }
    private func setupFont(){
        let attributes = NSAttributedString.createAttributes(font: .customFont(style: .semiBold, size: 16), color: .TextPrimaryColor, lineSpacing: 0)
        setNavigationBarTitleAttributes(attributes)
    }
    private func setupDelegate(){
        dateOfBirthView.textField.delegate = self
    }
    private func setupAction(){
        
    }
}
extension DateofBirthController: DobSelectedDate{
    func selecteDOBOption(){
        let selectionPage = DobSelectionController()
        if #available(iOS 15.0, *) {
            selectionPage.sheetPresentationController?.detents = [.medium()]
            selectionPage.sheetPresentationController?.prefersGrabberVisible = true
            selectionPage.sheetPresentationController?.preferredCornerRadius = 20
            selectionPage.sheetPresentationController?.prefersScrollingExpandsWhenScrolledToEdge = false
        } else {
            selectionPage.modalPresentationStyle = .formSheet
        }
        selectionPage.delegate = self
        selectionPage.selectedDate = userDOB
        navigationController?.presentToController(selectionPage, animated: true, languageService: localizeService)
    }
    func shouldVisbleDate(selected date: Date, isError: Bool) {
        userDOB = date
        dateOfBirthView.throwError = isError
        dateOfBirthView.textField.text = DateFormat.dayMonthYear.format(date: date)
    }
    func confirmedDateSelection(selected date: Date?) {
        UIAlertController.showCustomAlert(on: self, title: "confirm_dob".localized(using: localizeService), message: "confirm_dob_alert_msg".localized(using: localizeService), continueTitle: "continue".localized(using: localizeService), cancelTitle: "cancel".localized(using: localizeService)) { [weak self] in
            self?.createVerificationPageWithData(date: date)
        } cancelHandler: { [weak self] in
            self?.createVerificationPageWithData(date: nil)
        }
    }
    private func createVerificationPageWithData(date: Date?){
        let creatorPage = CreatorVerificationPage(category: AgeCategory.categorize(birthDate: date))
        navigationController?.pushToController(creatorPage, languageService: localizeService)
    }
}
extension DateofBirthController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        selecteDOBOption()
    }
}
