//
//  RSSFeed.swift
//  Feedly
//
//  Created by João Pedro Leite on 23/10/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import SwiftUI
import FeedKit
import RealmSwift

class UserSession: Object {
    static let instance = {
        return UserSession()
    }()
    
    fileprivate let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("feeds.plist")
    
    @objc dynamic var userFeeds : [RSSFeed] {
        get {
            let uiRealm = try! Realm()
            let feeds = uiRealm.objects(RSSFeed.self)
            
            feeds.forEach { (feed) in
                feed.downloadImage(url: URL(string: feed.imageURLString)!)
            }
            return feeds.reversed().reversed()
        }
        set {
            let uiRealm = try! Realm()
            
            do {
                try uiRealm.write {
                    uiRealm.add(newValue)
                }
            } catch {
                print("erro salvando")
            }
        }
    }
}

class RSSFeed: Object, Identifiable {

    @objc dynamic var id = 0
    @objc dynamic var title: String = ""
    @objc dynamic var feedDescription = ""
    @objc dynamic var urlString = "" {
        didSet {
            if let url = URL(string: urlString) {
                self.url = url
            }
        }
    }
    
    @objc dynamic var imageURLString = "" {
        didSet {
            if let url = URL(string: imageURLString) {
                downloadImage(url: url)
            }
        }
    }
    var posts = RealmSwift.List<FeedPost>()
    
    override static func ignoredProperties() -> [String] {
      return ["url"]
    }
    
    func downloadImage(url : URL) {
        Image.downloadImage(from: url) { (image) in
            self.image = image
        }
    }
    
    @State var image : UIImage?
    
    @objc dynamic var url: URL! {
        didSet {
            let result = FeedParser(URL: url).parse()
            
            switch result {
            case .success(let feed):
                self.title = feed.rssFeed?.title ?? ""
                self.feedDescription = feed.rssFeed?.description ?? ""
                self.imageURLString = feed.rssFeed?.image?.url ?? ""
                
                for (index, post) in (feed.rssFeed?.items ?? []).enumerated() {
                    let p = FeedPost()
                    p.id = index
                    p.title = post.title ?? ""
                    p.postDescription = post.description ?? ""
                    p.postDate = post.pubDate
                    p.author = post.author ?? ""
                    p.link = post.link ?? ""
                    self.posts.append(p)
                }
            case .failure(_):
                if let index = UserSession.instance.userFeeds.firstIndex(of: self) {
                    UserSession.instance.userFeeds.remove(at: index)
                    
                    //HANDLE ERROR
                    print("failed to download feed")
                }
                break
            }
        }
    }
}

class FeedPost: Object, Identifiable {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var author : String = ""
    @objc dynamic var link : String = ""
    @objc dynamic var postDescription: String = ""
    @objc dynamic var postDate : Date?
}
