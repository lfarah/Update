//
//  GoalsViewModel.swift
//  Update
//
//  Created by Lucas Farah on 2/18/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

enum GoalType: String, CaseIterable {
    case inboxZero = "Inbox Zero"
    case postDay1 = "Read 1 post per day"
}

public class GoalsViewModel: ObservableObject {

    @ObservedObject var store = RSSStore.instance
//    @Published var totalPostsReadToday: Int = 0
//    @Published var totalPostsUnread: Int = 0
    @Published var showGoalDetails: [Bool] = GoalType.allCases.map { _ in false }
    @Published var graphData: [GraphData] = []
    @Published var shouldReload: Bool = false
    @Published var goalInfo: GoalInfo = GoalInfo(readTodayCount: 0, totalUnreadCount: 0)

    private var cancellable: AnyCancellable? = nil
    private var cancellable2: AnyCancellable? = nil
    private var cancellable3: AnyCancellable? = nil

    init() {

        cancellable = Publishers.CombineLatest3(store.$totalReadPostsToday, store.$totalUnreadPosts, $shouldReload)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { (newValue) in
                self.goalInfo = self.mapGoalInfo()
                self.graphData = self.createGraphModel()
            })
    }

    func calculatePercentage() -> CGFloat {
        if store.totalUnreadPosts == 0 {
            return 100
        } else if store.totalReadPostsToday > 0 {
            return (CGFloat(store.totalReadPostsToday) / CGFloat(store.totalUnreadPosts + store.totalReadPostsToday)) * 100
        } else {
            return 0
        }
    }
    
    func mapGoalInfo() -> GoalInfo {
        let readCount = store.feeds.map({ (feed) -> Int in
                    return feed.posts.filter { (post) -> Bool in
                        guard let readDate = post.readDate else { return false }
                        return Calendar.current.isDateInToday(readDate)
                    }.count
                }).reduce(0, +)

        
        let unreadCount = store.feeds.map({ (feed) -> Int in
                    return feed.posts.filter { $0.readDate == nil }.count
                }).reduce(0, +)
        return GoalInfo(readTodayCount: readCount, totalUnreadCount: unreadCount)
    }
    
    func createGraphModel() -> [GraphData] {
        let totalDays = 7
        
        return (0...totalDays).map { day -> GraphData in
            let today = Date()
            let date = Calendar.current.date(byAdding: .day, value: -1 * (totalDays - day), to: today)!
            
            let title: String
            if day == totalDays {
                title = "Today"
            } else {
                title = date.toString(format: "EEE")
            }
            let totalPosts = self.store.totalReadPosts(in: date)
            let format: String
            if totalPosts == 1 {
                format = "%d post"
            } else if totalPosts > 99 {
                format = "99+ posts"
            } else {
                format = "%d posts"
            }
            
            return GraphData(title: title, titleFormat: format, value: totalPosts)
        }
    }
}
