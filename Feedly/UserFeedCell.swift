//
//  UserFeedCell.swift
//  Feedly
//
//  Created by João Pedro Leite on 23/10/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation

struct UserFeedCell : View {
    var feed : RSSFeed
    
    var body: some View {
        List(feed.posts) { post in
            VStack(alignment: .leading, spacing: 5.0) {
                Text(post.title ?? "")
                    .bold()
                
                Text(post.description?.stripOutHtml() ?? "")
                    .foregroundColor(.gray)
            }
        }
        
        .navigationBarTitle(Text(feed.title ?? ""))
    }
}
