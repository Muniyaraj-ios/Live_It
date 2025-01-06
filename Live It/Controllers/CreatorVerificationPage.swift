//
//  CreatorVerificationPage.swift
//  Live It
//
//  Created by Muniyaraj on 22/08/24.
//

import UIKit

final class CreatorVerificationPage: BaseController {

    @IBOutlet weak var creatorIcon: UIImageView!
    @IBOutlet weak var titleLabel: CustomizeLabel!
    
    @IBOutlet weak var contineBtn: AppButton!
    
    var category: AgeCategory
    
    init(category: AgeCategory){
        self.category = category
        super.init(nibName: "CreatorVerificationPage", bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initalizeUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func initalizeUI(){
        setupView()
        setupTheme()
        setupFont()
        setupLang()
        setupDelegate()
        setupAction()
    }
    private func setupView(){
        creatorIcon.image = UIImage(named: category.catgoryInfo.imageName)
        
        titleLabel.titleAlignment = .center
        titleLabel.subTitleAlignment = .center
        titleLabel.separeatedString = "\n\n"
        
        contineBtn.isHidden = category == .under14
    }
    private func setupConstrainats(){
        
    }
    private func setupTheme(){
        titleLabel.titleColor = .TextPrimaryColor
        titleLabel.subTitleColor = .TextTeritaryColor
    }
    internal override func setupLang(){
        super.setupLang()
        DispatchQueue.main.async { [weak self] in
            guard let self else{ return }
            titleLabel.titleText = category.catgoryInfo.titleText.localized(using: localizeService).replacingOccurrences(of: "[]", with: "Isabella")
            titleLabel.subTitleText = category.catgoryInfo.subTitleText.localized(using: localizeService)
            contineBtn.title = "continue".localized(using: localizeService)
            
            view.updateTextAlignment(for: localizeService)
        }
    }
    private func setupFont(){
        titleLabel.titleFont = .customFont(style: .semiBold, size: 24)
        titleLabel.subTitleFont = .customFont(style: .regular, size: 14)
    }
    private func setupDelegate(){
        
    }
    private func setupAction(){
        contineBtn.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    @objc private func buttonAction(_ sender: UIButton){
        switch sender{
        case contineBtn:
            continueWithNavigation()
            break
            default: break
        }
    }
    private func continueWithNavigation(){
        let personalInfo = AddPersonalInfoController(personalInfo: .firstname)
        navigationController?.pushToController(personalInfo, languageService: localizeService)
    }
}


enum AgeCategory{
    case under14
    case between13and18
    case over18
    case unverified
    
    static func categorize(birthDate: Date?)-> AgeCategory{
        let calender = Calendar.current
        guard let birthDate else{ return .unverified }
        let ageComponents = calender.dateComponents([.year], from: birthDate, to: Date())
        guard let age = ageComponents.year else{ return .unverified}
        
        switch age{
        case ..<14: return .under14
        case 13...18: return .between13and18
        case 18...: return .over18
        default: return .unverified
        }
    }
    var catgoryInfo: CategoryTypeDate{
        switch self {
        case .under14:
            return CategoryTypeDate(imageName: "consumer_under14", titleText: "access_denied", subTitleText: "our_community_guideliness")
        case .between13and18:
            return CategoryTypeDate(imageName: "consumer_under13_18", titleText: "greeting_message", subTitleText: "thanks_for_join_us")
        case .over18:
            return CategoryTypeDate(imageName: "creator_verify", titleText: "welcome_user", subTitleText: "congrats_verified_creator")
        case .unverified:
            return CategoryTypeDate(imageName: "creator_unverify", titleText: "welcome_user", subTitleText: "congrats_parts_of_community")
        }
    }
}

struct CategoryTypeDate{
    let imageName: String
    let titleText: String
    let subTitleText: String
}
