//
//  RSSStore.swift
//  Update
//
//  Created by Lucas Farah on 2/9/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI
import FeedKit
import FaviconFinder
import Combine
import BackgroundTasks

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
        lastUpdateDate = Date()
        
        switch feed {
        case .rss(let rssFeed):
            self.name =  rssFeed.title ?? ""
            
            let items = rssFeed.items ?? []
            self.posts = items
                .compactMap { Post(feedItem: $0) }
                .sorted(by: { (lhs, rhs) -> Bool in
                    return Calendar.current.compare(lhs.date, to: rhs.date, toGranularity: .minute) == ComparisonResult.orderedDescending
                })
            
            if let urlStr = rssFeed.image?.url, let url = URL(string: urlStr) {
                self.imageURL = url
            } else {
                FaviconFinder(url: URL(string: rssFeed.link ?? "")!).downloadFavicon { (_, url, error) in
                    self.imageURL = url
                }
            }
            
        case .atom(let atomFeed):
            self.name =  atomFeed.title ?? ""
            
            let items = atomFeed.entries ?? []
            self.posts = items
                .compactMap { Post(atomFeed: $0) }
                .sorted(by: { (lhs, rhs) -> Bool in
                    return Calendar.current.compare(lhs.date, to: rhs.date,     toGranularity: .minute) ==  ComparisonResult.orderedDescending
                })
            
            if let urlStr = atomFeed.logo, let url = URL(string: urlStr) {
                self.imageURL = url
            } else {
                FaviconFinder(url: URL(string: atomFeed.links?.first?.attributes?.href ?? "")!).downloadFavicon { (_, url, error) in
                    self.imageURL = url
                }
            }
        default:
            return nil
        }
        
    }
    
    init(name: String, url: URL, posts: [Post]) {
        self.name = name
        self.url = url
        self.posts = posts
        lastUpdateDate = Date()
    }
    
    static var testObject: FeedObject {
        return FeedObject(name: "Test feed",
        url: URL(string: "https://www.google.com")!,
        posts: [Post.testObject])
    }
}

class Post: Codable, Identifiable, ObservableObject {
    let id = UUID()
    var title: String
    var description: String
    var url: URL
    var date: Date
    
    var isRead: Bool {
        return readDate != nil
    }
    
    var readDate: Date? {
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
    
    static var testObject: Post {
        return Post(title: "Test post title",
        description: "Test post description",
        url: URL(string: "https://www.google.com")!)
    }
}

enum ContentTimeType: String, CaseIterable {
    case minute60 = "1 hour"
    case minute120 = "2 hours"
    case hour12 = "12 hours"
    case hour24 = "1 day"

    var seconds: Int {
        switch self {
            
        case .minute60:
            return 60 * 60
        case .minute120:
            return 120 * 60
        case .hour12:
            return 12 * 60 * 60
        case .hour24:
            return 24 * 60 * 60
        }
    }
}

class RSSStore: ObservableObject {
    
    static let instance = RSSStore()
    
    @Published var feeds: [FeedObject] = []
    @Published var shouldSelectFeedURL: String?
    @Published var shouldOpenSettings: Bool = false
    @Published var notificationsEnabled: Bool = false
    @Published var fetchContentTime: String = ContentTimeType.minute60.rawValue
    @Published var fetchContentType: ContentTimeType = .minute60
    @Published var totalUnreadPosts: Int = 0
    @Published var totalReadPostsToday: Int = 0
    @Published var shouldReload = false

    var notificationSubscriber: AnyCancellable?
    var notificationSubscriber2: AnyCancellable?
    var fetchContentTimeSubscriber: AnyCancellable?
    var fetchContentTimeSubscriber2: AnyCancellable?
    var postReadCount: AnyCancellable?
    var postReadCount2: AnyCancellable?

    var cancellables = Set<AnyCancellable>()

    init() {
        self.feeds = UserDefaults.feeds
        // TODO: Fix this rx. I know I am making someone's eyes bleed right now, but I wanna get some basic functionality done before I clean up the code
        
        fetchContentTime = UserDefaults.fetchContentTime.rawValue
        
        fetchContentTimeSubscriber = $fetchContentTime
            .receive(on: DispatchQueue.main)
            .map { (fetchString) -> ContentTimeType in
                return ContentTimeType(rawValue: fetchString) ?? .minute60
            }
            .assign(to: \.fetchContentType, on: self)
        
        fetchContentTimeSubscriber2 = $fetchContentType
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { (type) in
                UserDefaults.fetchContentTime = type
            })
        
        postReadCount = $feeds
            .receive(on: DispatchQueue.main)
            .map { (newValue) -> Int in
                return newValue.map({ (feed) -> Int in
                    return feed.posts.filter { (post) -> Bool in
                        guard let readDate = post.readDate else { return false }
                        return Calendar.current.isDateInToday(readDate)
                    }.count
                }).reduce(0, +)
            }
        .sink(receiveValue: { (newValue) in
            self.totalReadPostsToday = newValue
        })

        postReadCount2 = $feeds
            .receive(on: DispatchQueue.main)
            .map { (newValue) -> Int in
                return newValue.map({ (feed) -> Int in
                    return feed.posts.filter { $0.readDate == nil }.count
                }).reduce(0, +)
            }
            .sink(receiveValue: { (newValue) in
                self.totalUnreadPosts = newValue
            })

        $notificationsEnabled
        .receive(on: DispatchQueue.main)
        .removeDuplicates()
            .filter { $0 }
            .sink { (newValue) in
                Notifier.requestAuthorization { (isAccepted) in

                }
            }
        .store(in: &cancellables)
    }
    
    func refreshExtensionFeeds() {
        print("New feeds (\(UserDefaults.newFeedsToAdd)")
        for feed in UserDefaults.newFeedsToAdd {
            addFeed(feedURL: feed) { (success) in
                print("New feed (\(feed.absoluteString): \(success)")
            }
        }
        UserDefaults.newFeedsToAdd = []
    }
    
    func addFeedFromExtension(url: URL) {
        UserDefaults.newFeedsToAdd = UserDefaults.newFeedsToAdd + [url]
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
                handler(nil)
                print(error)
            }
        }
    }
        
    func updateFeeds() {
        UserDefaults.feeds = self.feeds
    }
}

// MARK: - Notifications
extension RSSStore {
    func scheduleNewPostNotification(for feed: FeedObject) {
        Notifier.notify(title: "New post from \(feed.name)", body: feed.posts.first?.title ?? "", info: ["feedURL": feed.url.absoluteString])

    }
}

// MARK: - Public Methods
extension RSSStore {
    
    func reloadAllPosts(handler: (() -> Void)? = nil) {
        var updatedCount = 0
        for feed in self.feeds {
            print("RELOADING POST")

            reloadFeedPosts(feed: feed) { success in
                print("GOT POST")

                updatedCount += 1
                if updatedCount >= self.feeds.count {
                    handler?()
                }
            }
        }
    }
    
    func reloadFeedPosts(feed: FeedObject, handler: ((_ success: Bool) -> Void)? = nil) {
        
        fetchContents(feedURL: feed.url) { (feedObject) in
            
            guard let feedObject = feedObject,
                let newFeed = FeedObject(feed: feedObject, url: feed.url) else { return }
            let recentFeedPosts = newFeed.posts.filter { newPost in
                return !feed.posts.contains { (post) -> Bool in
                    return post.title == newPost.title
                }
            }
            
            guard !recentFeedPosts.isEmpty else {
                handler?(true)
                return
            }
            
            feed.posts.insert(contentsOf: recentFeedPosts, at: 0)
            
//            if let index = self.feeds.firstIndex(where: {$0.url.absoluteString == feed.url.absoluteString}) {
//                self.feeds.remove(at: index)
//                self.feeds.insert(feed, at: index)
//            }
            
            self.updateFeeds()
            self.scheduleNewPostNotification(for: feed)
            handler?(true)
        }
    }
        
    func update(feedURL: URL, handler: @escaping (_ success: Bool) -> Void) {
        
        fetchContents(feedURL: feedURL) { (feedObject) in
            
            guard let feedObject = feedObject,
                let feed = FeedObject(feed: feedObject, url: feedURL) else {
                    handler(false)
                    return
                }
            self.feeds.append(feed)
            
            self.updateFeeds()
            handler(true)
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
        post.readDate = Date()
        feed.objectWillChange.send()
//        totalUnreadPosts -= 1
//        totalReadPostsToday += 1
//        if let index = feed.posts.firstIndex(where: {$0.url.absoluteString == post.url.absoluteString}) {
//            feed.posts.remove(at: index)
//            feed.posts.insert(post, at: index)
//        }
//
//        if let index = self.feeds.firstIndex(where: {$0.url.absoluteString == feed.url.absoluteString}) {
//            self.feeds.remove(at: index)
//            self.feeds.insert(feed, at: index)
//        }
        
        self.updateFeeds()
    }
    
    func addFeed(feedURL: URL, handler: @escaping (_ success: Bool) -> Void) {
        if self.feeds.contains(where: {$0.url == feedURL }) {
            handler(false)
            return
        }
        
        update(feedURL: feedURL, handler: handler)
    }
    
    func totalReadPosts(in date: Date) -> Int {
        let allPosts = feeds.map { $0.posts }.reduce([], +)
        
        return allPosts.filter { (post) -> Bool in
            guard  let readDate = post.readDate else {
                return false
            }
            return Calendar.current.isDate(readDate, inSameDayAs: date)
        }.count
    }
}
