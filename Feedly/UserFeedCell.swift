//
//  UserFeedCell.swift
//  Feedly
//
//  Created by João Pedro Leite on 23/10/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import SwiftUI
import WebKit

struct UserFeedCell : View {
    var feed : RSSFeed
    
    var body: some View {
        List(feed.posts) { (post : FeedPost) in
            VStack(alignment: .leading, spacing: 5.0) {
                Text(post.title)
                    .bold()
                
                Text(post.author)
                Text(post.postDate?.printAsString() ?? "")
            }
            .onTapGesture {
                if let url = URL(string: post.link) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        
        .navigationBarTitle(Text(feed.title ?? ""))
    }
}

struct WebView : UIViewRepresentable {
      
    let htmlString: String
      
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
      
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlString, baseURL: nil)
    }
      
}
  
#if DEBUG
struct WebView_Previews : PreviewProvider {
    static var previews: some View {
        WebView(htmlString: "<h1>Hello World!</h1>")
    }
}
#endif
