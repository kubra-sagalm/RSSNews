//
//  DetailViewController.swift
//  RSS
//
//  Created by kübra sağlam on 8.05.2025.
//

import UIKit

class DetailViewController: UIViewController {
    
    var newsItem: NewsItem?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        titleLabel.text = newsItem?.title
        descriptionTextView.text = newsItem?.description
        
        if let urlString = newsItem?.imageUrl, let url = URL(string: urlString) {
                   DispatchQueue.global().async {
                       if let data = try? Data(contentsOf: url) {
                           DispatchQueue.main.async {
                               self.newsImageView.image = UIImage(data: data)
                           }
                       }
                   }
               }
    
    }
}
