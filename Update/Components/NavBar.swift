//
//  NavBar.swift
//  Update
//
//  Created by Lucas Farah on 2/15/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI

enum NavBarButtonType: CaseIterable {
    case edit
    case add
    case filter
    case reload
}

struct NavBar: View {
    var title: String
    
    
    var openNewFeed: (() -> Void)?
    var updatePosts: (() -> Void)?
    var goBack: (() -> Void)?
    
    @Binding var showNewFeedPopup: Bool
    @Binding var showFilter: Bool
    
    var buttons: [NavBarButtonType]
    
    var body: some View {
        
        VStack {
            if self.goBack != nil {
                
                HStack {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .black))
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            self.goBack?()
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            HStack {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.label))
                
                Spacer()
                
                if buttons.contains(.edit) {
                    EditButton()
                        .font(.system(size: 14))
                        .foregroundColor(Color(.label))
                        .padding(.vertical)
                        .padding(.horizontal, 8)
                        .frame(height: 30)
                        .background(Color.backgroundNeo)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(color: Color.shadowTopNeo, radius: 5, x: -6, y: -6)
                        .shadow(color: Color.shadowBottomNeo, radius: 5, x: 6, y: 6)
                }
                
                if buttons.contains(.add) {
                    Button(action: openNewFeed!) {
                        Text("+")
                            .font(.system(size: 20))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(.label))
                            .rotationEffect(Angle(degrees: showNewFeedPopup ? 45 : 0))
                            .animation(.default)
                            .frame(width: 30, height: 30)
                            .background(Color.backgroundNeo)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: Color.shadowTopNeo, radius: 5, x: -6, y: -6)
                            .shadow(color: Color.shadowBottomNeo, radius: 5, x: 6, y: 6)
                    }
                }
                
                if buttons.contains(.filter) {
                    Button(action: { self.showFilter.toggle() }) {
                        Image(systemName: "slider.horizontal.3")
                            .resizable()
                            .foregroundColor(Color(.label))
                            .frame(width: 29.4, height: 25.2)
                            .padding(.all, 8)
                            .background(Color.backgroundNeo)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: Color.shadowTopNeo, radius: 5, x: -6, y: -6)
                            .shadow(color: Color.shadowBottomNeo, radius: 5, x: 6, y: 6)

                    }
                    
                }
                
                if buttons.contains(.reload) {
                    
                    Button(action: updatePosts!) {
                        Image(systemName: "arrow.2.squarepath")
                            .resizable()
                            .foregroundColor(Color(.label))
                            .frame(width: 29.4, height: 25.2)
                            .padding(.all, 8)
                            .background(Color.backgroundNeo)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: Color.shadowTopNeo, radius: 5, x: -6, y: -6)
                            .shadow(color: Color.shadowBottomNeo, radius: 5, x: 6, y: 6)
                    }
                }
            }
            .background(Color.backgroundNeo)
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top, 60)
    }
}
struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBar(title: "Test", openNewFeed: {
            
        }, updatePosts: {
            
        }, showNewFeedPopup: .constant(false), showFilter: .constant(false), buttons: NavBarButtonType.allCases)
    }
}
