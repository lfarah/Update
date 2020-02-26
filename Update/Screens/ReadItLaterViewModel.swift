//
//  ReadItLaterViewModel.swift
//  Update
//
//  Created by Lucas Farah on 2/25/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

public class ReadItLaterViewModel: ObservableObject {
    @ObservedObject var store = ReadItLaterStore.instance
    
    @Published var items: [ReadItLaterItem] = []
    @Published var showNewFeedPopup = false
    @Published var feedURL: String = ""
    @Published var feedAddColor: Color = Color.backgroundNeo
    @Published var attempts: Int = 0
    @Published var showingDetail = false
    @Published var selectedItem: ReadItLaterItem?
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        
        store.$items
            .receive(on: DispatchQueue.main)
            .sink { (newValue) in
                self.items = newValue
        }
        .store(in: &cancellables)
    }
    
    func addLink() {
        guard let urlObject = URL(string: self.feedURL) else { return }
        
        store.addItem(url: urlObject)
        showNewFeedPopup = false
    }
    
    func selectItem(index: Int) {
        let item = items[index]
        selectedItem = item
        
        // If it is a twitter status link, open in Twitter
        if item.link.absoluteString.contains("twitter.com"),
            item.link.absoluteString.contains("status/"),
            let url = convertTwitterLink(url: item.link),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // Else, open in WebView
            showingDetail = true
        }
        store.removeItem(item: item)
    }
    
    func convertTwitterLink(url: URL) -> URL? {
        if let cleanString = url.absoluteString.components(separatedBy: "status/").last?.components(separatedBy: "?").first {
            return URL(string: "twitter://status?id=\(cleanString)") ?? nil
        } else {
            return url
        }
    }
}
