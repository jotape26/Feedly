//
//  UserFeedCell.swift
//  Feedly
//
//  Created by João Pedro Leite on 23/10/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import SwiftUI

struct UserFeedCell : View {
    var feed : RSSFeed
    
    var body: some View {
        
        List {
            ForEach(feed.posts, id: \.self) { post in
                
                NavigationLink(destination: FeedContentView(selectedNews: post)) {
                    VStack(alignment: .leading, spacing: 5.0) {
                        Text(post.title)
                            .bold()
                        
                        Text(post.author)
                        Text(post.postDate?.printAsString() ?? "")
                    }
                }
            }
        }
        .navigationBarTitle(Text(feed.title))
    }
}
