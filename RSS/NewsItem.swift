//
//  NewsItem.swift
//  RSS
//
//  Created by kübra sağlam on 8.05.2025.
//



import Foundation

struct NewsItem {
    var title: String
    var description: String
    var pubDate: String
    var link: String
    var imageUrl: String
    
    
    init(title: String, description: String, pubDate: String, link: String, imageUrl: String) {
           self.title = title
           self.description = description
           self.pubDate = pubDate
           self.link = link
           self.imageUrl = imageUrl
       }
}
