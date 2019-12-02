//
//  FeedContentView.swift
//  Feedly
//
//  Created by João Pedro Leite on 28/10/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import SwiftUI
import WebKit

struct FeedContentView : View {
    var selectedNews : FeedPost
    var body: some View {
        VStack {
            Text(selectedNews.title)
            WebView(htmlString: selectedNews.postDescription)
        }
    }
}

struct ContentView_FeedContentView: PreviewProvider {
    static var previews: some View {
        FeedContentView(selectedNews: FeedPost())
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
