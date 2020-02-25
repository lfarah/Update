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
        selectedItem = items[index]
        showingDetail = true
        store.removeItem(item: items[index])
    }
}
