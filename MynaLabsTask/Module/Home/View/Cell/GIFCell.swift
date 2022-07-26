//
//  GIFCell.swift
//  MynaLabsTask
//
//  Created by Roman Rakhlin on 7/25/22.
//

import UIKit
import SnapKit
import Kingfisher

class ShimmerImageView: UIImageView {
    
    static let animationDuration: Double = 2.0
    
    lazy var gradientLayer: CAGradientLayer = {
        let randomColor: UIColor = .randomColor
        
        let gradientColorOne: CGColor = randomColor.cgColor
        let gradientColorTwo: CGColor = randomColor.withAlphaComponent(1.4).cgColor
        
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
        gradient.locations = [0.0, 0.5, 1.0]
        return gradient
    }()
    
    func addGradientLayer() {
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }
    
    func removeGradientLayer() {
        gradientLayer.removeFromSuperlayer()
    }

    func addAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = ShimmerImageView.animationDuration
        return animation
    }
    
    override func startAnimating() {
        self.addGradientLayer()
        let animation = addAnimation()
        
        CATransaction.begin()
        // Setting this block before adding the animation is crucial
        CATransaction.setCompletionBlock({ [weak self] in
            self?.removeGradientLayer()
        })
        gradientLayer.add(animation, forKey: animation.keyPath)
        CATransaction.commit()
    }
    
}



class GIFCell: UICollectionViewCell, ReusableView, NibLoadableView {
    
    let GIFImage = ShimmerImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        GIFImage.layer.cornerRadius = 4
        GIFImage.layer.masksToBounds = true
        
        self.addSubview(GIFImage)
    }
    
    private func setupConstraints() {
        GIFImage.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(0)
        }
    }

    func setImage(imageUrl: String?) {
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            GIFImage.kf.setImage(with: url, placeholder: nil, options: nil) { _ in
                self.GIFImage.startAnimating()
            }
        } else {
            GIFImage.image = Asset.unknown.image
        }
    }
    
    override func prepareForReuse() {
        GIFImage.kf.cancelDownloadTask()
        GIFImage.image = nil
    }
}
