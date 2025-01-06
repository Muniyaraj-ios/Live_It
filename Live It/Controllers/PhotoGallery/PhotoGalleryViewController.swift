//
//  PhotoGalleryViewController.swift
//  Live It
//
//  Created by Muniyaraj on 24/08/24.
//

import Combine
import Photos
import UIKit

final class GalleryViewController: BaseController{
    
    private var viewModel = GalleryViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let saveButton = UIButton(type: .custom)
    private var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "cancelIcon"), for: .normal)
        button.tintColor = .PrimaryDarkColor
        return button
    }()
    
    var selectedView: UIView = {
        let view = UIView()
        return view
    }()
    var selectedPicture: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
     var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(GalleryCell.self, forCellWithReuseIdentifier: "GalleryCell")
        collection.isUserInteractionEnabled = true
        return collection
    }()
    
    var dismissImagePickerClosure: ((_ image: UIImage) -> Void)?
    
    var selectedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initalizeUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        debugPrint("Got a Memory waring catch it and clean it!")
        viewModel.removeCache() // for better performance
    }
    private func initalizeUI(){
        setupView()
        setupTheme()
        setupLang()
        setupFont()
        setupAction()
        fetchInitalData()
    }
    private func setupView(){
        let rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        let leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        view.addSubview(selectedView)
        selectedView.makeConstraints(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil)
        selectedView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        
        selectedView.addSubview(selectedPicture)
        selectedPicture.makeConstraints(toView: selectedView)
        selectedPicture.makeCenterConstraints(toView: selectedView)
        
        view.addSubview(collectionView)
        collectionView.makeConstraints(top: selectedView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,edge: .init(top: 15, left: 0, bottom: 0, right: 0))
    }
    private func setupConstrainats(){
        
    }
    private func setupTheme(){
        saveButton.setTitleColor(.PrimaryColor, for: .normal)
    }
    internal override func setupLang(){
        super.setupLang()
        DispatchQueue.main.async { [weak self] in
            guard let self else{ return }
            navigationItem.title = "upload_picture".localized(using: localizeService)
            saveButton.setTitle("save".localized(using: localizeService), for: .normal)
            
            view.updateTextAlignment(for: localizeService)
        }
    }
    private func setupFont(){
        setNavigationBarTitleAttributes()
        saveButton.titleLabel?.font = .customFont(style: .semiBold, size: 16)
    }
    private func setupDelegate(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        setCollectionViewBackgroundView()
    }
    
    func setCollectionViewBackgroundView() {
            // Create UILabel
            let backgroundLabel = UILabel()
            backgroundLabel.text = "No Data Available"
            backgroundLabel.textAlignment = .center
            backgroundLabel.font = UIFont.systemFont(ofSize: 20)
            backgroundLabel.textColor = .gray
            
            // Set the size of the label to match the collection view
            backgroundLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // Assign it to the backgroundView property of the collectionView
            collectionView.backgroundView = backgroundLabel
            
            // Add constraints to center the label
            NSLayoutConstraint.activate([
                backgroundLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
                backgroundLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
            ])
        }
    private func setupAction(){
        cancelButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    @objc private func buttonAction(_ sender: UIButton){
        switch sender{
        case cancelButton:
            self.dismiss(animated: true)
            break
        case saveButton:
            self.dismiss(animated: true) { [weak self] in
                if let image = self?.selectedPicture.image{
                    debugPrint("Images fetched to Personalize Page")
                    self?.dismissImagePickerClosure?(image)
                }
            }
            break
        default: break
        }
    }
    fileprivate func setupSelectedPicuture(selected index: Int){
        guard index < viewModel.currentResult.count else{ return }
        let selectedAsset = viewModel.currentResult[index]
        let targetSize = view.frame.size // selectedPicture.frame.size
        loadImage(nil, selectedImage: selectedPicture, for: selectedAsset.asset, targetSize: targetSize,isLoadCache: false)
    }
    fileprivate func fetchInitalData(){
        viewModel.fetchPhotos()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    debugPrint("Failed to fetch photos with error: \(error.localizedDescription)")
                case .finished:
                    debugPrint("Successfully fetched photos.")
                    self?.viewModel.fetchedLastData = true
                    break
                }
            }, receiveValue: { [weak self] success in
                debugPrint("Photos fetched: \(success)")
                guard success else{ return }
                if let firstIndex = self?.viewModel.currentResult.firstIndex(where: { $0.selected == false }) {
                    self?.selectedIndex = IndexPath(item: firstIndex, section: 0)
                    self?.viewModel.currentResult[firstIndex].selected = true
                }
                self?.setupDelegate()
                self?.collectionView.reloadData()
                self?.setupSelectedPicuture(selected: 0)
            })
            .store(in: &cancellables)
    }
    fileprivate func fetchLoadMoreData() {
        viewModel.loadMorePhotos()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    debugPrint("New data retrieved...")
                    self?.viewModel.fetchedLastData = true
                case .failure(let error):
                    debugPrint("Failed to fetch data: ", error.localizedDescription)
                }
            } receiveValue: { [weak self] success in
                guard success, let self = self else { return }
                
                // Calculate the old count before new items are added
                let oldCount = self.collectionView.numberOfItems(inSection: 0)
                let newCount = self.viewModel.currentResult.count
                
                // Check for inconsistencies and load missing content if necessary
                guard newCount > oldCount else {
                    debugPrint("No new items to insert or data inconsistency detected.")
                    
                    if newCount < oldCount {
                        // Handle case where data might have been removed or is inconsistent
                        debugPrint("Detected fewer items in viewModel than in collectionView. Reloading data to ensure consistency.")
                        self.collectionView.reloadData()
                    }
                    return
                }
                
                // Calculate the index paths to insert
                let indexPaths = (oldCount..<newCount).map { IndexPath(item: $0, section: 0) }
                
                self.collectionView.performBatchUpdates({
                    self.collectionView.insertItems(at: indexPaths)
                }, completion: { finished in
                    if !finished {
                        debugPrint("Batch updates failed, reloading data to ensure consistency.")
                        //self.collectionView.reloadData()
                    }
                })
            }
            .store(in: &cancellables)
    }

}
extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.currentResult.isEmpty {
            collectionView.backgroundView?.isHidden = false
        } else {
            collectionView.backgroundView?.isHidden = true
        }
        return viewModel.currentResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as? GalleryCell else{
            return UICollectionViewCell()
        }
        let asset = viewModel.currentResult[indexPath.item]
        loadImage(cell, for: asset.asset, targetSize: cell.imageView.frame.size)//cell.frame.size)
        
        cell.setupConfigure(asset)
        cell.imageView.tag = indexPath.item
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageSelectedWithData(_:)))
        tap.numberOfTapsRequired = 1
        cell.imageView.addGestureRecognizer(tap)
        cell.imageView.isUserInteractionEnabled = true
        return cell
    }
    @objc func imageSelectedWithData(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view else { return }
        let index = tappedImageView.tag
        
        if let selIndexPath = selectedIndex,selIndexPath.item != index{
            viewModel.currentResult[selIndexPath.item].selected.toggle()
            collectionView.reloadItems(at: [selIndexPath])
            
            let newSelectedIndex = IndexPath(item: index, section: 0)
            viewModel.currentResult[newSelectedIndex.item].selected.toggle()
            
            selectedIndex = newSelectedIndex
            collectionView.reloadItems(at: [newSelectedIndex])
            setupSelectedPicuture(selected: index)
        }
    }
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let cell = collectionView.visibleCells.first as? GalleryCell{
                let asset = viewModel.currentResult[indexPath.item]
                let targetSize = cell.imageView.frame.size // CGSize(width: 150, height: 150)
                loadImage(nil, for: asset.asset, targetSize: targetSize)
            }
        }
    }
    func loadImage(_ cell: GalleryCell?,selectedImage: UIImageView? = nil,for asset: PHAsset, targetSize: CGSize,isLoadCache: Bool = true) {
        viewModel.requestImage(for: asset, targetSize: targetSize,isLoadCache: isLoadCache)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    debugPrint("Error loading image: \(error)")
                    break
                }
            }, receiveValue: { image in
                cell?.imageView.image = image
                selectedImage?.image = image
            })
            .store(in: &cancellables)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let paddingCals: CGFloat = (12 + 6)
        let reducedWidth = (width - paddingCals)
        return CGSize(width: reducedWidth / 3, height: reducedWidth / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if position > contentHeight - scrollViewHeight /*2*/ {
            if viewModel.fetchedLastData{
                viewModel.fetchedLastData = false
                debugPrint("it's load on next page")
                fetchLoadMoreData()
            }
        }
    }
}

class GalleryCell: UICollectionViewCell {
    
    var bgView: UIView = UIView()
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return UIImageView()
    }()
    
    private var isChoosed: Bool = false{
        didSet{
            bgView.cornerRadiusWithBorder(corner: isChoosed ? 8 : 0, borderwidth: isChoosed ? 3 : 0, borderColor: isChoosed ? UIColor.PrimaryColor : UIColor.clear)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupImageView()
    }
    
    private func setupImageView() {
        addSubview(bgView)
        bgView.makeConstraints(toView: self)
        
        bgView.addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.makeConstraints(toView: self,edge: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
    func setupConfigure(_ gallery: GalleyPhotos){
        isChoosed = gallery.selected
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = 4
    }
}
