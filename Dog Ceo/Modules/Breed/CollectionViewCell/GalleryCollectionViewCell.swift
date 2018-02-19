//
//  GalleryCollectionViewCell.swift
//  Dog Ceo
//
//  Created by Samuel on 06-02-18.
//  Copyright © 2018 Samuel. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    var dogImageEndpoint : String?
    
    @IBOutlet weak var dogBackgroundImage: UIImageView!
    @IBOutlet weak var dogImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        dogBackgroundImage.addSubview(blurEffectView)
        
        // Initialization code
    }

}
