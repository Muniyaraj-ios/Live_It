//
//  FollowCreatorController.swift
//  Live It
//
//  Created by Muniyaraj on 23/08/24.
//

import UIKit

final class FollowCreatorController: BaseController {
    
    private var followAllBtn: UIButton = UIButton()
    
    @IBOutlet weak var tabeleView: UITableView!
    
    @IBOutlet weak var nextSelectBtn: LoadingButton!
    @IBOutlet weak var skipBtn: DefaultButton!
    
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
        let barButtonItem = UIBarButtonItem(customView: followAllBtn)
        navigationItem.rightBarButtonItem = barButtonItem
        nextSelectBtn.buttonEnabled = true
    }
    private func setupConstrainats(){
    }
    private func setupTheme(){
        navigationController?.navigationBar.setColor(backgroundColor: .BackgroundColor)
        followAllBtn.setTitleColor(.PrimaryColor, for: .normal)
    }
    internal override func setupLang(){
        super.setupLang()
        DispatchQueue.main.async { [weak self] in
            guard let self else{ return }
            navigationItem.title = "follow_our_creator".localized(using: localizeService)
            followAllBtn.setTitle("follow_all".localized(using: localizeService), for: .normal)
            nextSelectBtn.enableTitle_Text = "next_select_interest".localized(using: localizeService)
            nextSelectBtn.disbleTitle_Text = "next_select_interest".localized(using: localizeService)
            skipBtn.title = "skip".localized(using: localizeService)
            
            view.updateTextAlignment(for: localizeService)
        }
    }
    private func setupFont(){
//        navigationController?.navigationBar.setTitleAttributes()
        followAllBtn.titleLabel?.font = .customFont(style: .semiBold, size: 16)
    }
    private func setupDelegate(){
        tabeleView.separatorStyle = .none
        tabeleView.register(FollowCreaterTableCell.nib, forCellReuseIdentifier: FollowCreaterTableCell.reuseIdentifier)
        tabeleView.delegate = self
        tabeleView.dataSource = self
        tabeleView.prefetchDataSource = self
        tabeleView.reloadData()
    }
    private func setupAction(){
        [followAllBtn,nextSelectBtn,skipBtn].forEach{
            $0?.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        }
    }
    @objc private func buttonAction(_ sender: UIButton){
        switch sender{
        case followAllBtn:
            break
        case nextSelectBtn:
            nextSelctionAction()
            break
        case skipBtn:
            followerProceedAction()
            break
        default: break
        }
    }
    private func nextSelctionAction(){
        nextSelectBtn.startLoading()
        DispatchQueue.main.asyncAfter(deadline: .now()+1){ [weak self] in
            self?.nextSelectBtn.stopLoading()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                self?.followerProceedAction()
            }
        }
    }
    private func followerProceedAction(){
        let pickInterestPage = PickCategoryController()
        navigationController?.pushToController(pickInterestPage, languageService: localizeService)
    }
}
extension FollowCreatorController: UITableViewDelegate,UITableViewDataSource,UITableViewDataSourcePrefetching{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FollowersDataModel.mockFollowers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowCreaterTableCell.reuseIdentifier, for: indexPath) as? FollowCreaterTableCell else{
            return UITableViewCell()
        }
        let data = FollowersDataModel.mockFollowers[indexPath.row]
        cell.setupConfigure(data,localizeService: localizeService)
        return cell
    }
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            print("Prefectching data : \(indexPath.row)")
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
class CustomCornerShadowView: BaseView {
    
    override func initalizeUI() {
        super.initalizeUI()
        setupView()
    }
    
    private func setupView() {
        // Set the corner radius for top-left and top-right corners
        layer.cornerRadius = 15
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = false

        // Add shadow
        layer.shadowColor = (UIColor.lightGray | UIColor.white).cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowRadius = 15
        
        // Optional: To have a crisp shadow, you can add a shadow path
        let shadowPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 15, height: 15))
        layer.shadowPath = shadowPath.cgPath
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
}

extension UINavigationBar {

    func setColor(backgroundColor: UIColor, color: UIColor = .TextPrimaryColor, font: UIFont = .customFont(style: .semiBold, size: 16), lineSpacing: CGFloat = 0, prefersLargeTitles: Bool = false) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // or use configureWithTransparentBackground() for transparent
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = NSAttributedString.createAttributes(font: font, color: color, lineSpacing: lineSpacing)
        //[.foregroundColor: titleColor]
        appearance.largeTitleTextAttributes = NSAttributedString.createAttributes(font: font, color: color, lineSpacing: lineSpacing)
        //[.foregroundColor: titleColor]

        // Apply the appearance to the navigation bar
        standardAppearance = appearance
        scrollEdgeAppearance = appearance
        compactAppearance = appearance
        self.prefersLargeTitles = prefersLargeTitles
    }
    func setTitleAttributes(font: UIFont = .customFont(style: .semiBold, size: 16), color: UIColor = .TextPrimaryColor, lineSpacing: CGFloat = 0){
        titleTextAttributes = NSAttributedString.createAttributes(font: font, color: color, lineSpacing: lineSpacing)
    }
}
