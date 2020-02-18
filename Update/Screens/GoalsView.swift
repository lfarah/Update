//
//  GoalsView.swift
//  Update
//
//  Created by Lucas Farah on 2/12/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI

enum GoalType: String, CaseIterable {
    case inboxZero = "Inbox Zero"
    case postDay1 = "Read 1 post per day"
}

struct GoalsView: View {
    @ObservedObject var store = RSSStore.instance
    @State var showNewGoalPopup = false
    @State var showGoalDetails: [Bool] = GoalType.allCases.map { _ in false }
    
    @State var newGoalTypeSelection: String = GoalType.inboxZero.rawValue
    @State var goalPercentage: CGFloat = 80
    @State var show: Bool = false
    
    func calculatePercentage() -> CGFloat {
        if store.totalUnreadPosts == 0 {
            return 100
        } else if store.totalReadPostsToday > 0 {
            return (CGFloat(store.totalReadPostsToday) / CGFloat(store.totalUnreadPosts + store.totalReadPostsToday)) * 100
        } else {
            return 0
        }
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
            let format = totalPosts == 1 ? "%d post" : "%d posts"
            
            return GraphData(title: title, titleFormat: format, value: totalPosts)
        }
    }
    
    var body: some View {
        ZStack {
            Color.backgroundNeo
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            NavBar(title: "Goals", goBack: nil, showNewFeedPopup: .constant(false), showFilter: .constant(false), buttons: [])

            VStack {
                

                VStack {
                    HStack {
                        Text("Last 7 days")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    
                    Graph(graphData: createGraphModel())
                }
                .padding()
                .background(Color.backgroundNeo)
                .padding(.horizontal, 16)
                .modifier(NeumorphismShadow())

                VStack {
                    HStack {
                        Text("Today's goal progress")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top)
                }
                
                List {
                 ForEach(GoalType.allCases.indices, id: \.self) { index in

                    ExpandableGoalCard(goalName: GoalType.allCases[index].rawValue,
                                       showDetail: self.$showGoalDetails[index],
                                       goalPercentage: self.calculatePercentage(),
                                       readPostCount: self.$store.totalReadPostsToday,
                                       unreadPostCount: self.$store.totalUnreadPosts)
                    .clipped()
                    .modifier(NeumorphismShadow())

                    }
                    .listRowBackground(Color.backgroundNeo)
                }

            }
            .background(Color.backgroundNeo)
            .padding(.top, 120)

//            NewGoalPopup(show: $showNewGoalPopup, goalTypeStr: $newGoalTypeSelection)
//                .offset(x: 0, y: showNewGoalPopup ? 200 : screen.height)
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GoalsView().environment(\.colorScheme, .light)
            GoalsView().environment(\.colorScheme, .dark)
        }
    }
}

struct NewGoalPopup: View {
    @Binding var show: Bool
    @Binding var goalTypeStr: String
    
    var body: some View {
        ZStack {
            VStack {
                Form {
                    Picker(selection: $goalTypeStr, label: Text("Goal type")) {
                        ForEach(GoalType.allCases, id: \.self.rawValue) { goal in
                            Text(goal.rawValue)
                        }
                    }
                }
                Spacer()
            }
            
            VStack {
                Spacer()
                
                Button(action: {
                    self.show = false
                }, label: {
                    Text("Save")
                        .foregroundColor(.white)
                        .frame(width: 60)
                        .padding()
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                })
                    .padding(.bottom, 32)
            }
        }
        .frame(height: 360)
        .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0))
    }
}
