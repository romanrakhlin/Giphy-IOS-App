//
//  DetailViewController.swift
//  MynaLabsTask
//
//  Created by Roman Rakhlin on 7/26/22.
//

import UIKit
import SnapKit
import Kingfisher

class DetailViewController: UIViewController {
    
    let closeButton = UIButton()
    let shareButton = UIButton()
    
    let previewImage = UIImageView()
    let shareButtonsStack = UIStackView()
    let actionButtonsStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    public func setGIF(imageUrl: String?) {
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            self.previewImage.kf.setImage(
                with: url,
                placeholder: nil,
                options: [
                    .processor(DownsamplingImageProcessor(size: self.view.bounds.size)),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ],
                completionHandler: { _ in
                    
                    
                    
                }
            )
        } else {
            self.previewImage.image = Asset.unknown.image
        }
    }
    
    private func setupLayout() {
        self.view.backgroundColor = Asset.backgroundColor.color
        
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        // configure navigation buttons
        
        
        // configure social buttons stack
//        let
//
//        firstStack.axis = .horizontal
//        firstStack.alignment = .center
//        firstStack.distribution = .equalSpacing
        
        self.view.addSubview(previewImage)
    }
    
    private func setupConstraints() {
        previewImage.snp.makeConstraints { make in
            make.height.width.equalTo(144)
            make.centerX.equalTo(self.view)
        }
    }
}
