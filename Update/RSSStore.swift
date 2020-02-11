//
//  RSSStore.swift
//  Update
//
//  Created by Lucas Farah on 2/9/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI
import FeedKit

class FeedObject: Codable, Identifiable, ObservableObject {
    let id = UUID()
    var name: String
    var url: URL
    var posts: [Post] {
        didSet {
            objectWillChange.send()
        }
    }
    
    var imageURL: URL?
    var lastUpdateDate: Date
    
    init?(feed: Feed, url: URL) {
        self.url = url

        switch feed {
        case .rss(let rssFeed):
            self.name =  rssFeed.title ?? ""
            
            let items = rssFeed.items ?? []
            self.posts = items.compactMap { Post(feedItem: $0) }
            
            if let urlStr = rssFeed.image?.url, let url = URL(string: urlStr) {
                self.imageURL = url
            }
        case .atom(let atomFeed):
            self.name =  atomFeed.title ?? ""
            
            let items = atomFeed.entries ?? []
            self.posts = items.compactMap { Post(atomFeed: $0) }
            
            if let urlStr = atomFeed.logo, let url = URL(string: urlStr) {
                self.imageURL = url
            }
        default:
            return nil
        }
        
        lastUpdateDate = Date()
    }
        
    init(name: String, url: URL, posts: [Post]) {
        self.name = name
        self.url = url
        self.posts = posts
        lastUpdateDate = Date()
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
    
    var lastUpdateDate: Date

    init?(feedItem: RSSFeedItem) {
        self.title =  feedItem.title ?? ""
        self.description = feedItem.description ?? ""
        
        if let link = feedItem.link, let url = URL(string: link) {
            self.url = url
        } else {
            return nil
        }
        self.date = feedItem.pubDate ?? Date()
        lastUpdateDate = Date()
    }
    
    init?(atomFeed: AtomFeedEntry) {
        self.title =  atomFeed.title ?? ""
        let description = atomFeed.content?.value ?? ""
        
        let attributed = try? NSAttributedString(data: description.data(using: .unicode)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        self.description = attributed?.string ?? ""
        
        if let link = atomFeed.links?.first?.attributes?.href, let url = URL(string: link) {
            self.url = url
        } else {
            return nil
        }
        self.date = atomFeed.updated ?? Date()
        lastUpdateDate = Date()
    }

    init(title: String, description: String, url: URL) {
        self.title = title
        self.description = description
        self.url = url
        self.date = Date()
        lastUpdateDate = Date()
    }
}

class RSSStore: ObservableObject {
    
    static let instance = RSSStore()
    
    @Published var feeds: [FeedObject] = []

    init() {
        self.feeds = UserDefaults.feeds
    }
            
    func fetchContents(feedURL: URL, handler: @escaping (_ feed: Feed?) -> Void) {
        let parser = FeedParser(URL: feedURL)

        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in

            switch result {
                
            case .success(let feed):
                DispatchQueue.main.async {
                    handler(feed)
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
    
    func reloadAllPosts() {
        for feed in self.feeds {
            reloadFeedPosts(feed: feed)
        }
    }
    
    func reloadFeedPosts(feed: FeedObject) {
        
        fetchContents(feedURL: feed.url) { (feedObject) in

            guard let feedObject = feedObject,
                let newFeed = FeedObject(feed: feedObject, url: feed.url) else { return }
            let recentFeedPosts = newFeed.posts.filter { newPost in
                return !feed.posts.contains { (post) -> Bool in
                    return post.title == newPost.title
                }
            }
            
            feed.posts.insert(contentsOf: recentFeedPosts, at: 0)
            
            if let index = self.feeds.firstIndex(where: {$0.url.absoluteString == feed.url.absoluteString}) {
                self.feeds.remove(at: index)
                self.feeds.insert(feed, at: index)
            }

            self.updateFeeds()
        }
    }
    func update(feedURL: URL, handler: @escaping (_ success: Bool) -> Void) {
        
        fetchContents(feedURL: feedURL) { (feedObject) in
            handler(true)

            guard let feedObject = feedObject,
                let feed = FeedObject(feed: feedObject, url: feedURL) else { return }
            self.feeds.append(feed)
            
            self.updateFeeds()
        }
    }

    func removeFeed(at index: Int) {
        feeds.remove(at: index)
        updateFeeds()
    }
    
    func markAllPostsRead(feed: FeedObject) {
        feed.posts.forEach { (post) in
            setPostRead(post: post, feed: feed)
        }
    }
    
    func setPostRead(post: Post, feed: FeedObject) {
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
