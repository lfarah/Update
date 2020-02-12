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
            guard let data = UserDefaults.standard.value(forKey: "feeds") as? Data else {
                return []
            }
            return (try? JSONDecoder().decode([FeedObject].self, from: data)) ?? []
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: "feeds")
        }
    }
    
    static var fetchContentTime: ContentTimeType {
        get {
            guard let contentString = UserDefaults.standard.value(forKey: "fetchContentTime") as? String else {
                return .minute1
            }
            return ContentTimeType(rawValue: contentString) ?? .minute1
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "fetchContentTime")
        }
    }

}
