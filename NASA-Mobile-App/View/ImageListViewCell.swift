//
//  ImageListViewCell.swift
//  NASA-Mobile-App
//
//  Created by Aditi Patil on 07/05/2023.
//

import UIKit

class ImageListViewCell: UITableViewCell {

    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var imageView_NASA: UIImageView!
    func configure(item :NASAItem?) {
        guard let url = item?.href, let title = item?.title else {
            return
        }
        imageView_NASA.image(url:url)
        imageTitle.text = title
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
