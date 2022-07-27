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
    
    let copyLinkButton = UIButton()
    let copyGIFButton = UIButton()
    let cancelButton = UIButton()
    
    var previewIsLoaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if !previewIsLoaded {
            switchLoading(start: true)
        }
    }
    
    public func setGIF(imageUrl: String?) {
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            self.previewImage.kf.setImage(
                with: url,
                placeholder: nil,
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ],
                completionHandler: { _ in
                    self.switchLoading(start: false)
                    self.previewIsLoaded = true
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
        
        // configure preview image
        previewImage.layer.cornerRadius = 4
        previewImage.backgroundColor = .randomColor
        previewImage.contentMode = .scaleAspectFill
        previewImage.layer.masksToBounds = true
        
        self.view.addSubview(previewImage)
        
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
        
        // configure share buttons stack
        let socials: [Social] = [.IMessage, .Messenger, .Snapchat, .WhatsApp, .Instagram, .Facebook, .Twitter]
        for social in socials {
            let socialButton = SocialButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            socialButton.setupSocialButton(for: social)
            shareButtonsStack.addArrangedSubview(socialButton)
        }
        
        shareButtonsStack.axis = .horizontal
        shareButtonsStack.alignment = .center
        shareButtonsStack.distribution = .fillEqually
        shareButtonsStack.spacing = 4
        
        self.view.addSubview(shareButtonsStack)
        
        // configure social buttons stack
//        let
//
//        firstStack.axis = .horizontal
//        firstStack.alignment = .center
//        firstStack.distribution = .equalSpacing
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
        
        shareButtonsStack.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(previewImage.snp.bottom).offset(80)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
    }

    private func switchLoading(start: Bool) {
        if start {
            previewImage.startShimmeringAnimation()
        } else {
            previewImage.stopShimmeringAnimation()
        }
    }
}
