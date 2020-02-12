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
                    Spacer()
                }
                
                ExpandableGoalCard(showDetail: $showGoalDetail)
                
                RingGraphView(show: $showGoalDetail, goalPercentage: calculatePercentage())
                    .offset(y: showGoalDetail ? 200 : screen.height)
                    .animation(Animation.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0))

                InformationView(show: $showGoalDetail, readPostCount: $store.totalReadPostsToday, unreadPostCount: $store.totalUnreadPosts)
                
                NewGoalPopup(show: $showNewGoalPopup, goalTypeStr: $newGoalTypeSelection)
                    .offset(x: 0, y: showNewGoalPopup ? 200 : screen.height)

//            }
//            .navigationBarTitle("Goals")
        }
    }
}

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsView()
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
                .font(.system(size: 32, weight: .heavy))
                .foregroundColor(.white)
        }
    }
}

struct InformationView: View {
    @Binding var show: Bool
    @Binding var readPostCount: Int
    @Binding var unreadPostCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                InformationRow(text: "Read posts today:")
                    .offset(y: show ? 100 : -screen.height)
                
                Spacer()
                
                InformationRow(text: "\(readPostCount)")
                    .offset(y: show ? 100 : -screen.height)
            }
            
            HStack {
                InformationRow(text: "Unread posts left:")
                    .offset(y: show ? 100 : -screen.height)
                
                Spacer()
                
                InformationRow(text: "\(unreadPostCount)")
                    .offset(y: show ? 100 : -screen.height)
            }
            
            Spacer()
        }.padding(.horizontal)
    }
}

struct RingGraphView: View {
    @Binding var show: Bool
    @State var goalPercentage: CGFloat

    var width: CGFloat = 200
    var height: CGFloat = 200

    var color = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)

    var body: some View {
        let multiplier = width / 44
        let progress = 1 - (goalPercentage / 100)

        return ZStack {
            Circle()
                .stroke(Color.black.opacity(0.1), style: StrokeStyle(lineWidth: 5 * multiplier))
                .frame(width: width, height: height)
            
            
            Circle()
                .trim(from: show ? progress : 1, to: 1)
                .stroke(
                    Color(color),
                    style: StrokeStyle(lineWidth: 5 * multiplier, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [20, 0], dashPhase: 0)
                )
                .animation(Animation.easeIn.delay(0.5))
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                .foregroundColor(.orange)
                .frame(width: width, height: height)
            
            Text("\(Int(goalPercentage))%")
                .font(.system(size: 14 * multiplier))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .onTapGesture {
                    self.show.toggle()
            }
        }
    }
}

struct ExpandableGoalCard: View {
    @Binding var showDetail: Bool
    
    var body: some View {
        VStack {
            Text("Inbox Zero")
                .font(.system(.title))
                .frame(maxWidth: showDetail ? .infinity : screen.width - 64,
                       maxHeight: showDetail ? .infinity : 120)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: self.showDetail ? 0 : 20))
                .foregroundColor(.white)
                .edgesIgnoringSafeArea(.all)
                .animation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0))
                .onTapGesture {
                    self.showDetail.toggle()
                }
            if !showDetail {
                Spacer()
            }
        }
        .padding(.top, showDetail ? 0 : 60)
    }
}
