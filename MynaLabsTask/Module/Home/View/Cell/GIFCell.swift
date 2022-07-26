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

    func setImage(imageUrl: String) {
        guard let url = URL(string: imageUrl) else {
            return
        }
        
        imageView.kf.setImage(with: url)
    }
    
    override func prepareForReuse() {
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
}
