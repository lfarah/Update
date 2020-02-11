//
//  Extensions.swift
//  Update
//
//  Created by Lucas Farah on 2/10/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import Foundation

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
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
}
