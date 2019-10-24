//
//  RSSFeed.swift
//  Feedly
//
//  Created by João Pedro Leite on 23/10/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import SwiftUI
import FeedKit

class UserSession {
    static let instance = {
        return UserSession()
    }()
    
    fileprivate let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("feeds.plist")
    
    var userFeeds : [RSSFeed] {
        get {
            var feeds = [RSSFeed]()
            if let urls = UserDefaults.standard.array(forKey: "userFeedsURLs") as? [String] {
                for (index, url) in urls.enumerated() {
                    if let url = URL(string: url) {
                        let feed = RSSFeed()
                        feed.id = index
                        feed.url = url
                        feeds.append(feed)
                    }
                }
            }
            return feeds
        }
        set {
            
            let urls = newValue.map { (feeeed) -> String in
                return feeeed.url.description
            }.filter({ (url) -> Bool in
                return url != ""
            })

            UserDefaults.standard.set(urls, forKey: "userFeedsURLs")
        }
    }
}

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
                    p.title = post.title ?? ""
                    p.description = post.description ?? ""
                    p.postDate = post.pubDate
                    p.author = post.author ?? ""
                    p.link = post.link ?? ""
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
    var id: Int = 0
    var title: String = ""
    var author : String = ""
    var link : String = ""
    var description: String = ""
    var postDate : Date?
}
