//
//  CustomNavigation.swift
//  MynaLabsTask
//
//  Created by Roman Rakhlin on 7/26/22.
//

import UIKit
import SnapKit

class CustomNavigation: UINavigationBar {
    
    let logoImage = UIImage()
    let createButton = UIButton()
    
    let navigationStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLayout()
    }
    
    private func setupLayout() {
        // configure image
        
    }
    
    private func setConstraints() {
        <#code#>
    }
}
