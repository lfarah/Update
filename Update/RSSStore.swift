//
//  RSSStore.swift
//  Update
//
//  Created by Lucas Farah on 2/9/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI
import FeedKit

class Feed: Codable, Identifiable {
    let id = UUID()
    var name: String
    var url: URL
    var posts: [Post]
    var imageURL: URL?

    init?(feed: RSSFeed) {
        self.name =  feed.title ?? ""
        if let link = feed.link, let url = URL(string: link) {
            self.url = url
        } else {
            return nil
        }
        
        let items = feed.items ?? []
        self.posts = items.compactMap { Post(feedItem: $0) }
        
        if let urlStr = feed.image?.url, let url = URL(string: urlStr) {
            self.imageURL = url
        }
    }
    
    init(name: String, url: URL, posts: [Post]) {
        self.name = name
        self.url = url
        self.posts = posts
    }

}

class Post: Codable, Identifiable, ObservableObject {
    let id = UUID()
    var title: String
    var description: String
    var url: URL
    var date: Date
    var isRead: Bool = false {
        didSet {
            objectWillChange.send()
        }
    }

    init?(feedItem: RSSFeedItem) {
        self.title =  feedItem.title ?? ""
        self.description = feedItem.description ?? ""
        
        if let link = feedItem.link, let url = URL(string: link) {
            self.url = url
        } else {
            return nil
        }
        self.date = feedItem.pubDate ?? Date()
    }
    
    init(title: String, description: String, url: URL) {
        self.title = title
        self.description = description
        self.url = url
        self.date = Date()
    }
}

class RSSStore: ObservableObject {
    
    @Published var feeds: [Feed] = []

    init() {
        self.feeds = UserDefaults.feeds
    }
            
    func fetchContents(feedURL: URL, handler: @escaping (_ feed: RSSFeed?) -> Void) {
        let parser = FeedParser(URL: feedURL)

        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in

            switch result {
                
            case .success(let feed):
                DispatchQueue.main.async {
                    handler(feed.rssFeed)
                }
            case .failure(let error):
                    print(error)
            }
        }
    }
    
    func updateFeeds() {
        UserDefaults.feeds = self.feeds
    }
}

// MARK: - Public Methods
extension RSSStore {
    
    func update(feedURL: URL, handler: @escaping (_ success: Bool) -> Void) {
        
        fetchContents(feedURL: feedURL) { (feedObject) in
            handler(true)

            guard let feedObject = feedObject,
                let feed = Feed(feed: feedObject) else { return }
            self.feeds.append(feed)
            
            self.updateFeeds()
        }
    }

    func removeFeed(at index: Int) {
        feeds.remove(at: index)
        updateFeeds()
    }
    
    func setPostRead(post: Post, feed: Feed) {
        post.isRead = true
        if let index = feed.posts.firstIndex(where: {$0.url.absoluteString == post.url.absoluteString}) {
            feed.posts.remove(at: index)
            feed.posts.insert(post, at: index)
        }
        
        if let index = self.feeds.firstIndex(where: {$0.url.absoluteString == feed.url.absoluteString}) {
            self.feeds.remove(at: index)
            self.feeds.insert(feed, at: index)
        }
        
        self.updateFeeds()
    }
    
    func addFeed(feedURL: URL, handler: @escaping (_ success: Bool) -> Void) {
        if self.feeds.contains(where: {$0.url == feedURL }) {
            handler(false)
            return
        }
        
        update(feedURL: feedURL, handler: handler)
    }

}
