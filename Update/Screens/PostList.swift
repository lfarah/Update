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

    @EnvironmentObject var store: RSSStore
    @State var showingDetail = false
    @State var selectedPost: Post?
    @State var showFilter = false
    @State var filterType = FilterType.unreadOnly
    @Environment(\.presentationMode) var presentationMode

    var sortedPosts: [Post] {
        return feed.posts.filter { self.filterType == .unreadOnly ? !$0.isRead : true }
    }
    
    var body: some View {
        ZStack {
            Color.backgroundNeo
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            List {
                FilterView(selectedFilter: $filterType, showFilter: $showFilter, markedAllPostsRead: {
                    self.store.markAllPostsRead(feed: self.feed)
                }).listRowBackground(Color.backgroundNeo)
                
                ForEach(sortedPosts.indices, id: \.self) { index in
                    Button(action: {
                        self.selectedPost = self.sortedPosts[index]
                        self.showingDetail.toggle()
                        self.store.setPostRead(post: self.sortedPosts[index], feed: self.feed)
                    })  {
                        PostCell(post: self.sortedPosts[index])
                    }.listRowBackground(Color.backgroundNeo)
                }
            }
            .background(Color.clear)
            .padding(.top, 150)
            .sheet(isPresented: self.$showingDetail) {
                SafariView(url: self.selectedPost!.url)
            }
            
            NavBar(title: "Latest posts",
                   updatePosts: updatePosts,
                   goBack: goBack,
                   showNewFeedPopup: .constant(false),
                   showFilter: $showFilter,
                   buttons: [.filter, .reload])
            
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
    
    func goBack() {
        presentationMode.wrappedValue.dismiss()
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
                PostList(feed: .constant(FeedObject(name: "Test feed", url: URL(string: "https://www.google.com")!, posts: [Post(title: "Test post title", description: "Test post description", url: URL(string: "https://www.google.com")!)]))).environmentObject(RSSStore.instance)
            }.environment(\.colorScheme, .dark)
            
            NavigationView {
                PostList(feed: .constant(FeedObject(name: "Test feed", url: URL(string: "https://www.google.com")!, posts: [Post(title: "Test post title", description: "Test post description", url: URL(string: "https://www.google.com")!)]))).environmentObject(RSSStore.instance)
            }.environment(\.colorScheme, .light)
        }
    }
}
#endif
