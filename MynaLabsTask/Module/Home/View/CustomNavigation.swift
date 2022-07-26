//
//  CustomNavigation.swift
//  MynaLabsTask
//
//  Created by Roman Rakhlin on 7/26/22.
//

import UIKit
import SnapKit

class CustomNavigation: UIView {
    
    let logoImage = UIImageView()
    let createButton = UIButton()
    
    let navigationStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setConstraints()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLayout()
        setConstraints()
    }
    
    private func setupLayout() {
        self.backgroundColor = Asset.backgroundColor.color
        
        // configure image
        logoImage.image = Asset.logo.image
        logoImage.contentMode = .scaleAspectFit
        
        // configure button
        var buttonConfiguration = UIButton.Configuration.borderless()
        buttonConfiguration.image = UIImage(systemName: "camera")
        buttonConfiguration.imagePlacement = .trailing
        buttonConfiguration.imagePadding = 8.0
        buttonConfiguration.title = "Create"
        buttonConfiguration.baseForegroundColor = .white
        buttonConfiguration.buttonSize = .medium
        buttonConfiguration.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        createButton.configuration = buttonConfiguration
        
        // add elemetns on view
        self.addSubview(logoImage)
        self.addSubview(createButton)
    }
    
    private func setConstraints() {
        logoImage.snp.makeConstraints { make in
            make.height.equalTo(self.snp.height).offset(-20)
            make.width.equalTo(100)
            make.left.equalTo(10)
        }
        
        createButton.snp.makeConstraints { make in
            make.height.equalTo(self.snp.height).offset(-20)
            make.right.equalTo(-10)
        }
    }
}
