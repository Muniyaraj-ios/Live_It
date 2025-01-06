//
//  TikTokHomePageViewController.swift
//  Live It
//
//  Created by Muniyaraj on 06/09/24.
//

import UIKit

class TikTokHomePageViewController: BaseController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    private var pageViewController: UIPageViewController!
    
    private lazy var orderedViewControllers: [UIViewController] = {
        return [ForYouViewController(), ForYouViewController(), ForYouViewController()]
    }()
    
    var fillProfilePopUP: Bool = false
    
    lazy private var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["For You", "Following", "Discover"])
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        return sc
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        setupPageViewController()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkCompleteProfile()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupUI() {
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        segmentedControl.setup()
    }
    
    func setupScrollViewListener() {
        // Get the scrollView from the UIPageViewController
        for subview in pageViewController.view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
            }
        }
    }
    
    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        if let firstController = orderedViewControllers.first{
            pageViewController.setViewControllers([firstController], direction: .forward, animated: true, completion: nil)
        }
                
        //pageViewController.view.frame = view.bounds
        pageViewController.view.backgroundColor = .clear//.PrimaryColor
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.makeConstraints(toView: view, isSafeArea: false)
        
        pageViewController.didMove(toParent: self)
        
        setupScrollViewListener()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //pageViewController.view.frame = view.bounds
        pageViewController.view.clipsToBounds = true
    }
}
extension TikTokHomePageViewController{
    
    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        let currentViewController = pageViewController.viewControllers?.first
        let currentIndex = orderedViewControllers.firstIndex(of: currentViewController!) ?? 0
        let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
        pageViewController.setViewControllers([orderedViewControllers[index]], direction: direction, animated: true, completion: nil)
        
        sender.moveUnderline()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = orderedViewControllers.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return orderedViewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = orderedViewControllers.firstIndex(of: viewController), index < orderedViewControllers.count - 1 else {
            return nil
        }
        return orderedViewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleViewController = pageViewController.viewControllers?.first, let index = orderedViewControllers.firstIndex(of: visibleViewController) {
            segmentedControl.selectedSegmentIndex = index
            segmentedControl.moveUnderline()
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.x
        let scrollWidth = scrollView.frame.width
        segmentedControl.moveUnderlineX_dynamic(scrollOffset: scrollOffset, scrollWidth: scrollWidth)
        
    }
}

extension TikTokHomePageViewController: FillProfileAction{
    func checkCompleteProfile(){
        guard !fillProfilePopUP else { return }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4){ [weak self] in
            self?.showFillOutpPopup()
        }
    }
    
    func showFillOutpPopup(){
        let selectionPage = FilloutProfileController(pageType: .go_live_now)
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
    func doFillProfile() {
        fillProfilePopUP.toggle()
    }
    
    func skipFillProfile() {
        fillProfilePopUP.toggle()
    }
}



private var isAnimatingKey: UInt8 = 0
extension UISegmentedControl {
    
    var isAnimating: Bool {
        get {
            return objc_getAssociatedObject(self, &isAnimatingKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &isAnimatingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
        
    private var underlineHeight: CGFloat { 3.5 }
    
    private var segmentWidth: CGFloat { bounds.width / CGFloat(numberOfSegments) }
    
    private var underlineMinY: CGFloat { bounds.height - 1.0 }
    
    func setup() {
        style()
        transparentBackground()
        addUnderline()
    }
    
    func style() {
        clipsToBounds = false
        tintColor = .clear
        backgroundColor = .clear
        selectedSegmentTintColor = .clear
        selectedSegmentIndex = 0
        
        let attributes: [NSAttributedString.Key: Any] = NSAttributedString.createAttributes(font: .customFont(style: .semiBold, size: 16), color: .ButtonTextColor, lineSpacing: 0, alignment: .center)
        setTitleTextAttributes(attributes, for: .normal)
        setTitleTextAttributes(attributes, for: .selected)
        sizeToFit()
    }

    func transparentBackground() {
        let backgroundImage = UIImage.coloredRectangleImageWith(color: UIColor.clear.cgColor, andSize: self.bounds.size)
        let dividerImage = UIImage.coloredRectangleImageWith(color: UIColor.clear.cgColor, andSize: CGSize(width: 1, height: self.bounds.height))
        setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
        setDividerImage(dividerImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    func addUnderline() {
        let underline = UIView()
        underline.backgroundColor = UIColor.ButtonTextColor
        underline.tag = 1
        
        updateUnderlineframe(underline: underline)
        self.addSubview(underline)
    }
    
    func updateUnderlineframe(underline: UIView, animated: Bool = false){
        let selectedIndex = selectedSegmentIndex
        let underLineWidth = widthForSegmentTitle(at: selectedIndex)
        
        let underlineX = xPositionForSegmentTitle(at: selectedIndex)
        
        isAnimating = true
        
        if animated{
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                guard let self else{ return }
                underline.frame = CGRect(x: underlineX, y: underlineMinY, width: underLineWidth, height: underlineHeight)
            }) { [weak self] _ in
                self?.isAnimating = false
            }
        }else{
            underline.frame = CGRect(x: underlineX, y: underlineMinY, width: underLineWidth, height: underlineHeight)
        }
    }
    
    func widthForSegmentTitle(at index: Int) -> CGFloat {
        guard let title = titleForSegment(at: index) else { return 0 }
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.customFont(style: .semiBold, size: 16)
        ]
        return (title as NSString).size(withAttributes: attributes).width
    }
    
    // Method to calculate the x position of a segment's text (starting point for the underline)
    private func xPositionForSegmentTitle(at index: Int) -> CGFloat {
        
        // Calculate the leading space within the segment where the text starts
        let textWidth = widthForSegmentTitle(at: index)
        let leadingSpace = (segmentWidth - textWidth) / 2
        
        // Calculate the x-position for the selected segment's text
        let underlineX = (segmentWidth * CGFloat(index)) + leadingSpace
        return underlineX
    }
    func moveUnderline(){
        guard let underline = self.viewWithTag(1) else {return}
        updateUnderlineframe(underline: underline, animated: true)
    }
    func moveUnderlineX_dynamic(scrollOffset: CGFloat, scrollWidth: CGFloat){
        if isAnimating{ return }
        
        guard let underline = self.viewWithTag(1) else {return}
        
        
        // Calculate how far the scroll has moved as a percentage
        let percentage = (scrollOffset - scrollWidth) / scrollWidth
        
        // Get the x-positions for the current and next segments
        let currentXPosition = xPositionForSegmentTitle(at: selectedSegmentIndex)
        let nextSegmentIndex = min(max(selectedSegmentIndex + (percentage > 0 ? 1 : -1), 0), numberOfSegments - 1)
        let nextXPosition = xPositionForSegmentTitle(at: nextSegmentIndex)

        // Interpolate between the current and next segment positions
        let interpolatedX = currentXPosition + (nextXPosition - currentXPosition) * abs(percentage)
        
        // Set the underline's x position dynamically
        underline.frame.origin.x = interpolatedX
    }
}

// MARK: - UIImage extension
extension UIImage {
    class func coloredRectangleImageWith(color: CGColor, andSize size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }

}
