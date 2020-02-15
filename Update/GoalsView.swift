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
}

struct GoalsView: View {
    @ObservedObject var store = RSSStore.instance
    @State var showNewGoalPopup = false
    @State var showGoalDetail = false

    @State var newGoalTypeSelection: String = GoalType.inboxZero.rawValue
    @State var goalPercentage: CGFloat = 80
    @State var show: Bool = false

    func calculatePercentage() -> CGFloat {
        if store.totalUnreadPosts == 0 {
            return 100
        } else if store.totalReadPostsToday > 0{
            return (CGFloat(store.totalReadPostsToday) / CGFloat(store.totalUnreadPosts + store.totalReadPostsToday)) * 100
        } else {
            return 0
        }
    }

    var body: some View {
            return ZStack {
                VStack {
                    HStack {
                        Text("Goals")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }.padding(.horizontal, 16)
                    .padding(.top, 80)
                
                    ExpandableGoalCard(goalName: "Inbox Zero",
                                   showDetail: $showGoalDetail,
                                   show: $showGoalDetail,
                                   goalPercentage: calculatePercentage(),
                                   readPostCount: $store.totalReadPostsToday,
                                   unreadPostCount: $store.totalUnreadPosts)
                    .padding(.top, 80)
                }

                NewGoalPopup(show: $showNewGoalPopup, goalTypeStr: $newGoalTypeSelection)
                    .offset(x: 0, y: showNewGoalPopup ? 200 : screen.height)

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

struct InformationRow: View {
    var text: String
    
    var body: some View {
        VStack {
            Text(text)
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(Color.gray)
        }
    }
}

struct InformationView: View {
    @Binding var readPostCount: Int
    @Binding var unreadPostCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Spacer()

            HStack {
                InformationRow(text: "Read posts today:")
                
                Spacer()
                
                InformationRow(text: "\(readPostCount)")
            }
            .padding(.horizontal)

            HStack {
                InformationRow(text: "Unread posts left:")
                
                Spacer()
                
                InformationRow(text: "\(unreadPostCount)")
            }
            .padding(.horizontal)

            Spacer()
        }
        .frame(maxWidth: screen.width - 64, maxHeight: 120)
    }
}

struct RingGraphView: View {
    @Binding var show: Bool
    @State var goalPercentage: CGFloat

    var width: CGFloat = 100
    var height: CGFloat = 100

    var color = #colorLiteral(red: 0.1527788341, green: 0.7198211551, blue: 0.3009665906, alpha: 1)

    var body: some View {
        let multiplier = width / 44
        let progress = 1 - (goalPercentage / 100)

        return ZStack {
            Circle()
                .stroke(Color("ShadowBottomNeo").opacity(0.5), style: StrokeStyle(lineWidth: 5 * multiplier))
                .frame(width: width, height: height)

            
            Circle()
                .trim(from: show ? progress : 1, to: 1)
                .stroke(
                    Color(color),
                    style: StrokeStyle(lineWidth: 2 * multiplier, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [20, 0], dashPhase: 0)
                )
                .animation(Animation.easeIn.delay(0.5))
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                .foregroundColor(.orange)
                .frame(width: width * 0.95, height: height * 0.95)
                .shadow(color: Color(color), radius: 10, x: 0, y: 0)
                .shadow(color: Color("ShadowBottomNeo").opacity(1), radius: 5, x: 6, y: 6)

            Text("\(Int(goalPercentage))%")
                .font(.system(size: 12 * multiplier))
                .fontWeight(.regular)
                .foregroundColor(Color.gray)
                .onTapGesture {
                    self.show.toggle()
            }
        }
    }
}

struct ExpandableGoalCard: View {
    var goalName: String
    @Binding var showDetail: Bool
    @Binding var show: Bool
    @State var goalPercentage: CGFloat
    @Binding var readPostCount: Int
    @Binding var unreadPostCount: Int

    var body: some View {
        VStack {
            ZStack {
                    
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(maxWidth: screen.width - 64,
                               maxHeight: showDetail ? 300 : 120)
                        .foregroundColor(Color.backgroundNeo)
                    HStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.green.opacity(0.5))
                            .frame(maxWidth: !showDetail ? ((screen.width - 64) * (goalPercentage / 100)) : 0,
                               maxHeight: showDetail ? 300 : 120)
                        
                        Spacer()
                    }
                    .padding(.leading, 32)

                }
                .offset(y: showDetail ? 110 : 0)
                .shadow(color: Color.shadowTopNeo, radius: 5, x: -6, y: -6)
                .shadow(color: Color.shadowBottomNeo, radius: 5, x: 6, y: 6)
                .foregroundColor(Color(.label))
                .edgesIgnoringSafeArea(.all)
                .animation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0))
                .onTapGesture {
                    self.showDetail.toggle()
                }

                
                VStack {
                    RingGraphView(show: $show, goalPercentage: goalPercentage)
                    
                    InformationView(readPostCount: $readPostCount, unreadPostCount: $unreadPostCount)
                }
                .offset(y: show ? 170 : screen.height)

                VStack {
                    Text(goalName)
                        .font(.system(.title))
                        .foregroundColor(Color.gray)
                    .offset(y: showDetail ? 20 : 0)
                }

            }
                Spacer()
        }
        .padding(.top, showDetail ? 0 : 60)
    }
}
