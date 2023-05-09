//
//  ImageDetailViewController.swift
//  NASA-Mobile-App
//
//  Created by Aditi Patil on 07/05/2023.
//

import UIKit
class ImageDetailViewController: UIViewController {
    
    @IBOutlet weak var dateCreated: UILabel?
    @IBOutlet weak var descriptionTextView: UITextView?
    @IBOutlet weak var imageView: UIImageView?
    var imageDetailItem: NASAItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIElements()
        // Do any additional setup after loading the view.
    }
    
    
    func setupUIElements(){
        guard let data = imageDetailItem else {
            return
        }
        imageView?.image(url: data.href)
        descriptionTextView?.text = data.description
        self.navigationItem.title = data.title
        let dateFormatter = DateFormatter() // Create a date formatter object
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: data.date_created) {
            dateFormatter.dateFormat = "yyyy-MM-dd" // Set the output format
            let formattedDate = dateFormatter.string(from: date)
            self.dateCreated?.text = " Date Created: " + formattedDate
            print(formattedDate) // Prints: 2011-06-08
        } else {
            print("Invalid date string") // Handle the case where the date string is invalid
        }
        
    }
}
