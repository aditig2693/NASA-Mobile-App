//
//  ImageViewModel.swift
//  NASA-Mobile-App
//
//  Created by Aditi Patil on 07/05/2023.
//

import Foundation
import Alamofire

enum HTTPResponse {
    case success
    case failure(error: Error)
}


class ImageViewModel {
    // MARK: Properties
    var items: [NASAItem] = []
    var currentPage = 1
    var isSeachEnabled: Bool = false
    // MARK: Public Methods
    func getNASAItems(searchString: String, completion: @escaping (HTTPResponse) -> ()) {
        //Setting the page size to 20 items
        guard let encodedString = (APIConstants.baseUrl + APIConstants.endPoint + "?q=\(searchString)" + APIConstants.queryParameter + "&page=\(currentPage)").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
            print("Unable to encode string")
            return
        }
    
  
        AF.request(encodedString).responseDecodable(of: NASAResponse.self) { response in
            switch response.result {
            case .success(let nasaResponse):
                //if the current page is 1st page initialise the items with freshly fetched data
                if self.currentPage == 1 {
                    self.items = nasaResponse.collection.items.compactMap { $0.self }.compactMap { NASAItem(from: $0) }
                    self.isSeachEnabled = false
                    
                } else { //else append the data to items
                    let newData = nasaResponse.collection.items.compactMap { $0.self }.compactMap { NASAItem(from: $0) }
                    self.items.append(contentsOf: newData)
                }
                completion(.success)
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    
}

