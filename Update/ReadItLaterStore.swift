//
//  ReadItLaterStore.swift
//  Update
//
//  Created by Lucas Farah on 2/25/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

struct ReadItLaterItem: Identifiable, Codable {
    var id = UUID()
    
    var link: URL
    var title: String?
    var description: String?
    var imageURL: URL?
    
    static var testObject: ReadItLaterItem {
        return ReadItLaterItem(
            link: URL(string: "https://www.swiftbysundell.com/articles/what-makes-code-swifty/")!,
            title: "What makes code Swifty",
            description: "Although programming languages are formally defined by their syntax, the ways in which they get used in practice are arguably just as much determined by their current conventions",
            imageURL: URL(string: "https://www.swiftbysundell.com/images/favicon.png"))
    }
}

class ReadItLaterStore: ObservableObject {
    
    static let instance = ReadItLaterStore()
    
    @Published var items: [ReadItLaterItem] = []
    
    init() {
        
        self.items = UserDefaults.items
    }
    
    func addItem(url: URL) {
        let preview = SwiftLinkPreview()
        preview.preview(url.absoluteString, onSuccess: { (response) in
            print(response)
            let imageURLStr = response.image ?? ""
            let imageURL = URL(string: imageURLStr)

            let item = ReadItLaterItem(link: url, title: response.title, description: response.description, imageURL: imageURL)
            self.items.insert(item, at: 0)
            UserDefaults.items = self.items
        }) { (error) in
            print(error)
        }
    }
    
    func removeItem(item: ReadItLaterItem) {
        if let index = self.items.firstIndex(where: { (currentItem) -> Bool in
            return currentItem.link.absoluteString == item.link.absoluteString
        }) {
            self.items.remove(at: index)
            UserDefaults.items = self.items
        }
    }
    
    func refreshExtensionItems() {
        print("New items (\(UserDefaults.newItemsToAdd)")
        for url in UserDefaults.newItemsToAdd {
            addItem(url: url)
        }
        UserDefaults.newItemsToAdd = []
    }
    
    func addItemFromExtension(url: URL) {
        UserDefaults.newItemsToAdd = UserDefaults.newItemsToAdd + [url]
    }

}
