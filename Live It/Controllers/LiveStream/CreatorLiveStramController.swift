//
//  CreatorLiveStramController.swift
//  Live It
//
//  Created by Muniyaraj on 25/09/24.
//

import UIKit
import Combine
import AVFoundation

final class CreatorLiveStramController: BaseController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var videoSectionTable: UITableView!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var customizeSectionTable: UITableView!
    
    @IBOutlet weak var goLiveBtn: LoadingButton!
    @IBOutlet weak var streamCameraSectionCollect: UICollectionView!
    
    private lazy var cameraVM = CameraViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var captureSession = AVCaptureSession()
    var sessionStarted: Bool = false
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        initalizeUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupListeners()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    private func initalizeUI(){
        setupView()
        setupTheme()
        setupLang()
        setupFont()
        setupDelegate()
        setupAction()
        setObservers()
    }
    private func setupView(){
        goLiveBtn.buttonEnabled = true
        
        [videoSectionTable, customizeSectionTable, goLiveBtn, dismissBtn, streamCameraSectionCollect, bgView].forEach{
            $0?.layer.zPosition = 1
        }
    }
    private func setupConstrainats(){
        
    }
    private func setupTheme(){
        
    }
    internal override func setupLang(){
        DispatchQueue.main.async { [weak self] in
            guard let self else{ return }
            goLiveBtn.enableTitle_Text = "Go Live"
            goLiveBtn.disbleTitle_Text = "Go Live"
        }
    }
    private func setupFont(){
        
    }
    private func setupDelegate(){
        videoSectionTable.register(VideoSectionTableCell.self, forCellReuseIdentifier: VideoSectionTableCell.reuseIdentifier)
        videoSectionTable.delegate = self
        videoSectionTable.dataSource = self
        
//        videoSectionTable.isScrollEnabled = false
        videoSectionTable.isUserInteractionEnabled = true
//        customizeSectionTable.isScrollEnabled = false
        customizeSectionTable.isUserInteractionEnabled = true
        
        customizeSectionTable.register(VideoSectionTableCell.self, forCellReuseIdentifier: VideoSectionTableCell.reuseIdentifier)
        customizeSectionTable.delegate = self
        customizeSectionTable.dataSource = self
        
        streamCameraSectionCollect.setCollectionViewLayout(createLayout(), animated: true)
        streamCameraSectionCollect.register(CameraSectionCollectCell.self, forCellWithReuseIdentifier: CameraSectionCollectCell.reuseIdentifier)
        streamCameraSectionCollect.delegate = self
        streamCameraSectionCollect.dataSource = self
    }
    private func setupListeners(){
        cameraVM.checkCameraAuthorization()
        cameraVM.checkAudioAuthorization()
    }
    private func setObservers(){
        cameraVM.$isCameraAuthorized
            .combineLatest(cameraVM.$isAudiAuthorized)
            .sink { [weak self] camera_granted, audio_granted in
                switch (camera_granted, audio_granted){
                case (.granted, .granted):
                    debugPrint("Camera & Audio Permission granted")
                    self?.showPreviewCamera()
                    break
                case (.not_granted, .not_granted), (.not_granted, .granted), (.granted, .not_granted):
                    self?.openSettingPermissionPage()
                    debugPrint("Camera & Audio Permission are \(camera_granted) , \(audio_granted)")
                    break
                case (.none, .none), (.none, .granted), (.none, .not_granted), (.not_granted, .none), (.granted, .none):
                    debugPrint("don't worry the permission has been asked.")
                    break
                }
            }.store(in: &cancellables)
    }
    private func setupAction(){
        dismissBtn.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    @objc func buttonAction(_ sender: UIButton){
        switch sender{
        case dismissBtn:
            stopPreviewCamera()
            tabBarController?.selectedIndex = 0
        default: break
        }
    }
    private func createLayout()-> UICollectionViewCompositionalLayout{
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(120), heightDimension: .estimated(50)))
        
        let layoutSize = NSCollectionLayoutSize(widthDimension: .estimated(120), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 15, bottom: 10, trailing: 15)
        section.orthogonalScrollingBehavior = .continuous
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension CreatorLiveStramController{
    
    private func showPreviewCamera(){
        if !sessionStarted && setupCaptureSession(){
            sessionStarted = true
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.captureSession.startRunning()
            }
        }
    }
    private func stopPreviewCamera(){
        sessionStarted = false
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.stopRunning()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else{ return }
                previewLayer.removeFromSuperlayer()
            }
        }
    }
    private func cameraFlipButtonTapped(){
        captureSession.beginConfiguration()
        
        let newCurrentInput = captureSession.inputs.first as? AVCaptureDeviceInput
        let newCameraDevice = newCurrentInput?.device.position == .back ? getDeviceFront(position: .front) : getDeviceBack(position: .back)
        
        let newVideoInput = try? AVCaptureDeviceInput(device: newCameraDevice!)
        
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput]{
            for input in inputs {
                captureSession.removeInput(input)
            }
        }
        
        if captureSession.inputs.isEmpty{
            captureSession.addInput(newVideoInput!)
        }
        
        captureSession.commitConfiguration()
    }
    func setupCaptureSession()-> Bool{
        captureSession.sessionPreset = .high
        
        if let captureVideoDevice = getDeviceFront(position: .front){
            do{
                let inputVideo = try AVCaptureDeviceInput(device: captureVideoDevice)
                
                if captureSession.canAddInput(inputVideo){
                    captureSession.addInput(inputVideo)
                }
                
            }catch{
                debugPrint("couldn't get camera input : \(error.localizedDescription)")
                return false
            }
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        return true
    }
    func getDeviceFront(position: AVCaptureDevice.Position)-> AVCaptureDevice?{
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
    }
    func getDeviceBack(position: AVCaptureDevice.Position)-> AVCaptureDevice?{
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
    }
}

extension CreatorLiveStramController{
    
    func openSettingPermissionPage(){
        let selectionPage = CAPermissionController(viewModel: cameraVM)
        if #available(iOS 15.0, *) {
            
            /*let smallDetent = UISheetPresentationController.Detent.custom(identifier: .none) { context in
                return 200
            }
            let mediumDetent = UISheetPresentationController.Detent.custom(identifier: .none) { context in
                return 400
            }*/
            if #available(iOS 16.0, *) {
                let largeDetent = UISheetPresentationController.Detent.custom(identifier: .large) { [weak self] context in
                    return (self?.view.frame.size.height ?? 500) * 0.73
                }
                selectionPage.sheetPresentationController?.detents = [/*smallDetent, mediumDetent, */largeDetent]
            } else {
                // Fallback on earlier versions
                
                selectionPage.sheetPresentationController?.detents = [.large()]
            }
            
            // Optionally set the preferred detent
            selectionPage.sheetPresentationController?.selectedDetentIdentifier = .large
            
            //selectionPage.sheetPresentationController?.detents = [.large()]
            selectionPage.sheetPresentationController?.prefersGrabberVisible = true
            selectionPage.sheetPresentationController?.preferredCornerRadius = 20
            selectionPage.sheetPresentationController?.prefersScrollingExpandsWhenScrolledToEdge = false
        } else {
            selectionPage.modalPresentationStyle = .formSheet
        }
        presentToController(selectionPage, languageService: localizeService)
    }
}

extension CreatorLiveStramController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (tableView == videoSectionTable ? StreamSectionCategory.videoSectionData : StreamSectionCategory.customizeSectionData).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoSectionTableCell.reuseIdentifier, for: indexPath) as! VideoSectionTableCell
        let sections = (tableView == videoSectionTable ? StreamSectionCategory.videoSectionData : StreamSectionCategory.customizeSectionData)
        let section_data = sections[indexPath.row]
                
        cell.liveStreamSectionBtn.addTap { [weak self] in
            debugPrint("liveStreamSection called...")
            switch section_data.action{
            case .schedule_stream: break
            case .my_shop: break
            case .fund_rasiser: break
            case .setup_reactions: break
            case .share: break
            case .mute: break
            case .disable_video: break
            case .flip_camera:
                self?.cameraFlipButtonTapped()
                break
            }
        }
        
        cell.setupConfigure(section_data)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("tableView didSelectRowAt called")
    }
        
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard (tableView != videoSectionTable) else{ return nil }
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))

        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "downArrow"), for: .normal)
        button.setTitle("", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = .whiteAlpla_0_3
            config.contentInsets = .init(top: 6, leading: 0, bottom: 0, trailing: 0)
            button.configuration = config
        } else {
            button.backgroundColor = .whiteAlpla_0_3
            button.imageEdgeInsets.top = 6
        }

        footerView.addSubview(button)
        button.makeConstraints(top: nil, leading: footerView.leadingAnchor, trailing: nil, bottom: nil, width: 35, height: 35, edge: .init(top: 0, left: 6, bottom: 0, right: 0))
        button.makeCenterConstraints(toView: footerView, centerX_axis: false)

        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc func buttonTapped() {
        debugPrint("Button tapped!")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension CreatorLiveStramController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CameraSectionCategory.cameraSectionData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CameraSectionCollectCell.reuseIdentifier, for: indexPath) as! CameraSectionCollectCell
        let section = CameraSectionCategory.cameraSectionData[indexPath.item]
        cell.liveCameraSectionBtn.addTap {
            debugPrint("camera customize called...")
        }
        cell.setupConfigure(section)
        return cell
    }
}


final class VideoSectionTableCell: UITableViewCell, StoryboardCell{
    
    var liveStreamSectionBtn = CustomStreamBtn()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initalizeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initalizeUI()
    }
    private func initalizeUI(){
        selectionStyle = .none
        backgroundColor = .clear
        addSubview(liveStreamSectionBtn)
        liveStreamSectionBtn.makeConstraints(toView: self)
        liveStreamSectionBtn.isUserInteractionEnabled = true
    }
    func setupConfigure(_ data: StreamSectionCategory){
        liveStreamSectionBtn.title = data.title
        liveStreamSectionBtn.imageName = data.icon
        liveStreamSectionBtn.updatePostition(icon_first: data.type == .streamCustomize)
    }
}

final class CameraSectionCollectCell: UICollectionViewCell, StoryboardCell{
    
    let liveCameraSectionBtn = CustomCameraStreamBtn()
    let dotView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initalizeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initalizeUI()
    }
    private func initalizeUI(){
        backgroundColor = .clear
        addSubview(liveCameraSectionBtn)
        liveCameraSectionBtn.makeConstraints(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil,edge: .init(top: 0, left: 0, bottom: 0, right: 12))
        addSubview(dotView)
        dotView.makeConstraints(top: liveCameraSectionBtn.bottomAnchor, leading: nil, trailing: nil, bottom: bottomAnchor,edge: .init(top: 5, left: 0, bottom: 5, right: 0))
        dotView.sizeConstraints(width: 4, height: 4)
        dotView.makeCenterConstraints(toView: liveCameraSectionBtn, centerX_axis: true, centerY_axis: false)
        dotView.backgroundColor = .white
    }
    func setupConfigure(_ data: CameraSectionCategory){
        liveCameraSectionBtn.title = data.title
        liveCameraSectionBtn.imageName = data.icon
        liveCameraSectionBtn.isSelectedCamera = data.selected
        dotView.isHidden = !data.selected
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        dotView.layer.cornerRadius = dotView.frame.height / 2
    }
}

enum StreamCategory{
    case streamCustomize
    case videoCustomize
}
enum LiveVideoStreamCategoryAction{
    case schedule_stream
    case my_shop
    case fund_rasiser
    case setup_reactions
    case share
    case mute
    case disable_video
    case flip_camera
}

struct StreamSectionCategory{
    let title: String
    let type: StreamCategory
    let icon: String
    let action: LiveVideoStreamCategoryAction
    
    static var customizeSectionData: [StreamSectionCategory] = [
        .init(title: "Schedule a livestream", type: .videoCustomize, icon: "schedule_calender", action: .schedule_stream),
        .init(title: "My shop", type: .videoCustomize, icon: "my_shop", action: .my_shop),
        .init(title: "Fundraiser", type: .videoCustomize, icon: "fund_raiser", action: .fund_rasiser),
        .init(title: "Setup reactions", type: .videoCustomize, icon: "setup_reaction", action: .setup_reactions),
    ]
    static var videoSectionData: [StreamSectionCategory] = [
        .init(title: "Share", type: .streamCustomize, icon: "share_video", action: .share),
        .init(title: "Mute", type: .streamCustomize, icon: "mute_icon", action: .mute),
        .init(title: "Disable video", type: .streamCustomize, icon: "video_icon", action: .disable_video),
        .init(title: "Flip Camera", type: .streamCustomize, icon: "flip_camera_icon", action: .flip_camera),
    ]
}

struct CameraSectionCategory{
    let title: String
    let icon: String
    let selected: Bool
    static var cameraSectionData: [CameraSectionCategory] = [
        .init(title: "Connect device with RTMP", icon: "rtmp_camera", selected: false),
        .init(title: "Device Camera", icon: "device_camera", selected: true),
    ]
}
