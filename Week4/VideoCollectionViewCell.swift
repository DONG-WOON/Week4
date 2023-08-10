//
//  VideoCollectionViewCell.swift
//  Week4
//
//  Created by 서동운 on 8/9/23.
//

import UIKit
import Kingfisher



class VideoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = .boldSystemFont(ofSize: 15)
        dateLabel.font = .systemFont(ofSize: 13)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        titleLabel.text = nil
        dateLabel.text = nil
    }
    
    func update(data: Video) {
        imageView.kf.setImage(with: URL(string: data.thumbnail))
        titleLabel.text = data.title
        dateLabel.text = data.contents
    }
}
