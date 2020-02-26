//
//  Extensions.swift
//  Update
//
//  Created by Lucas Farah on 2/10/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import Foundation
import SwiftUI

extension Date {
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension UserDefaults {
    static var feeds: [FeedObject] {
        get {
            guard let data = UserDefaults(suiteName: "group.update.lucasfarah")?.value(forKey: "feeds") as? Data else {
                return []
            }
            return (try? JSONDecoder().decode([FeedObject].self, from: data)) ?? []
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults(suiteName: "group.update.lucasfarah")?.set(data, forKey: "feeds")
        }
    }
    
    static var items: [ReadItLaterItem] {
        get {
            guard let data = UserDefaults(suiteName: "group.update.lucasfarah")?.value(forKey: "items") as? Data else {
                return []
            }
            return (try? JSONDecoder().decode([ReadItLaterItem].self, from: data)) ?? []
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults(suiteName: "group.update.lucasfarah")?.set(data, forKey: "items")
        }
    }

    
    static var fetchContentTime: ContentTimeType {
        get {
            guard let contentString = UserDefaults(suiteName: "group.update.lucasfarah")?.value(forKey: "fetchContentTime") as? String else {
                return .minute60
            }
            return ContentTimeType(rawValue: contentString) ?? .minute60
        }
        set {
            UserDefaults(suiteName: "group.siligg")?.set(newValue.rawValue, forKey: "fetchContentTime")
        }
    }
    
    static var newFeedsToAdd: [URL] {
        get {
            guard let feeds = UserDefaults(suiteName: "group.update.lucasfarah")?.value(forKey: "newFeedsToAdd") as? [String] else {
                return []
            }
            return feeds.compactMap { URL(string: $0) }
        }
        set {
            UserDefaults(suiteName: "group.update.lucasfarah")?.set(newValue.map { $0.absoluteString }, forKey: "newFeedsToAdd")
        }
    }
    
    static var newItemsToAdd: [URL] {
        get {
            guard let feeds = UserDefaults(suiteName: "group.update.lucasfarah")?.value(forKey: "newItemsToAdd") as? [String] else {
                return []
            }
            return feeds.compactMap { URL(string: $0) }
        }
        set {
            UserDefaults(suiteName: "group.update.lucasfarah")?.set(newValue.map { $0.absoluteString }, forKey: "newItemsToAdd")
        }
    }

    
    static var showOnboarding: Bool {
        get {
            return (UserDefaults(suiteName: "group.update.lucasfarah")?.value(forKey: "showOnboarding") as? Bool) ?? true
        }
        set {
            UserDefaults(suiteName: "group.update.lucasfarah")?.set(newValue, forKey: "showOnboarding")
        }
    }

}

extension Color {
    
    static var backgroundNeo: Color {
        return Color("BackgroundNeo")
    }

    static var shadowTopNeo: Color {
        return Color("ShadowTopNeo")
    }

    static var shadowBottomNeo: Color {
        return Color("ShadowBottomNeo")
    }
}
