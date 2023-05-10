//
//  Constants.swift
//  NASA-Mobile-App
//
//  Created by Aditi Patil on 09/05/2023.
//
struct APIConstants {
    static let protocols     = "https://"
    static let domain        = "images-api.nasa.gov"
    static let search     = "/search"
    static let queryParameter = "&page_size=20&media_type=image"
    static let baseUrl       = APIConstants.protocols + APIConstants.domain 
}

struct AppConstants {
    static let  imageListViewCell = "ImageListViewCell"
    static let searchBarPlaceHolder = "Search for...(e.g Apollo)"
    static let showImageDetailsSegue = "showImageDetails"
    static let emptyViewMessage = "Nothing to show here"
}

