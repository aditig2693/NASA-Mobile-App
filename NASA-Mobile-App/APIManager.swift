//
//  APIManager.swift
//  NASA-Mobile-App
//
//  Created by Aditi Patil on 07/05/2023.
//

import Foundation
import Alamofire

enum ServiceResponse {
    case success(response: JSONDecoder)
    case failure
    case notConnectedToInternet
}

func callEndPoint(endPoint: String = "", completion: @escaping (ServiceResponse) -> Void){
    AF.request("https://images-api.nasa.gov/search?q=\(endPoint)")
        .responseDecodable(of: Collection.self) { response in
            switch response.result {
            case .success(let collection):
                print(collection)
            case .failure(let error):
                print(error)
            }
        }
}

