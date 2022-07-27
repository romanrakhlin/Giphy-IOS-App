//
//  SocialButton.swift
//  MynaLabsTask
//
//  Created by Roman Rakhlin on 7/26/22.
//

import UIKit
import SnapKit

class SocialButton: UIImageView {
    
    let buttonLayer = UIButton()
    
    var social: Social! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.buttonLayer.target(forAction: #selector(shareGIF), withSender: self)
        self.addSubview(buttonLayer)
        
        buttonLayer.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(0)
        }
    }
    
    public func setupSocialButton(for social: Social) {
        switch social {
        case .IMessage:
            self.image = Asset.Socials.iMessage.image
        case .Messenger:
            self.image = Asset.Socials.messenger.image
        case .Snapchat:
            self.image = Asset.Socials.snapchat.image
        case .WhatsApp:
            self.image = Asset.Socials.whatsApp.image
        case .Instagram:
            self.image = Asset.Socials.instagram.image
        case .Facebook:
            self.image = Asset.Socials.facebook.image
        case .Twitter:
            self.image = Asset.Socials.twitter.image
        }
    }
    
    @objc func shareGIF() {
        switch social {
        case .IMessage:
            print("Share to IMessage")
        case .Messenger:
            print("Share to Messenger")
        case .Snapchat:
            print("Share to Snapchat")
        case .WhatsApp:
            print("Share to WhatsApp")
        case .Instagram:
            print("Share to Instagram")
        case .Facebook:
            print("Share to Facebook")
        case .Twitter:
            print("Share to Twitter")
        case .none:
            print("Unknown Error")
        }
    }
}
