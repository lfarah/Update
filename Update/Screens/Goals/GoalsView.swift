//
//  GoalsView.swift
//  Update
//
//  Created by Lucas Farah on 2/12/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI

struct GoalsView: View {
    @ObservedObject var viewModel: GoalsViewModel

    @State var showNewGoalPopup = false
    
    @State var newGoalTypeSelection: String = GoalType.inboxZero.rawValue
    @State var goalPercentage: CGFloat = 80
    @State var show: Bool = false
    
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
                    
                    if viewModel.store.feeds.isEmpty {
                        AnyView(Text("No feeds available. Please add a new feed"))
                    } else {
                        AnyView(Graph(graphData: $viewModel.graphData))
                            .onAppear {
                                self.viewModel.shouldReload = true
                        }
                    }
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
                                       showDetail: self.$viewModel.showGoalDetails[index],
                                       goalPercentage: self.viewModel.calculatePercentage(),
                                       info: self.$viewModel.goalInfo)
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
            GoalsView(viewModel: GoalsViewModel()).environment(\.colorScheme, .light)
            GoalsView(viewModel: GoalsViewModel()).environment(\.colorScheme, .dark)
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
