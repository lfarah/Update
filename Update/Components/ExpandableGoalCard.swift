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

enum ExpandableGoalCardType {
    case regular
    case small
    
    var ringGraphSize: CGFloat {
        switch self {
        case .regular:
            return 100
        case .small:
            return 70
        }
    }
    
    var infoFont: Font {
        switch self {
        case .regular:
            return .title
        case .small:
            return .subheadline
        }
    }

}

struct ExpandableGoalCard: View {
    var goalName: String
    
    @Binding var showDetail: Bool
    @State var goalPercentage: CGFloat
    @Binding var info: GoalInfo
    var type: ExpandableGoalCardType = .regular

    var body: some View {
        ZStack {
            
            GeometryReader { geometry in

            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.backgroundNeo)
                .frame(width: geometry.size.width)
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.green.opacity(0.5))
                    .frame(width: !self.showDetail ? (geometry.size.width * (self.goalPercentage / 100)) : 0)
                Spacer()
            }
            }
            
            VStack {
                Text(goalName)
                    .font(type.infoFont)
                    .foregroundColor(Color.gray)
                    .padding(.top, showDetail ? 16 : 0)
                    .frame(maxWidth: .infinity)
            if showDetail {
                
                RingGraphView(show: $showDetail, goalPercentage: goalPercentage, width: type.ringGraphSize, height: type.ringGraphSize)
                    
                InformationView(readPostCount: $info.readTodayCount, unreadPostCount: $info.totalUnreadCount, font: type.infoFont)
                        .padding(.horizontal, 16)
                }
            }
        }
        .frame(minHeight: 120)
        .frame(maxWidth: .infinity)
        .onTapGesture {
            self.showDetail.toggle()
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0))
    }
}
struct ExpandableGoalCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
        ExpandableGoalCard(goalName: "Inbox Zero", showDetail: .constant(false), goalPercentage: 70, info: .constant(GoalInfo(readTodayCount: 5, totalUnreadCount: 10)))
            .frame(maxHeight: 100)
            ExpandableGoalCard(goalName: "Inbox Zero", showDetail: .constant(true), goalPercentage: 70, info: .constant(GoalInfo(readTodayCount: 10, totalUnreadCount: 10)))
                .frame(maxHeight: 100)

        }
    }
}
