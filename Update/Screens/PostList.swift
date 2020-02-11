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
    @Binding var feed: FeedObject
    
    @ObservedObject var store = RSSStore.instance
    @State var showingDetail = false
    @State var selectedPost: Post?
    @State var showFilter = false
    @State var filterType = FilterType.unreadOnly
    
    var sortedPosts: [Post] {
        return feed.posts.filter { self.filterType == .unreadOnly ? !$0.isRead : true }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            FilterView(selectedFilter: $filterType, showFilter: $showFilter, markedAllPostsRead: {
                self.store.markAllPostsRead(feed: self.feed)
            })
            
            List {
                ForEach(sortedPosts.indices, id: \.self) { index in
                    Button(action: {
                        self.selectedPost = self.sortedPosts[index]
                        self.showingDetail.toggle()
                        self.store.setPostRead(post: self.sortedPosts[index], feed: self.feed)
                    })  {
                        PostCell(post: self.sortedPosts[index])
                    }
                }
            }
            .sheet(isPresented: self.$showingDetail) {
                SafariView(url: self.selectedPost!.url)
            }
            .padding(.horizontal, 16)
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
        store.reloadFeedPosts(feed: feed)
    }
}

#if DEBUG
struct PostList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            NavigationView {
                PostList(feed: .constant(FeedObject(name: "Test feed", url: URL(string: "https://www.google.com")!, posts: [Post(title: "Test post title", description: "Test post description", url: URL(string: "https://www.google.com")!)])))
            }.environment(\.colorScheme, .dark)
            
            NavigationView {
                PostList(feed: .constant(FeedObject(name: "Test feed", url: URL(string: "https://www.google.com")!, posts: [Post(title: "Test post title", description: "Test post description", url: URL(string: "https://www.google.com")!)])))
            }.environment(\.colorScheme, .light)
        }
    }
}
#endif
