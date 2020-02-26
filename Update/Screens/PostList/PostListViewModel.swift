//
//  PostListViewModel.swift
//  Update
//
//  Created by Lucas Farah on 2/18/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

public class PostListViewModel: ObservableObject {
    
    @ObservedObject var store = RSSStore.instance
    @Published var feed: FeedObject
    @Published var filteredPosts: [Post] = []
    @Published var filterType = FilterType.unreadOnly
    @Published var selectedPost: Post?
    @Published var showingDetail = false
    @Published var shouldReload = false
    @Published var showFilter = false
    
    private var cancellable: AnyCancellable? = nil
    private var cancellable2: AnyCancellable? = nil
    
    init(feed: FeedObject) {
        self.feed = feed
        self.filteredPosts = feed.posts.filter { self.filterType == .unreadOnly ? !$0.isRead : true }

        cancellable = Publishers.CombineLatest3(self.$feed, self.$filterType, self.$shouldReload)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { (newValue) in
                self.filteredPosts = newValue.0.posts.filter { newValue.1 == .unreadOnly ? !$0.isRead : true }
            })
    }
    
    func markAllPostsRead() {
        self.store.markAllPostsRead(feed: self.feed)
        shouldReload = true
    }
    
    func markPostRead(index: Int) {
        self.store.setPostRead(post: self.filteredPosts[index], feed: self.feed)
        shouldReload = true
    }
    
    func reloadPosts() {
        store.reloadFeedPosts(feed: feed)
    }
    
    func selectPost(index: Int) {
        self.selectedPost = self.filteredPosts[index]
        self.showingDetail.toggle()
        self.markPostRead(index: index)
    }
}
