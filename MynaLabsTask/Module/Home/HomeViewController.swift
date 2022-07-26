//
//  HomeViewController.swift
//  MynaLabsTask
//
//  Created by Roman Rakhlin on 7/25/22.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController, UINavigationBarDelegate {

    var GIFs = [GiphyData]() {
        didSet {
            print(GIFs.count)
        }
    }
    var pagenation: Pagenation?
    var isRefresh = false
    
    let gifCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let customNavigation = CustomNavigation()
    
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
        
        // TODO: - Fix Deprecated Feature
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
            self.gifCollectionView.reloadData()
            self.isRefresh = false
            
//            self.gifCollectionView.reloadSections(IndexSet(integersIn: 0...gifCollectionView.numberOfSections - 1))
//            self.isRefresh = false
           
//            UIView.transition(with: gifCollectionView, duration: 2, options: ., animations: { () -> Void in
//                self.gifCollectionView.reloadData()
//            }, completion: { _ in
//                self.isRefresh = false
//            })
        }
    }
}

// MARK: - Layout Configuration
extension HomeViewController {
    
    fileprivate func setupLayout() {
        self.gifCollectionView.backgroundColor = Asset.backgroundColor.color
        
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
        gifCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        gifCollectionView.register(GIFCell.self)
        gifCollectionView.collectionViewLayout = GiphyLayout()
        
        if let layout = gifCollectionView.collectionViewLayout as? GiphyLayout {
            layout.delegate = self
        }
        
        self.view.addSubview(gifCollectionView)
    }
    
    fileprivate func setupConstraints() {
        customNavigation.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        gifCollectionView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = GifDetailWireFrame.createGifDetailModule(image: giphyDataList[indexPath.row].images)
//        self.navigationController?.pushViewController(vc, animated: false)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GIFs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GIFCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setImage(imageUrl: GIFs[indexPath.row].images?.downsized?.url)
        return cell
    }
}

// MARK: - UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate {
    
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

// MARK: - MosaicLayoutDelegate
extension HomeViewController: MosaicLayoutDelegate {
    
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
