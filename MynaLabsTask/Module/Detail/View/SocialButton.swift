//
//  SocialButton.swift
//  MynaLabsTask
//
//  Created by Roman Rakhlin on 7/26/22.
//

import UIKit

class SocialButton: UIImageView {
    
    var social: Social! = nil
    
    func setupUI(for social: Social) {
        switch social {
        case .IMessage:
            self.image = Asset.unknown.image
        case .Messenger:
            self.image = Asset.unknown.image
        case .Snapchat:
            self.image = Asset.unknown.image
        case .WhatsApp:
            self.image = Asset.unknown.image
        case .Instagram:
            self.image = Asset.unknown.image
        case .Facebook:
            self.image = Asset.unknown.image
        case .Twitter:
            self.image = Asset.unknown.image
        }
    }
}
