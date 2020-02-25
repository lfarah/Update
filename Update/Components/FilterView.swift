//
//  FilterView.swift
//  Update
//
//  Created by Lucas Farah on 2/10/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI

enum FilterType: String {
    case all = "All"
    case unreadOnly = "Unread Only"
}

struct FilterView: View {
    @Binding var selectedFilter: FilterType
    @Binding var showFilter: Bool
    var markedAllPostsRead: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Filter by")
                .font(.subheadline)
            
                HStack() {
                    Spacer()
                    
                    ZStack {
                        
                        if selectedFilter == .all {
                            RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.backgroundNeo)
                            .modifier(NeumorphismShadow())
                        } else {
                            RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.backgroundNeo)
                        }

                        Text(FilterType.all.rawValue)
                    }
                    .padding()
                    .onTapGesture {
                        self.selectedFilter = .all
                    }
                    
                    ZStack {
                        
                        if selectedFilter == .unreadOnly {
                            RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.backgroundNeo)
                            .modifier(NeumorphismShadow())
                        } else {
                            RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.backgroundNeo)
                        }

                        Text(FilterType.unreadOnly.rawValue)
                    }
                    .padding()
                    .onTapGesture {
                        self.selectedFilter = .unreadOnly
                    }

                    Spacer()
                }
                .frame(height: 70)
                
            Text("Options")
                .font(.subheadline)

                Button(action: {
                    self.markedAllPostsRead?()
                }) {
                    Text("Mark all read")
                        .font(.subheadline)
                        .foregroundColor(Color(.label))
                        .padding()
                }
                .buttonStyle(NeumorphismButtonStyle(value: 8))
                
            }
        .padding()
        .background(Color.backgroundNeo)
        .frame(height: showFilter ? nil : 0)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(selectedFilter: .constant(.all),
                   showFilter: .constant(true), markedAllPostsRead: nil)
    }
}
