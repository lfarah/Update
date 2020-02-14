//
//  Extensions.swift
//  Update
//
//  Created by Lucas Farah on 2/10/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import Foundation

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
            guard let data = UserDefaults(suiteName: "group.siligg")?.value(forKey: "feeds") as? Data else {
                return []
            }
            return (try? JSONDecoder().decode([FeedObject].self, from: data)) ?? []
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults(suiteName: "group.siligg")?.set(data, forKey: "feeds")
        }
    }
    
    static var fetchContentTime: ContentTimeType {
        get {
            guard let contentString = UserDefaults(suiteName: "group.siligg")?.value(forKey: "fetchContentTime") as? String else {
                return .minute1
            }
            return ContentTimeType(rawValue: contentString) ?? .minute1
        }
        set {
            UserDefaults(suiteName: "group.siligg")?.set(newValue.rawValue, forKey: "fetchContentTime")
        }
    }
    
    static var newFeedsToAdd: [URL] {
        get {
            guard let feeds = UserDefaults(suiteName: "group.siligg")?.value(forKey: "newFeedsToAdd") as? [String] else {
                return []
            }
            return feeds.compactMap { URL(string: $0) }
        }
        set {
            UserDefaults(suiteName: "group.siligg")?.set(newValue.map { $0.absoluteString }, forKey: "newFeedsToAdd")
        }
    }


}
