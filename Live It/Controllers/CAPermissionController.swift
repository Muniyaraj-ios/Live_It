//
//  CAPermissionController.swift
//  Live It
//
//  Created by Muniyaraj on 26/09/24.
//

import UIKit

final class CAPermissionController: BaseController {
    
    @IBOutlet weak var PermissionIcon: UIImageView!
    @IBOutlet weak var permissionTable: UITableView!
    @IBOutlet weak var openSettingsBtn: LoadingButton!
    
    let cameraVM: CameraViewModel
    
    init(viewModel: CameraViewModel) {
        self.cameraVM = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initalizeUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isModalInPresentation = true // disble dismiss manually
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
        PermissionIcon.image = UIImage(named: "permission_lock_icon")
        openSettingsBtn.buttonEnabled = true
    }
    private func setupConstrainats(){
        
    }
    private func setupTheme(){
        
    }
    override internal func setupLang(){
        DispatchQueue.main.async { [weak self] in
            guard let self else{ return }
            openSettingsBtn.enableTitle_Text = "Open settings"
            openSettingsBtn.disbleTitle_Text = "Open settings"
        }
    }
    private func setupFont(){
        
    }
    private func setupDelegate(){
        permissionTable.register(CAAlertTableViewCell.self, forCellReuseIdentifier: CAAlertTableViewCell.reuseIdentifier)
        permissionTable.delegate = self
        permissionTable.dataSource = self
        permissionTable.reloadData()
    }
    private func setupAction(){
        openSettingsBtn.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    @objc private func buttonAction(_ sender: UIButton){
        switch sender{
        case openSettingsBtn:
            openAppSettings()
            break
            default: break
        }
    }
    private func openAppSettings() {
        openSettingsBtn.startLoading()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3){ [weak self] in
            self?.openSettingsBtn.stopLoading()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        }
        
    }
}

extension CAPermissionController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        PermisssionData.values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CAAlertTableViewCell.reuseIdentifier, for: indexPath) as! CAAlertTableViewCell
        cell.setupConfigure(PermisssionData.values[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .ButtonTextColor

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Let \(Constant.appName) access your camera and microphone"
        label.font = .customFont(style: .semiBold, size: 20)
        label.numberOfLines = 0
        label.textColor = .TextPrimaryColor
        label.textAlignment = .center

        headerView.addSubview(label)
        label.makeConstraints(toView: headerView,edge: .init(top: 12, left: 12, bottom: 16, right: 12))

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("didSelect called ")
    }
    
}


final class CAAlertTableViewCell: UITableViewCell, StoryboardCell{
    
    var icon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .TextPrimaryColor
        label.numberOfLines = 0
        label.font = .customFont(style: .semiBold, size: 15)
        return label
    }()
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .TextRegularColor
        label.numberOfLines = 0
        label.font = .customFont(style: .regular, size: 15)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    private func setupUI(){
        selectionStyle = .none
        let stackView = UIStackView(arrangedSubViews: [titleLabel, subTitleLabel], axis: .vertical, spacing: 5, distribution: .fill)
        stackView.alignment = .leading
        
        
        let baseStackView = UIStackView(arrangedSubViews: [icon, stackView], axis: .horizontal, spacing: 12, distribution: .fill)
        baseStackView.alignment = .top
        
        baseStackView.isLayoutMarginsRelativeArrangement = true
        baseStackView.layoutMargins = .init(top: 12, left: 12, bottom: 12, right: 12)
        
        addSubview(baseStackView)
        baseStackView.makeConstraints(toView: self)
        
        icon.sizeConstraints(width: 24, height: 24)
    }
    
    func setupConfigure(_ data: PermisssionData){
        icon.image = UIImage(named: data.icon)
        titleLabel.text = data.titleText
        subTitleLabel.text = data.subTitleText
    }
}

struct PermisssionData{
    let icon: String
    let titleText: String
    let subTitleText: String
    
    static let values: [PermisssionData] = [
        .init(icon: "info_desc", titleText: "Why is this needed?", subTitleText: "So that you can start a livestream and have an engaging and interactive experience with your audience"),
        .init(icon: "info_gear", titleText: "How to enable permissions", subTitleText: "If you allow access now, you won’t have to allow it again. You can change your choices at any time in your device settings"),
    ]
}
