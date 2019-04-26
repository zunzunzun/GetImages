//
//  CollectionViewCell.swift
//  GetImages
//
//  Created by zun on 25/04/2019.
//  Copyright © 2019 zun. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func prepareForReuse() {
    imageView.image = UIImage(named: "Loading")
  }
  
}
