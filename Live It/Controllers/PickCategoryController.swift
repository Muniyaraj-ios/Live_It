//
//  PickCategoryController.swift
//  Live It
//
//  Created by Muniyaraj on 24/08/24.
//

import UIKit

final class PickCategoryController: BaseController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextFillOutProfieBtn: LoadingButton!
    
    
    var sectionData: [CategorySectionData] = IntersetsType.allCases.map{ CategorySectionData(type: $0, isLoadAll: $0 != .most_popular_interest, data: $0.getChildValue)}
    
    var selectedIndex: [IndexPath]?{
        didSet{
            nextFillOutProfieBtn.buttonEnabled = (selectedIndex?.count ?? 0) > 0
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
        setupDelegate()
        setupAction()
    }
    private func setupView(){
        nextFillOutProfieBtn.buttonEnabled = (selectedIndex?.count ?? 0) > 0
    }
    private func setupConstrainats(){
        
    }
    private func setupTheme(){
        
    }
    internal override func setupLang(){
        super.setupLang()
        DispatchQueue.main.async { [weak self] in
            guard let self else{ return }
            navigationItem.title = "pick_categories_interest".localized(using: localizeService)
            nextFillOutProfieBtn.enableTitle_Text = "next_fill_profile".localized(using: localizeService)
            nextFillOutProfieBtn.disbleTitle_Text = "next_fill_profile".localized(using: localizeService)
            
            //collectionView.collectionViewLayout.collectionView?.semanticContentAttribute = localizeService?.currentLanguage == .arabic ? .forceRightToLeft : .forceLeftToRight
            view.updateTextAlignment(for: localizeService)
            debugPrint("Language : \(localizeService?.currentLanguage.rawValue ?? "l")")
            collectionView.setCollectionViewLayout(createLayout(), animated: true)
            collectionView.reloadData()
        }
    }
    private func setupFont(){
        navigationController?.navigationBar.setTitleAttributes()
    }
    private func setupDelegate(){
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(PickInterestCollectionCell.self, forCellWithReuseIdentifier: PickInterestCollectionCell.reuseIdentifier)
        collectionView.register(DynamicHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DynamicHeaderView.reuseIdentifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        collectionView.register(SeeMoreFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SeeMoreFooterView.reuseIdentifier)
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self

    }
//    struct Followers: Codable{
//        let id: Int64?
//        let avatar_url: String?
//        let login: String?
//    }
    private func setupAction(){
        nextFillOutProfieBtn.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    @objc private func buttonAction(_ sender: UIButton){
        switch sender{
            case nextFillOutProfieBtn:
                nextFillBtnAction()
                break
            default: break
        }
    }
    private func nextFillBtnAction(){
        nextFillOutProfieBtn.startLoading()
        DispatchQueue.main.asyncAfter(deadline: .now()+1){ [weak self] in
            self?.nextFillOutProfieBtn.stopLoading()
            
            guard let self = self else{ return }
            let selectedInterests = sectionData
                .flatMap{ $0.data }
                .filter{ $0.isChoosed }
                .compactMap{ $0.image }
            debugPrint("selectedInterests : \(selectedInterests)")
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){ [weak self] in
            self?.setupNavigation()
        }
    }
    private func setupNavigation(){
        /*if localizeService?.currentLanguage == .arabic{
            localizeService?.currentLanguage = .english
            debugPrint("Language chagned to English")
        }else if localizeService?.currentLanguage == .english{
            localizeService?.currentLanguage = .arabic
            debugPrint("Language chagned to Arabic")
        }
        return*/
        
        let tabbarController = TabbarController()
        tabbarController.selectedIndex = 4
        tabbarController.localizeService = localizeService
        sceneDelegate?.setupNaigationController(UINavigationController(rootViewController: tabbarController))
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self else{ return nil }
            
            let Section = self.sectionData[sectionIndex]
            switch Section.type{
            case .header:
                
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(1))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 15)
                
                
                // Header size based on content size
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                header.contentInsets = .init(top: 0, leading: 2, bottom: 0, trailing: 2)
                section.boundarySupplementaryItems = [header]
                
                return section
            case .most_popular_interest,.all_interest:
                
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(120), heightDimension: .estimated(50)))
                
                let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 15, bottom: 10, trailing: 15)
                
                // Header size based on content size
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                header.contentInsets = .init(top: 0, leading: 2, bottom: 0, trailing: 2)
                
                let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60))
                let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
                footer.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 15)
                
                let isMostPopular = Section.type == .most_popular_interest
                section.boundarySupplementaryItems = isMostPopular ? [header, footer] : [header]
                
                return section
            }
        }
        return layout
    }

}
extension PickCategoryController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionData.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let loadItem_ = sectionData[section].isLoadAll ? sectionData[section].data.count : min(5, sectionData[section].data.count)
        return sectionData[section].isExpand ? loadItem_ : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sectionData[indexPath.section]
        switch section.type{
        case .header:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            return cell
        case .most_popular_interest,.all_interest:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PickInterestCollectionCell.reuseIdentifier, for: indexPath) as? PickInterestCollectionCell else{ return UICollectionViewCell() }
            cell.setupConfigure(section.data[indexPath.row], localizeService: localizeService)
            
            cell.addTap { [weak self] in
                self?.sectionData[indexPath.section].data[indexPath.row].isChoosed.toggle()
                if let _ = self?.selectedIndex{
                    if self?.sectionData[indexPath.section].data[indexPath.row].isChoosed ?? false{
                        self?.selectedIndex?.append(indexPath)
                    }else{
                        self?.selectedIndex?.removeAll{ $0 == indexPath }
                    }
                }else{
                    self?.selectedIndex = [indexPath]
                }
                collectionView.reloadItems(at: [indexPath])
            }
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = sectionData[indexPath.section]
        switch kind{
            case UICollectionView.elementKindSectionHeader:
            switch section.type{
                case .header:
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DynamicHeaderView.reuseIdentifier, for: indexPath) as! DynamicHeaderView
                    headerView.setupConfigure(localizeService: localizeService)
                    return headerView
                case .most_popular_interest,.all_interest:
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
                    headerView.setupConfigure(section.type, isExpand: section.isExpand)
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHeaderTag(_:)))
                    headerView.tag = indexPath.section
                    headerView.addGestureRecognizer(tapGesture)
                    return headerView
            }
            
        case UICollectionView.elementKindSectionFooter:
            switch section.type{
                case .header: return UICollectionReusableView()
                case .most_popular_interest:
                    let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SeeMoreFooterView.reuseIdentifier, for: indexPath) as! SeeMoreFooterView
                    footerView.setupConfigure(section.isLoadAll,localizeService: localizeService)
                    footerView.seeMoreBtn.tag = indexPath.section
                    footerView.seeMoreBtn.addTarget(self, action: #selector(handleSeeOption), for: .touchUpInside)
                    return footerView
                case .all_interest: return UICollectionReusableView()
            }
            default: return UICollectionReusableView()
        }
    }
    @objc private func handleHeaderTag(_ gesture: UITapGestureRecognizer){
        guard let section = gesture.view?.tag else { return }
        sectionData[section].isExpand.toggle()
        collectionView.reloadSections(IndexSet(integer: section))
    }
    @objc private func handleSeeOption(_ sender: UIButton){
        let section = sender.tag
        sectionData[section].isLoadAll.toggle()
        collectionView.reloadSections(IndexSet(integer: section))
    }
}

enum IntersetsType: CaseIterable{
    case header
    case most_popular_interest
    case all_interest
    
    var title: String{
        switch self {
        case .header: return ""
        case .most_popular_interest: return "Most Popular"
        case .all_interest: return "All"
        }
    }
    
    var getChildValue: [CategoryChildData]{
        switch self {
        case .header:
            return []
        case .most_popular_interest:
            return [
                CategoryChildData(image: "Art and creativity", name: ""),
                CategoryChildData(image: "Beauty", name: ""),
                CategoryChildData(image: "Entertainment", name: ""),
                CategoryChildData(image: "Gaming", name: ""),
                CategoryChildData(image: "Health and fitness", name: ""),
                CategoryChildData(image: "Just chatting", name: ""),
                CategoryChildData(image: "Lifestyle", name: ""),
                CategoryChildData(image: "Technology", name: ""),
            ]
        case .all_interest:
            return [
                CategoryChildData(image: "Animals & pets", name: ""),
                CategoryChildData(image: "Art & creative", name: ""),
                CategoryChildData(image: "Beauty", name: ""),
                CategoryChildData(image: "Business & money", name: ""),
                CategoryChildData(image: "Dating & relationship", name: ""),
                CategoryChildData(image: "DIY & home improvements", name: ""),
                CategoryChildData(image: "Education", name: ""),
                CategoryChildData(image: "Entertainment", name: ""),
            ]
        }
    }
}

struct CategorySectionData{
    let type: IntersetsType
    var isExpand: Bool = true
    var isLoadAll: Bool
    var data: [CategoryChildData]
}

extension CategorySectionData{
    static var mockData: [CategorySectionData] = IntersetsType.allCases.map{ CategorySectionData(type: $0, isLoadAll: $0 != .most_popular_interest, data: $0.getChildValue)}
}

struct CategoryChildData{
    let image: String
    let name: String
    var isChoosed: Bool = false
}
