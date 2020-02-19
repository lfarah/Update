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
    @Published var shouldOpenSettings = false
    @Published var feedURL: String = ""
    @Published var feedAddColor: Color = Color.backgroundNeo
    @Published var attempts: Int = 0

    private var cancellable: AnyCancellable? = nil
    private var cancellable2: AnyCancellable? = nil
    private var cancellable3: AnyCancellable? = nil

    public init() {
        fetchInfo()
    }
    
    func fetchInfo() {
        
        
        cancellable = store.$feeds
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { (newValue) in
                self.feeds = newValue
            })
        
        cancellable2 = store.$shouldSelectFeed
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { (newValue) in
                self.shouldSelectFeed = newValue
            })

        cancellable3 = store.$shouldOpenSettings
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { (newValue) in
                self.shouldOpenSettings = newValue
            })

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
    
    var settingsView: SettingsView {
        return SettingsView(fetchContentTime: self.$store.fetchContentTime, notificationsEnabled: self.$store.notificationsEnabled, shouldOpenSettings: self.$store.shouldOpenSettings)
    }
}
