//
//  UserFeedsListView.swift
//  Feedly
//
//  Created by João Pedro Leite on 18/10/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import SwiftUI
import FeedKit

struct UserFeedsListView: View {
    
    @State var userFeeds : [RSSFeed] = []
    
    func addFeed() {
        let alert = UIAlertController(title: "Adicionar Feed", message: "Digite a URL do feed:", preferredStyle: .alert)

        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Adicionar", style: .default, handler: { _ in
            
            guard let urlString = alert.textFields?.first?.text,
                let url = URL(string: urlString) else { return }
            
            let f = RSSFeed()
            f.id = self.userFeeds.count + 1
            f.url = url

            self.userFeeds.append(f)
        }))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
    
    var body: some View {
        NavigationView {
            
            List(userFeeds) { feed in
                NavigationLink(destination: UserFeedCell(feed: feed)) {
                    HStack {
                        Image(uiImage: feed.image ?? UIImage())
                            .frame(width: 50.0, height: 50.0, alignment: .leading)
                            .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                        
                        VStack(alignment: .leading) {
                            Text(feed.title ?? "")
                            Text(feed.description ?? "")
                        }
                    }
                }
            }

            .navigationBarTitle(Text("Feeds"))
            .navigationBarItems(trailing:
                
                Button(action: {
                    self.addFeed()
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.orange)
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UserFeedsListView()
    }
}
