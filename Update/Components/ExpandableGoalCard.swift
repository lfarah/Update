//
//  ExpandableGoalCard.swift
//  Update
//
//  Created by Lucas Farah on 2/17/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI
import Combine

class GoalInfo: ObservableObject {
    var readTodayCount: Int
    var totalUnreadCount: Int
    
    init(readTodayCount: Int, totalUnreadCount: Int) {
        self.readTodayCount = readTodayCount
        self.totalUnreadCount = totalUnreadCount
    }
}

struct ExpandableGoalCard: View {
    var goalName: String
    @Binding var showDetail: Bool
    @State var goalPercentage: CGFloat
    @Binding var info: GoalInfo
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(maxWidth: screen.width - 64)
                .foregroundColor(Color.backgroundNeo)
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.green.opacity(0.5))
                    .frame(maxWidth: !showDetail ? ((screen.width - 64) * (goalPercentage / 100)) : 0)
                    .padding(.leading, 16)
                Spacer()
            }
            
            VStack {
                Text(goalName)
                    .font(.system(.title))
                    .foregroundColor(Color.gray)
                    .padding(.top, showDetail ? 16 : 0)

            if showDetail {
                
                    RingGraphView(show: $showDetail, goalPercentage: goalPercentage)
                    
                InformationView(readPostCount: $info.readTodayCount, unreadPostCount: $info.totalUnreadCount)
                        .frame(maxWidth: screen.width - 64)
                        .padding(.horizontal, 32)
                }
            }
        }
        .frame(minHeight: 120)
        .onTapGesture {
            self.showDetail.toggle()
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0))
    }
}
struct ExpandableGoalCard_Previews: PreviewProvider {
    static var previews: some View {
        ExpandableGoalCard(goalName: "Inbox Zero", showDetail: .constant(false), goalPercentage: 70, info: .constant(GoalInfo(readTodayCount: 5, totalUnreadCount: 10)))
    }
}
