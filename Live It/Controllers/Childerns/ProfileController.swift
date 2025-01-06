//
//  ProfileController.swift
//  Live It
//
//  Created by Muniyaraj on 05/09/24.
//

import Toaster
import UIKit

final class ProfileController: BaseController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(ProfileHeaderView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderView.reuseIdentifier)
        collection.register(ProfileListCell.nib, forCellWithReuseIdentifier: ProfileListCell.reuseIdentifier)
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    private var fillProfilePopUP: Bool = false

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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkCompleteProfile()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstrainats()
    }
    private func setupView(){
        view.addSubview(collectionView)
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 45, right: 0)
    }
    private func setupConstrainats(){
        collectionView.makeConstraints(toView: view,edge: .zero, isSafeArea: true)
    }
    private func setupTheme(){
        navigationController?.navigationBar.setColor(backgroundColor: .TextColor)
    }
    internal override func setupLang(){
        super.setupLang()
        DispatchQueue.main.async { [weak self] in
            guard let self else{ return }
            navigationItem.title = "Fill out profile"
            
            view.updateTextAlignment(for: localizeService)
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: collectionView.frame.size.width, height: 60)
            collectionView.setCollectionViewLayout(layout, animated: true)
            collectionView.reloadData()
        }
    }
    private func setupFont(){
        navigationController?.navigationBar.setTitleAttributes()
    }
    private func setupDelegate(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    private func setupAction(){
        
    }
}
extension ProfileController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserProfileMenu.options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileListCell.reuseIdentifier, for: indexPath) as? ProfileListCell else{ return UICollectionViewCell() }
        let option = UserProfileMenu.options[indexPath.item]
        cell.setupConfigure(option,localizationService: localizeService)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind{
            case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderView.reuseIdentifier, for: indexPath) as? ProfileHeaderView else{ return UICollectionReusableView() }
            headerView.setupConfigure(localizeService: localizeService)
            return headerView
            case UICollectionView.elementKindSectionFooter:
                return UICollectionReusableView()
            default: return UICollectionReusableView()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 210)
    }
}

extension ProfileController: FillProfileAction{
    func checkCompleteProfile(){
        guard !fillProfilePopUP else { return }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4){ [weak self] in
            self?.showFillOutpPopup()
        }
    }
    func doFillProfile() {
        fillProfilePopUP.toggle()
    }
    
    func skipFillProfile() {
        fillProfilePopUP.toggle()
    }
    
    func showFillOutpPopup(){
        let selectionPage = FilloutProfileController(pageType: .fill_out_profile)
        if #available(iOS 15.0, *) {
            selectionPage.sheetPresentationController?.detents = [.medium()]
            selectionPage.sheetPresentationController?.prefersGrabberVisible = true
            selectionPage.sheetPresentationController?.preferredCornerRadius = 20
            selectionPage.sheetPresentationController?.prefersScrollingExpandsWhenScrolledToEdge = false
        } else {
            selectionPage.modalPresentationStyle = .formSheet
        }
        selectionPage.profileFilldelegate = self
        tabBarController?.navigationController?.presentToController(selectionPage, languageService: localizeService)
    }
}

struct UserProfileMenu{
    var name: String
    var description: String
}
extension UserProfileMenu{
    static let options: [UserProfileMenu] = [
        .init(name: "First Name", description: "Isabella"),
        .init(name: "Last Name", description: "Hansley"),
        .init(name: "Username", description: "isabellahansley"),
        .init(name: "Bio", description: "Add a bio"),
        .init(name: "Links", description: "Add a links"),
        .init(name: "Gender", description: "Gender"),
        .init(name: "Category", description: "6 Categories selected"),
    ]
}
