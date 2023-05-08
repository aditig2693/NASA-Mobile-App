//
//  ImageViewModel.swift
//  NASA-Mobile-App
//
//  Created by Aditi Patil on 07/05/2023.
//

import Foundation
import Alamofire

protocol ViewModelDelegate {
    func reloadTable()
}

class ImageViewModel {
    // MARK: Properties
    var items: [NASAItem] = []
    var currentPage = 1
    var isSeachEnabled: Bool = false
    // MARK: Public Methods
    func getNASAItems(endPoint: String, completion: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        guard let encodedString = "https://images-api.nasa.gov/search?q=\(endPoint)&media_type=image&page=\(currentPage)&page_size=20".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
            print("Unable to encode string")
            return
        }
        AF.request(encodedString).responseDecodable(of: NASAResponse.self) { response in
            switch response.result {
            case .success(let nasaResponse):
                if self.isSeachEnabled  || self.currentPage == 1 {
                    self.items = nasaResponse.collection.items.compactMap { $0.self }.compactMap { NASAItem(from: $0) }
                    self.isSeachEnabled = false
                    
                } else {
                    let newData = nasaResponse.collection.items.compactMap { $0.self }.compactMap { NASAItem(from: $0) }
                    // If it's not the first page, append the data
                    self.items.append(contentsOf: newData)
                }
                self.currentPage = self.currentPage + 1
                completion(true, nil)
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
    
}

