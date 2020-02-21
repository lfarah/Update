//
//  ProgressOnboardingContent.swift
//  Update
//
//  Created by Lucas Farah on 2/20/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI
import Combine

struct ProgressOnboardingContent: View {
    @Binding var showBars: Bool
    
    var body: some View {
        ZStack {
            Color.black
            
            VStack(spacing: 32) {
                Text("Keep track of your progress")
                    .font(.title)
                    .foregroundColor(.white)
                
                Text("We'll help you keep up to date with your content")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.top, 32)
            .padding(.horizontal)
            
            
//            VStack {
//                Spacer()
                
                Graph(graphData: .constant((0...5).map { day in
                    let today = Date()
                    let date = Calendar.current.date(byAdding: .day, value: -day, to: today)!
                    let title = date.toString(format: "EEE")
                    let titleFinal = day == 5 ? "Today" : title
                    return GraphData(title: titleFinal, titleFormat: "%d posts", value: Int.random(in: 0 ..< 15))
                }), barColor: .green, textColor: .white, showBars: $showBars)
                
            ExpandableGoalCard(goalName: "Read all posts", showDetail: $showBars, goalPercentage: 90, info: .constant(GoalInfo(readTodayCount: 10, totalUnreadCount: 20)), type: .small)
                    .frame(maxHeight: showBars ? 200 : 100)
                    .offset(y: showBars ? 200 : 150)
                    .padding(.bottom, 24)
                    .padding(.horizontal, 16)
                    .animation(.easeInOut)

//            }
        }
    }
}

struct ProgressOnboardingContent_Previews: PreviewProvider {
    static var previews: some View {
        ProgressOnboardingContent(showBars: .constant(true))
    }
}
