//
//  PersonalizeProfileController.swift
//  Live It
//
//  Created by Muniyaraj on 23/08/24.
//

import UIKit

final class PersonalizeProfileController: BaseController {
    
    @IBOutlet weak var titleLabel: AttributedLabel!
    @IBOutlet weak var image_DescLabel: CustomizeLabel!
    
    @IBOutlet weak var profileIconView: ProfileImagePickerView!
    
    @IBOutlet weak var uploadButton: LoadingButton!
    @IBOutlet weak var laterBtn: DefaultButton!
    
    var profile_picked: ProfilePicked = .notpicked
    
    var vm: ImagePickerViewModel?

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
        setupFont()
        setupLang()
        setupDelegate()
        setupAction()
    }
    private func setupView(){
        image_DescLabel.titleAlignment = .center
        image_DescLabel.subTitleAlignment = .center
        uploadButton.buttonEnabled = true
        
    }
    private func setupTheme(){
        titleLabel.titleColor = .TextPrimaryColor
        titleLabel.subTitleColor = .TextTeritaryColor
        laterBtn.titleColor = .PrimaryColor
        
        image_DescLabel.titleColor = .TextPrimaryColor
        image_DescLabel.subTitleColor = .TextTeritaryColor
    }
    internal override func setupLang(){
        super.setupLang()
        DispatchQueue.main.async { [weak self] in
            guard let self else{ return }
            navigationItem.title = "personalize_profile".localized(using: localizeService)
            titleLabel.seperatedText = "\n\n"
            titleLabel.titleText = "\t" + "express_yourself".localized(using: localizeService)
            titleLabel.subTitleText = "connect_authentically".localized(using: localizeService)
            
            imageFetchChanges()
            
            view.updateTextAlignment(for: localizeService)
        }
    }
    private func imageFetchChanges(){
        switch profile_picked {
        case .picked:
            uploadButton.enableTitle_Text = "next_follow_creator".localized(using: localizeService)
            uploadButton.disbleTitle_Text = "next_follow_creator".localized(using: localizeService)
            laterBtn.title = "upload_another_pic".localized(using: localizeService)
            
            image_DescLabel.isHidden = false
            image_DescLabel.titleText = "fantastic".localized(using: localizeService)
            image_DescLabel.subTitleText = "all_set_continue".localized(using: localizeService).replacingOccurrences(of: "[]", with: "Isabella!")
            break
        case .notpicked:
            uploadButton.enableTitle_Text = "upload_picture".localized(using: localizeService)
            laterBtn.title = "later".localized(using: localizeService)
            
            image_DescLabel.isHidden = true
            break
        }
    }
    private func setupFont(){
        setNavigationBarTitleAttributes()
        titleLabel.titleFont = .customFont(style: .semiBold, size: 16)
        titleLabel.subTitleFont = .customFont(style: .regular, size: 14)
        laterBtn.titleFont = .customFont(style: .semiBold, size: 16)
        
        image_DescLabel.titleFont = .customFont(style: .semiBold, size: 24)
        image_DescLabel.subTitleFont = .customFont(style: .regular, size: 14)
    }
    private func setupDelegate(){
        
    }
    private func setupAction(){
        uploadButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        laterBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    private func profileUpload(){
        uploadButton.startLoading()
        DispatchQueue.main.asyncAfter(deadline: .now()+1){ [weak self] in
            self?.uploadButton.stopLoading()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                self?.profileProceedAction()
            }
        }
    }
    private func profileProceedAction(){
        let followersPage = FollowCreatorController()
        navigationController?.pushToController(followersPage, languageService: localizeService)
    }
    @objc private func buttonAction(_ sender: UIButton){
        switch sender{
            case uploadButton:
                uploadButtonAction()
                break
            case laterBtn:
                laterButtonAction()
                break
            default: break
        }
    }
    private func uploadButtonAction(){
        switch profile_picked {
        case .picked:
            // upload to to server and move on
            profileUpload()
             break
        case .notpicked:
            presentGalleryAction()
            break
        }
    }
    private func laterButtonAction(){
        switch profile_picked {
        case .picked:
            presentGalleryAction()
             break
        case .notpicked:
            profileProceedAction() // for skip
            break
        }
    }
    private func presentGalleryAction(){
        let gallery = GalleryViewController()
        gallery.dismissImagePickerClosure = { [weak self] image in
            self?.imageFetchedGallery(image: image)
        }
        gallery.localizeService = localizeService
        
        let navController = UINavigationController(rootViewController: gallery)
        if #available(iOS 15.0, *) {
            navController.sheetPresentationController?.detents = [.large()]
            navController.sheetPresentationController?.prefersGrabberVisible = true
            navController.sheetPresentationController?.preferredCornerRadius = 20
            navController.sheetPresentationController?.prefersScrollingExpandsWhenScrolledToEdge = false
        } else {
            navController.modalPresentationStyle = .formSheet
        }
        //present(navController, animated: true)
        presentToController(navController, languageService: localizeService)
        
//        vm = ImagePickerViewModel(viewController: self)
//        vm?.requestPhotoLibraryPermission()
//        vm?.dismissImagePickerClosure = { [weak self] image in
//            self?.imageFetchedGallery(image: image)
//        }
    }
    private func imageFetchedGallery(image icon: UIImage){
        profileIconView.picture = icon
        profile_picked = .picked
        //imageFetchedLang()
        imageFetchChanges()
    }
}


enum ProfilePicked{
    case picked
    case notpicked
}
