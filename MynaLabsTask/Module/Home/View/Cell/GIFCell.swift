//
//  GIFCell.swift
//  MynaLabsTask
//
//  Created by Roman Rakhlin on 7/25/22.
//

import UIKit
import Kingfisher

class GIFCell: UICollectionViewCell, ReusableView, NibLoadableView {
    
    @IBOutlet var imageView: AnimatedImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.kf.indicatorType = .activity
    }

    func setImage(imageUrl: String?) {
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = Asset.unknown.image
        }
    }
    
    override func prepareForReuse() {
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
}
