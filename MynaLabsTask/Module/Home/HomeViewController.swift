//
//  HomeViewController.swift
//  MynaLabsTask
//
//  Created by Roman Rakhlin on 7/25/22.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController, UINavigationBarDelegate {
    
    let gifCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let customNavigation = CustomNavigation()
    
    var GIFs = [GiphyData]() {
        didSet {
            print(GIFs.count)
        }
    }
    var pagenation: Pagenation?
    var isRefresh = false
    
    private var viewModel: HomeViewModelProtocol
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
           
        fetchGIFs()
        UIApplication.shared.statusBarStyle = .lightContent
    }

    private func fetchGIFs(offset: Int = 0) {
        DispatchQueue.global(qos: .background).async { [self] in
            viewModel.fetchGIFs(with: offset, completion: { GIFs, pagenation, error in
                
                if error != nil {
                    print("Show alert here")
                } else {
                    guard let safeGIFs = GIFs else {
                        print("Oprional response")
                        return
                    }
                    
                    self.GIFs.append(contentsOf: safeGIFs)
                    self.pagenation = pagenation
                    
                    self.reloaCollectionView()
                }
            })
        }
    }
    
    private func reloaCollectionView() {
        DispatchQueue.main.async { [self] in
            UIView.transition(with: gifCollectionView, duration: 0.2, options: .transitionCrossDissolve, animations: { () -> Void in
                self.gifCollectionView.reloadData()
            }, completion: { _ in
                self.isRefresh = false
            })
        }
    }
}

// MARK: - Layout Configuration
extension HomeViewController {
    
    fileprivate func setupLayout() {
        setupNavigation()
        setupCollectionView()
        setupConstraints()
    }
    
    fileprivate func setupNavigation() {
        navigationController?.navigationBar.barTintColor = Asset.backgroundColor.color
        navigationController?.navigationBar.backgroundColor = Asset.backgroundColor.color
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 40)
        
        self.navigationItem.titleView = customNavigation
    }
    
    fileprivate func setupCollectionView() {
        gifCollectionView.delegate = self
        gifCollectionView.dataSource = self
        
        gifCollectionView.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        
        gifCollectionView.register(GIFCell.self)
        
        gifCollectionView.collectionViewLayout = GiphyLayout()
        
        if let layout = gifCollectionView.collectionViewLayout as? GiphyLayout {
            layout.delegate = self
        }
        
        self.view.addSubview(gifCollectionView)
    }
    
    fileprivate func setupConstraints() {
        // TODO: - Remove
        customNavigation.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        gifCollectionView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GIFs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GIFCell", for: indexPath) as? GIFCell,
            let imageUrl = GIFs[indexPath.row].images?.downsized?.url
        {
            cell.setImage(imageUrl: imageUrl)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = GifDetailWireFrame.createGifDetailModule(image: giphyDataList[indexPath.row].images)
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.gifCollectionView.contentOffset.y >= (self.gifCollectionView.contentSize.height - self.gifCollectionView.bounds.size.height)) {
            guard let totalCount = pagenation?.total_count, totalCount > self.GIFs.count, !isRefresh else {
                return
            }
            
            self.isRefresh = true
            fetchGIFs(offset: self.GIFs.count)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
       if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
          navigationController?.setNavigationBarHidden(true, animated: true)

       } else {
          navigationController?.setNavigationBarHidden(false, animated: true)
       }
    }
}

extension HomeViewController: GiphyLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let downSized = GIFs[indexPath.row].images?.downsized,
            let width = downSized.width, let height = downSized.height else {
            return 0
        }
        
        let downloadedImageWidth = CGFloat(NSString(string: width).floatValue)
        let downloadedImageHeight = CGFloat(NSString(string: height).floatValue)
        let collectionViewHalfWidth = (collectionView.bounds.width / 2)
        let ratio = collectionViewHalfWidth / CGFloat(downloadedImageWidth)
        
        return downloadedImageHeight * ratio
    }
}

extension HomeViewController {
    
//    func searchSuccess(data: [GiphyData], pagination: Pagenation) {
//        if !self.isRefresh {
//            self.gifCollectionView.setContentOffset(.zero, animated: false)
//        }
//
//        self.GIFs.append(contentsOf: data)
//        self.pagination = pagination
//        self.gifCollectionView.reloadData()
//        self.isRefresh = false
//    }
}






protocol GiphyLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class GiphyLayout: UICollectionViewLayout {
    
    weak var delegate: GiphyLayoutDelegate?
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        cache.removeAll()
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? 180
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: photoHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = frame.maxY
            yOffset[column] = yOffset[column] + photoHeight
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
}
