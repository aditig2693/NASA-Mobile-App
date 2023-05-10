//
//  ImageViewModel.swift
//  NASA-Mobile-App
//
//  Created by Aditi Patil on 07/05/2023.
//

import Foundation
import Alamofire

enum HTTPResponse: Equatable {
    case success
    case failure(error: Error)
    
    static func ==(lhs: HTTPResponse, rhs: HTTPResponse) -> Bool {
           switch (lhs, rhs) {
           case (.success, .success):
               return true
           case let (.failure(error1), .failure(error2)):
               return error1.localizedDescription == error2.localizedDescription
           default:
               return false
           }
       }
}


class ImageViewModel {
    // MARK: Properties
    var items: [NASAItem] = []
    var currentPage = 1
    // MARK: Public Methods
    func getNASAItems(searchString: String, endPoint:String,completion: @escaping (HTTPResponse) -> ()) {
        //Setting the page size to 20 items
        guard let encodedString = (APIConstants.baseUrl + endPoint + "?q=\(searchString)" + APIConstants.queryParameter + "&page=\(currentPage)").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
            print("Unable to encode string")
            return
        }
    
  
        AF.request(encodedString).responseDecodable(of: NASAResponse.self) { response in
            switch response.result {
            case .success(let nasaResponse):
                //if the current page is 1st page initialise the items with freshly fetched data
                if self.currentPage == 1 {
                    self.items = nasaResponse.collection.items.compactMap { $0.self }.compactMap { NASAItem(from: $0) }
                    
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

