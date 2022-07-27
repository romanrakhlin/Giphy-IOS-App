//
//  CetegoryScrollView.swift
//  MynaLabsTask
//
//  Created by Roman Rakhlin on 7/27/22.
//

import UIKit
import SnapKit

class CategoryScrollView: UIView {
    
    let categories = ["GIFs", "Stickers", "Bla", "Bla", "Bla", "Bla", "Bla", "Bla"]
    
    let categoryScroll = UIScrollView()
    let categoryStack = UIStackView()
    
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
        categoryScroll.showsHorizontalScrollIndicator = false
        self.addSubview(categoryScroll)
        
        var buttonConfiguration = UIButton.Configuration.bordered()
        buttonConfiguration.baseForegroundColor = .white
        buttonConfiguration.buttonSize = .medium
        buttonConfiguration.cornerStyle = .capsule
        buttonConfiguration.baseBackgroundColor = Asset.mainButtonColor.color
        buttonConfiguration.titleAlignment = .center
        
        for category in categories {
            let categoryButton = UIButton(configuration: buttonConfiguration)
            categoryButton.setTitle(category, for: .normal)
            categoryStack.addArrangedSubview(categoryButton)
        }
        
        categoryStack.axis = .horizontal
        categoryStack.distribution = .fillEqually
        categoryStack.spacing = 10
        
        categoryScroll.addSubview(categoryStack)
    }
    
    private func setConstraints() {
        categoryScroll.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.left.right.equalTo(0)
        }
        
        categoryStack.snp.makeConstraints { make in
            make.left.right.equalTo(0)
        }
    }
}
