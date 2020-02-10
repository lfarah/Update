//
//  PostList.swift
//  Update
//
//  Created by Lucas Farah on 2/9/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI
import Combine
import FeedKit

struct PostList: View {
    var feed: Feed
    
    @ObservedObject var store = RSSStore()
    @State var showingDetail = false
    @State var selectedPost: Post?
    @State var showFilter = false
    @State var filterType = FilterType.unreadOnly
    
    var body: some View {
        VStack(spacing: 16) {
            FilterView(selectedFilter: $filterType, showFilter: $showFilter)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(feed.posts.filter { self.filterType == .unreadOnly ? !$0.isRead : true}) { post in
                        Button(action: {
                            self.selectedPost = post
                            self.showingDetail.toggle()
                            self.store.setPostRead(post: post, feed: self.feed)
                        })  {
                            PostCell(post: post) }.sheet(isPresented: self.$showingDetail) {
                                SafariView(url: self.selectedPost!.url)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationBarItems(trailing:
            HStack {
                
                Button(action: { self.showFilter.toggle() }) {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .foregroundColor(Color(.label))
                        .frame(width: 29.4, height: 25.2)
                        .padding(.all, 8)
                }
                
                Button(action: updatePosts) {
                    Image(systemName: "arrow.2.squarepath")
                        .resizable()
                        .foregroundColor(Color(.label))
                        .frame(width: 29.4, height: 25.2)
                        .padding(.all, 8)
                }
            }
        )
            .navigationBarTitle("Latest posts")
            .background(Color(.systemBackground))
        
    }
    
    func updatePosts() {
        store.update(feedURL: feed.url) { _ in 
        }
    }
}

#if DEBUG
struct PostList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            NavigationView {
                PostList(feed: Feed(name: "Test feed", url: URL(string: "https://www.google.com")!, posts: [Post(title: "Test post title", description: "Test post description", url: URL(string: "https://www.google.com")!)]))
            }.environment(\.colorScheme, .dark)
            
            NavigationView {
                PostList(feed: Feed(name: "Test feed", url: URL(string: "https://www.google.com")!, posts: [Post(title: "Test post title", description: "Test post description", url: URL(string: "https://www.google.com")!)]))
            }.environment(\.colorScheme, .light)
        }
    }
}
#endif
