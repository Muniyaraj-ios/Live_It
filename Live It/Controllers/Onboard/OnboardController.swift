//
//  OnboardController.swift
//  Live It
//
//  Created by Muniyaraj on 20/08/24.
//

import UIKit

final class OnboardController: BaseController {
    
    @IBOutlet weak var loginBtn: AppButton!
    @IBOutlet weak var signupBtn: AttributedButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var onboard_data: [OnboardData] = OnboardData.mock_data
    
    var progressTimer: Timer?
    var currentIndex: Int = 0
    var currentProgress: CGFloat = 0.0
    let progressDuration: TimeInterval = 2.0

    override func viewDidLoad() {
        super.viewDidLoad()
        initalizeUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startProgress()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopProgress()
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
            self.loginBtn.title = "login".localized(using: localizeService)
            self.signupBtn.titleText = "dont_have_ac".localized(using: localizeService)
            self.signupBtn.subTitleText = "signup".localized(using: localizeService)
            
            self.previousBtn.setTitle("", for: .normal)
            self.nextBtn.setTitle("", for: .normal)
                        
            view.updateTextAlignment(for: localizeService)
            
            let attribute: UISemanticContentAttribute = localizeService?.currentLanguage == .arabic ? .forceRightToLeft : .forceLeftToRight
            nextBtn.semanticContentAttribute = attribute
            previousBtn.semanticContentAttribute = attribute
            
        }
    }
    private func setupFont(){
        
    }
    private func setupDelegate(){
        collectionView.isScrollEnabled = false
        collectionView.setCollectionViewLayout(setupLayout(), animated: true)
        collectionView.register(ProgressCollectCell.self, forCellWithReuseIdentifier: ProgressCollectCell.reuseIdentifier)
        collectionView.register(OnboardCollectionCell.self, forCellWithReuseIdentifier: OnboardCollectionCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    private func setupAction(){
        loginBtn.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        signupBtn.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
        previousBtn.addTarget(self, action: #selector(moveToPreviousIndex), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(moveToNextIndex), for: .touchUpInside)
    }
    @objc private func buttonAction(_ sender: UIButton){
        switch sender{
        case loginBtn:
            let tabbar = TabbarController()
            tabbar.localizeService = localizeService
            tabbar.selectedIndex = 4
            sceneDelegate?.setupNaigationController(UINavigationController(rootViewController: tabbar))
//            let loginPage = SignupController(pageType: .login)
//            navigationController?.pushToController(loginPage, languageService: localizeService)
        case signupBtn:
            let loginPage = SignupController(pageType: .signup)
            navigationController?.pushToController(loginPage, languageService: localizeService)
        default: break
        }
    }
}
extension OnboardController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func setupLayout()-> UICollectionViewCompositionalLayout{
        let layout = UICollectionViewCompositionalLayout{ [weak self] sectionIndex,_ in
            guard let self else { return nil }
            if sectionIndex == 0{
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(4)))
                item.contentInsets = .init(top: 0, leading: 6, bottom: 0, trailing: 6)
                let count = CGFloat(onboard_data.count)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1/count), heightDimension: .absolute(4)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                return section
            }else{
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.contentInsets = .init(top: 14, leading: 0, bottom: 0, trailing: 0)
                return section
            }
        }
        return layout
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboard_data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectCell.reuseIdentifier, for: indexPath) as? ProgressCollectCell else{ return UICollectionViewCell() }
            cell.setupConfigure(localizeService: localizeService)
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardCollectionCell.reuseIdentifier, for: indexPath) as? OnboardCollectionCell else{
                return UICollectionViewCell()
            }
            let onboard = onboard_data[indexPath.row]
            cell.setupConfigure(onboard, index: indexPath.item,localizeService: localizeService)
            return cell
        }
    }
}
extension OnboardController{
    func startProgress() {
        stopProgress()
        
        guard currentIndex < collectionView.numberOfItems(inSection: 0) else { return }
        
        currentProgress = 0.0
        
        if let currentCell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? ProgressCollectCell {
            currentCell.segmentedProgressView.setProgress(currentProgress)
        }
        
        let time_interval = (progressDuration / 100)
        progressTimer = Timer.scheduledTimer(timeInterval: time_interval, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    @objc func updateProgress() {
        guard currentIndex < collectionView.numberOfItems(inSection: 0) else {
            stopProgress()
            return
        }
        
        let time_interval = (progressDuration / 100)
        let prgress_increment = CGFloat(time_interval / progressDuration)
        currentProgress += prgress_increment
        
        if let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? ProgressCollectCell {
            cell.segmentedProgressView.setProgress(currentProgress)
        }
        if currentProgress >= 1.0 {
            moveToNextIndex()
        }
    }
    @objc func moveToNextIndex() {
        guard currentIndex < collectionView.numberOfItems(inSection: 0) - 1 else { return }
        stopProgress()
        
        if let currentCell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? ProgressCollectCell {
            currentCell.segmentedProgressView.setProgress(1.0)
        }
        
        currentIndex += 1
        collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 1), at: .centeredHorizontally, animated: true)
        startProgress()
    }
    
    @objc func moveToPreviousIndex() {
        stopProgress()
        
        guard currentIndex > 0 else {
            currentIndex = 0
            collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 1), at: .centeredHorizontally, animated: true)
            
            if let previousCell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? ProgressCollectCell {
                previousCell.segmentedProgressView.setProgress(0.001)
            }
            startProgress()
            return
        }
        
        if let currentCell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? ProgressCollectCell {
            currentCell.segmentedProgressView.setProgress(0.0)
        }
        
        currentIndex -= 1
        collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 1), at: .centeredHorizontally, animated: true)
        
        collectionView.layoutIfNeeded()
        
        if let previousCell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? ProgressCollectCell {
            previousCell.segmentedProgressView.setProgress(0.0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3){ [weak self] in
            guard let self else{ return }
            startProgress()
        }
    }
    
    func stopProgress() {
        progressTimer?.invalidate()
        progressTimer = nil
    }
}

struct OnboardData{
    let image: String = "body"
    let data: OnboardText
}
extension OnboardData{
    static var mock_data: [OnboardData] = [
        OnboardData(data: OnboardText(title: "spotlight_your_talent", subTitle: "grow_your_audience")),
        OnboardData(data: OnboardText(title: "start_instantly", subTitle: "no_minimum_audience")),
        OnboardData(data: OnboardText(title: "exclusive_access", subTitle: "getup_close_with_special")),
        OnboardData(data: OnboardText(title: "discover_new_trends", subTitle: "unique_creators_diverse_content")),
        OnboardData(data: OnboardText(title: "monetize_your_way", subTitle: "choose_how_you_earn"))
    ]
}
struct OnboardText{
    let title: String
    let subTitle: String
}
