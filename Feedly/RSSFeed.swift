//
//  RSSFeed.swift
//  Feedly
//
//  Created by João Pedro Leite on 23/10/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import SwiftUI

class RSSFeed: Identifiable {
    var id: Int!
    var url: URL! {
        didSet {
            let result = FeedParser(URL: url).parse()
            
            switch result {
            case .success(let feed):
                self.title = feed.rssFeed?.title
                
                self.description = feed.rssFeed?.description
                
                if let url = feed.rssFeed?.image?.url {
                    Image.downloadImage(from: URL(string: url)!) { (image) in
                        self.image = image
                    }
                }

                for (index, post) in (feed.rssFeed?.items ?? []).enumerated() {
                    let p = FeedPost()
                    p.id = index
                    p.title = post.title
                    p.description = post.description
                    
                    
                    
                    self.posts.append(p)
                }
            case .failure(_):
                break
            }
        }
    }
    var title: String?
    var description: String?
    var posts: [FeedPost] = []
    var image : UIImage?
}

class FeedPost: Identifiable {
    var id: Int!
    var title: String?
    var description: String?
    var image : Image?
}
