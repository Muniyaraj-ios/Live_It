//
//  FilloutProfileController.swift
//  Live It
//
//  Created by Muniyaraj on 06/09/24.
//

import UIKit

final class FilloutProfileController: BaseController {

    @IBOutlet weak var filloutIcon: UIImageView!
    @IBOutlet weak var titleTextLabel: AttributedLabel!
    
    @IBOutlet weak var filloutBtn: LoadingButton!
    @IBOutlet weak var skipBtn: DefaultButton!
    
    weak var profileFilldelegate: FillProfileAction?
    
    let popupAsk: ProfileOptionAsk
    
    init(pageType: ProfileOptionAsk) {
        popupAsk = pageType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        titleTextLabel.alignment = .center
        filloutBtn.buttonEnabled = true
        filloutIcon.image = UIImage(named: popupAsk.feedText.icon)
    }
    private func setupConstrainats(){
        
    }
    private func setupTheme(){
        
    }
    internal override func setupLang(){
        super.setupLang()
        DispatchQueue.main.async{ [weak self] in
            guard let self else{ return }
            filloutBtn.enableTitle_Text = popupAsk.feedText.primary_enable_text
            filloutBtn.disbleTitle_Text = popupAsk.feedText.primary_disable_text
            
            titleTextLabel.titleText = popupAsk.feedText.titleText
            titleTextLabel.subTitleText = popupAsk.feedText.sub_titleText
            
            skipBtn.title = popupAsk.feedText.skip_text
        }
    }
    private func setupFont(){
        titleTextLabel.titleFont = .customFont(style: .semiBold, size: 20)
        titleTextLabel.subTitleFont = .customFont(style: .regular, size: 14)
    }
    private func setupDelegate(){
        
    }
    private func setupAction(){
        filloutBtn.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        skipBtn.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    @objc private func buttonAction(_ sender: UIButton){
        switch sender{
        case filloutBtn:
            fillDetilsAction()
            break
        case skipBtn:
            skipAction()
            break
        default: break
        }
    }
    private func fillDetilsAction(){
        filloutBtn.startLoading()
        DispatchQueue.main.asyncAfter(deadline: .now()+1){ [weak self] in
            self?.filloutBtn.stopLoading()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                self?.dismiss(animated: true){ [weak self] in
                    self?.profileFilldelegate?.doFillProfile()
                }
                
            }
        }
    }
    private func skipAction(){
        dismiss(animated: true){ [weak self] in
            self?.profileFilldelegate?.skipFillProfile()
        }
    }
}

protocol FillProfileAction: AnyObject{
    func doFillProfile()
    func skipFillProfile()
}


enum ProfileOptionAsk{
    case fill_out_profile
    case go_live_now
    
    var feedText: PopupAskData{
        switch self {
        case .fill_out_profile:
            return .init(titleText: "Fill out your profile", sub_titleText: "Help your audience get to know you with a bio that shares your story and what makes you unique!", primary_enable_text: "Fill out your profile", primary_disable_text: "Fill out your profile", skip_text: "Skip for now", icon: "fillout_profile")
        case .go_live_now:
            return .init(titleText: "Go live now and start building your community!", sub_titleText: "It is a great moment to start sharing your creativity with others!", primary_enable_text: "Go live", primary_disable_text: "Go live", skip_text: "Not now", icon: "go_live_popup")
        }
    }
}

struct PopupAskData{
    let titleText: String
    let sub_titleText: String
    let primary_enable_text: String
    let primary_disable_text: String
    let skip_text: String
    let icon: String
}

