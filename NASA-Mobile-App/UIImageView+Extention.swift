//
//  UIImageView+Extention.swift
//  NASA-Mobile-App
//
//  Created by Aditi Patil on 07/05/2023.
//

import Foundation
import UIKit
import Alamofire

extension UIImageView {
    public func image(url: String) {
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityIndicator.color = .black
        activityIndicator.center = self.center
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        if let url = URL(string: url) {
            AF.request(url).responseData { response in
                switch response.result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        self.image = image
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()
                    }
                case .failure(let error):
                    print("Error downloading image: \(error.localizedDescription)")
                }
            }
        }
        
    }
    
    
}
        
