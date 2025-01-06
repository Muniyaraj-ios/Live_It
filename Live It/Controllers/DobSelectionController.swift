//
//  DobSelectionController.swift
//  Live It
//
//  Created by Muniyaraj on 22/08/24.
//

import UIKit

final class DobSelectionController: BaseController {
    
    @IBOutlet weak var dateBGView: UIView!
    @IBOutlet weak var verifyBgView: UIView!
    
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var continueBtn: LoadingButton!
    
    @IBOutlet weak var greetingIcon: UIImageView!
    @IBOutlet weak var confirmLabel: UILabel!
    @IBOutlet weak var selectedDateBtn: PaddedButton!
    
    @IBOutlet weak var proceedBtn: AppButton!
    @IBOutlet weak var makeChangesBtn: UIButton!
    
    weak var delegate: DobSelectedDate?
    
     internal var selectedDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
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
        let calender = Calendar.current
        let minimumDateComponents = DateComponents(year: 1970, month: 1, day: 1)
        let minimumDate = calender.date(from: minimumDateComponents)!
        
        datePickerView.minimumDate = minimumDate
        datePickerView.maximumDate = Date()
        datePickerView.datePickerMode = .date
        datePickerView.preferredDatePickerStyle = .wheels
        datePickerView.setDate(selectedDate ?? Date(), animated: true)
        if let _ = selectedDate{
            datePickerChanges(datePickerView)
        }
        
        greetingIcon.image = UIImage(named: "flowers")
        selectedDateBtn.layer.cornerRadius = 6
    }
    private func setupConfirmView(select date: Date){
        selectedDateBtn.setTitle(DateFormat.dayMonthYear.format(date: date), for: .normal)
    }
    private func setupConstrainats(){
        
    }
    private func setupTheme(){
        confirmLabel.textColor = .TextPrimaryColor
        selectedDateBtn.setTitleColor(.TextPrimaryColor, for: .normal)
        makeChangesBtn.setTitleColor(.PrimaryColor, for: .normal)
        selectedDateBtn.backgroundColor = .surface_SecondaryColor
    }
    internal override func setupLang(){
        super.setupLang()
        DispatchQueue.main.async { [weak self] in
            guard let self else{ return }
            let continueText = "continue".localized(using: localizeService)
            continueBtn.enableTitle_Text = continueText
            continueBtn.disbleTitle_Text = continueText
            confirmLabel.text = "confirm_dob".localized(using: localizeService)
            proceedBtn.title = "yes_its_correct".localized(using: localizeService)
            makeChangesBtn.setTitle("need_make_changes".localized(using: localizeService), for: .normal)
            
            let localeCode = localizeService?.currentLanguage.localeCode ?? DefaultLocalizationService().currentLanguage.localeCode
            datePickerView.locale = Locale(identifier: localeCode)
            
            view.updateTextAlignment(for: localizeService)
        }
    }
    private func setupFont(){
        confirmLabel.font = .customFont(style: .medium, size: 26)
        selectedDateBtn.titleLabel?.font = .customFont(style: .medium, size: 28)
        makeChangesBtn.titleLabel?.font = .customFont(style: .medium, size: 16)
    }
    private func setupDelegate(){
        
    }
    private func setupAction(){
        [continueBtn,makeChangesBtn,proceedBtn].forEach{
            $0?.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        }
        datePickerView.addTarget(self, action: #selector(datePickerChanges(_:)), for: .valueChanged)
        datePickerView.addTarget(self, action: #selector(datePickerChanges(_:)), for: .valueChanged)
    }
    
    @objc private func buttonAction(_ sender: UIButton){
        switch sender{
        case continueBtn:
            continueButtonAction()
            break
        case makeChangesBtn:
            didTapBack()
            break
        case proceedBtn:
            proceeedAction()
            break
        default: break
        }
    }
    @objc func datePickerChanges(_ sender: UIDatePicker){
        let selectedDate_ = sender.date
        
        let minDate = Calendar.current.date(byAdding: .year, value: -13, to: Date())
        if let minDate{
            let verified_age = selectedDate_ <= minDate
            selectedDate = selectedDate_
            delegate?.shouldVisbleDate(selected: selectedDate_, isError: !verified_age)
            continueBtn.buttonEnabled = verified_age
        }
    }
    private func continueButtonAction(){
        if let selectedDate{
            setupConfirmView(select: selectedDate)
        }
        continueBtn.startLoading()

        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){ [weak self] in
            self?.continueBtn.stopLoading()
            self?.didTapContinue()
        }
    }
    @objc private func proceeedAction() {
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.confirmedDateSelection(selected: self?.selectedDate)
        }
    }
//    @objc private func didTapContinue() {
//        verifyBgView.isHidden = false
//        verifyBgView.frame = CGRect(x: view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
//        
//        UIView.animate(withDuration: 0.6, animations: {
//            self.dateBGView.frame = CGRect(x: -self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
//            self.verifyBgView.frame = self.view.bounds
//        }) { [weak self] _ in
//            self?.dateBGView.isHidden = true
//        }
//    }
    
//    @objc private func didTapBack() {
//        dateBGView.isHidden = false
//        dateBGView.frame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
//        
//        UIView.animate(withDuration: 0.6, animations: {
//            self.dateBGView.frame = self.view.bounds
//            self.verifyBgView.frame = CGRect(x: self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
//        }) { _ in
//            self.verifyBgView.isHidden = true
//        }
//    }
}

extension DobSelectionController{
    @objc private func didTapContinue() {
        verifyBgView.alpha = 1
        verifyBgView.isHidden = false
        verifyBgView.frame = CGRect(x: view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        dateBGView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
            guard let self else{ return }
            dateBGView.frame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
            verifyBgView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        }, completion: {  [weak self] _ in
            guard let self else{ return }
            dateBGView.isHidden = true
        })
    }

    @objc private func didTapBack() {
        dateBGView.alpha = 1
        dateBGView.isHidden = false
        dateBGView.frame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        verifyBgView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
            guard let self else{ return }
            dateBGView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
            verifyBgView.frame = CGRect(x: view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        }, completion: { [weak self] _ in
            guard let self else{ return }
            verifyBgView.isHidden = true
        })
    }

}

protocol DobSelectedDate: AnyObject{
    func shouldVisbleDate(selected date: Date,isError: Bool)
    func confirmedDateSelection(selected date: Date?)
}
