//
//  ImageDetails.swift
//  NASA-Mobile-App
//
//  Created by Aditi Patil on 07/05/2023.
//

import Foundation
import UIKit
struct NASAItem {
    
    let title: String
    let description: String
    let nasa_id: String
    let date_created: String
    let href: String
    
    init?(from item: Item) {
        guard let title = item.data.first?.title, let description = item.data.first?.description, let nasa_id = item.data.first?.nasa_id, let date_created = item.data.first?.date_created, let href = item.links.first?.href else {
            return nil
        }
        self.title = title
        self.description = description
        self.nasa_id = nasa_id
        self.date_created = date_created
        self.href = href
    }
    
}

struct NASAResponse: Decodable {
    let collection: Collection
}


struct Collection: Decodable {
    let href: String
    let items: [Item]
}

struct Item: Decodable {
    let data: [ImageData]
    let href: String
    let links: [Link]
}

struct ImageData: Decodable {
    let description: String?
    let title: String?
    let nasa_id: String?
    let date_created: String?
}

struct Link: Decodable {
    let href: String
    let rel: String
    let render: String?
}

