//
//  FeedListViewModel.swift
//  Update
//
//  Created by Lucas Farah on 2/18/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

public class FeedListViewModel: ObservableObject {
    @ObservedObject var store = RSSStore.instance
    
    @Published var feeds: [FeedObject] = []
    @Published var showNewFeedPopup = false
    @Published var shouldSelectFeed = false
    @Published var shouldSelectFeedObject: FeedObject?
    
    @Published var shouldOpenSettings = false
    @Published var feedURL: String = ""
    @Published var feedAddColor: Color = Color.backgroundNeo
    @Published var attempts: Int = 0
    @Published var shouldPresentDetail = false
    
    var cancellables = Set<AnyCancellable>()
    
    public init() {
        fetchInfo()
    }
    
    func fetchInfo() {
        
        store.$feeds
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { (newValue) in
                self.feeds = newValue
            })
            .store(in: &cancellables)
        
        Publishers.CombineLatest(store.$shouldSelectFeedURL, store.$shouldOpenSettings)
            .receive(on: DispatchQueue.main)
            .map { (newValue) -> (FeedObject?, Bool) in
                guard let url = newValue.0 else {
                    return (nil, newValue.1)
                }
                return (self.feeds.first(where: {$0.url.absoluteString == url }), newValue.1)
            }
            .removeDuplicates(by: { (lhs, rhs) -> Bool in
                return lhs.0?.url.absoluteURL != rhs.0?.url.absoluteURL && lhs.1 != rhs.1
            })
            .sink(receiveValue: { (newValue) in
                self.shouldSelectFeedObject = newValue.0
                self.shouldSelectFeed = newValue.0 != nil
                self.shouldOpenSettings = newValue.1
                self.shouldPresentDetail = self.shouldSelectFeed || self.shouldOpenSettings
                print("present∂etail: \(self.shouldPresentDetail)")
                self.objectWillChange.send()
            })
            .store(in: &cancellables)
    }
    
    func addFeed(url: String) {
        guard let url = URL(string: url) else {
            self.attempts += 1
            self.feedAddColor = Color.red
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.feedAddColor = Color.backgroundNeo
            }
            return
        }
        
        store.addFeed(feedURL: url) { success in
            self.feedAddColor = success ? Color.green : Color.red
            
            if success {
                self.feedURL = ""
                self.showNewFeedPopup = false
            } else {
                self.attempts += 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.feedAddColor = Color.backgroundNeo
            }
        }
    }
    
    func removeFeed(index: Int) {
        self.store.removeFeed(at: index)
    }
    
    var detailPage: AnyView {
        if shouldOpenSettings {
            return AnyView(SettingsView(fetchContentTime: self.$store.fetchContentTime, notificationsEnabled: self.$store.notificationsEnabled, shouldOpenSettings: self.$store.shouldOpenSettings))
        } else {
            return AnyView(
                NavigationView {
                    PostList(viewModel: PostListViewModel(feed: self.shouldSelectFeedObject!), tappedClose: {
                        self.store.shouldSelectFeedURL = nil
                    }).environmentObject(self.store)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .navigationBarTitle("")
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
            )
        }
    }
}
