//
//  UserFeedsListView.swift
//  Feedly
//
//  Created by João Pedro Leite on 18/10/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import SwiftUI

struct UserFeedsListView: View {
    
    @State var userFeeds : [RSSFeed] = UserSession.instance.userFeeds {
        didSet {
            UserSession.instance.userFeeds = userFeeds
        }
    }
    
    func addFeed() {
        let alert = UIAlertController(title: "Adicionar Feed", message: "Digite a URL do feed:", preferredStyle: .alert)
        alert.view.tintColor = UIColor.orange
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Adicionar", style: .default, handler: { _ in
            
            
            
            guard let urlString = alert.textFields?.first?.text,
            let _ = URL(string: urlString) else {
                print("invalid url")
                return
            }
            
            guard !self.userFeeds.contains(where: { (savedFeed) -> Bool in
                return savedFeed.urlString == urlString
            }) else {
                //HANDLE ERROR
                print("duplicated feed")
                return
            }
            
            let f = RSSFeed()
            f.id = self.userFeeds.count + 1
            f.urlString = urlString

            self.userFeeds.append(f)
        }))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
    
    var body: some View {
        NavigationView {
            List(userFeeds) { (feed : RSSFeed) in
                NavigationLink(destination: UserFeedCell(feed: feed)) {
                    HStack {
                        Image(uiImage: feed.image ?? UIImage(named: "rss-icon")!)
                            .resizable()
                            .frame(width: 50.0, height: 50.0, alignment: .center)
                            .aspectRatio(contentMode: .fit)
                        
                        VStack(alignment: .leading, spacing: 10.0) {
                            Text(feed.title)
                                .bold()
                            Text(feed.feedDescription)
                        }
                    }
                }
            }
                
            .navigationBarTitle(Text("Feeds"))
            .navigationBarItems(leading:
                
                Button(action: {
                    self.addFeed()
                }) {
                    Image("profile-icon")
                        .foregroundColor(.orange)
                },
                                trailing: Button(action: {
                                    self.addFeed()
                                }) {
                                    Image(systemName: "plus")
                                        .foregroundColor(.orange)
                }
            )
        }.accentColor(.orange)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UserFeedsListView()
    }
}
