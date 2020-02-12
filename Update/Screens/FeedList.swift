//
//  FeedList.swift
//  Update
//
//  Created by Lucas Farah on 2/9/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI
import Combine
import SDWebImageSwiftUI

struct FeedList: View {
    @ObservedObject var store = RSSStore.instance
    @State var showNewFeedPopup = false
    @State var feedURL: String = ""
    @State var feedAddColor: Color = .blue
    @State var attempts: Int = 0
    
    func filterFeeds(url: String?) -> FeedObject? {
        guard let url = url else { return nil }
        return store.feeds.first(where: { $0.url.absoluteString == url })
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(store.feeds.indices, id: \.self) { index in
                        NavigationLink(destination: PostList(feed: self.$store.feeds[index])) {
                            FeedCell(feed: self.store.feeds[index])
                        }
                    }.onDelete { index in
                        self.store.removeFeed(at: index.first!)
                    }
                }
                .navigationBarTitle("Feeds")
                .navigationBarItems(leading: EditButton(), trailing: Button(action: openNewFeed) {
                    Text("New Feed")
                })
                    .sheet(isPresented: self.$store.shouldSelectFeed) {
                        NavigationView {
                            PostList(feed: Binding(self.$store.shouldSelectFeedObject)!)
                                .navigationBarItems(leading:
                                    Button(action: {
                                        self.store.shouldSelectFeed = false
                                    }, label: {
                                        Text("Close")
                                    })
                            )
                        }
                        .navigationViewStyle(StackNavigationViewStyle())
                }
                NewFeedPopup(feedURL: $feedURL, addFeedPressed: addFeed, feedAddColor: $feedAddColor, attempts: $attempts, show: $showNewFeedPopup)
            }
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
    
    func openNewFeed() {
        showNewFeedPopup.toggle()
    }
    
    func addFeed() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        guard let url = URL(string: feedURL) else { return }
        
        store.addFeed(feedURL: url) { success in
            self.feedAddColor = success ? Color.green : Color.red
            
            if success {
                self.showNewFeedPopup = false
            } else {
                self.attempts += 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.feedAddColor = .blue
            }
        }
    }
}

let screen = UIScreen.main.bounds

struct Shake: GeometryEffect {
    var amount: CGFloat = 5
    var shakesPerUnit = 6
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                              y: 0))
    }
}
struct FeedList_Previews: PreviewProvider {
    static var previews: some View {
        FeedList().environment(\.colorScheme, .dark)
    }
}
