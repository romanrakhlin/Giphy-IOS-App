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
        var closeButtonConfig = UIButton.Configuration.borderless()
        closeButtonConfig.image = UIImage(systemName: "xmark")
        closeButtonConfig.baseForegroundColor = .white
        closeButtonConfig.buttonSize = .medium
        closeButtonConfig.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        closeButton.configuration = closeButtonConfig
        
        var shareButtonConfig = UIButton.Configuration.borderless()
        shareButtonConfig.image = UIImage(systemName: "square.and.arrow.up")
        shareButtonConfig.baseForegroundColor = .white
        shareButtonConfig.buttonSize = .medium
        shareButtonConfig.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        shareButton.configuration = shareButtonConfig
        
        self.view.addSubview(closeButton)
        self.view.addSubview(shareButton)
        
        // configure image
        previewImage.contentMode = .scaleAspectFit
        
        
        // configure social buttons stack
//        let
//
//        firstStack.axis = .horizontal
//        firstStack.alignment = .center
//        firstStack.distribution = .equalSpacing
        
        
        self.view.addSubview(previewImage)
    }
    
    private func setupConstraints() {
        closeButton.snp.makeConstraints { make in
            make.left.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }
        
        shareButton.snp.makeConstraints { make in
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
        }
        
        previewImage.snp.makeConstraints { make in
            make.height.width.equalTo(self.view.frame.width - 40)
            make.centerX.equalTo(self.view)
            make.top.equalTo(120)
        }
    }
}
