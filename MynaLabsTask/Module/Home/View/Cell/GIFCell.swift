//
//  GIFCell.swift
//  MynaLabsTask
//
//  Created by Roman Rakhlin on 7/25/22.
//

import UIKit
import SnapKit
import Kingfisher

class GIFCell: UICollectionViewCell, ReusableView, NibLoadableView {
    
    private let GIFImage = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 4
        self.backgroundColor = .randomColor
        self.layer.masksToBounds = true
        
        switchLoading(start: true)
        
        self.addSubview(GIFImage)
    }
    
    private func setupConstraints() {
        GIFImage.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(0)
        }
    }

    public func setImage(imageUrl: String?) {
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            self.GIFImage.kf.setImage(
                with: url,
                placeholder: nil,
                options: [
                    .processor(DownsamplingImageProcessor(size: self.bounds.size)),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ],
                completionHandler: { _ in
                    self.switchLoading(start: false)
                }
            )
        } else {
            self.GIFImage.image = Asset.unknown.image
        }
    }
    
    override func prepareForReuse() {
        GIFImage.kf.cancelDownloadTask()
        
        self.GIFImage.image = nil
        self.switchLoading(start: true)
    }
    
    private func switchLoading(start: Bool) {
        if start {
            self.startShimmeringAnimation()
        } else {
            self.stopShimmeringAnimation()
        }
    }
}
