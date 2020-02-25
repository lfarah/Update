//
//  NewFeedPopup.swift
//  Update
//
//  Created by Lucas Farah on 2/11/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI

enum NewFeedPopupType: String, CaseIterable {
    case feed
    case readItLater
    
    var title: String {
        switch self {
        case .feed:
            return "Feed URL"
        case .readItLater:
            return "Link"
        }
    }
    
    var textFieldPlaceholderText:  String {
        return "URL"
    }
    
    var addButtonTitle: String {
        switch self {
        case .feed:
            return "Add feed"
        case .readItLater:
            return "Add link"
        }
    }
}

struct NewFeedPopup: View {
    var type: NewFeedPopupType
    @Binding var feedURL: String
    var addFeedPressed: (() -> Void)
    @Binding var feedAddColor: Color
    @Binding var attempts: Int
    @Binding var show: Bool
    
    var body: some View {
        VStack {
            ZStack {
                Text(type.title)
                    .font(.title)
                    .foregroundColor(.gray)
            }
            
            TextField(type.textFieldPlaceholderText, text: $feedURL)
                .background(Color.white)
                .foregroundColor(Color(.black))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .keyboardType(.URL)
                .textContentType(.URL)
                .padding()

            Button(action: addFeedPressed) {
                Text(type.addButtonTitle)
                    .padding()
                    .foregroundColor(.gray)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }.buttonStyle(NeumorphismButtonStyle(value: 8))

            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: show ? nil : 0)
        .background(feedAddColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .modifier(NeumorphismShadow())
        .opacity(show ? 1 : 0)
        .animation(Animation.easeIn(duration: 0.1))
        .modifier(Shake(animatableData: CGFloat(attempts)))
        .animation(Animation.easeIn(duration: 0.5))
    }
}

struct NewFeedPopup_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(NewFeedPopupType.allCases, id: \.self.rawValue) { type in
            NewFeedPopup(type: type, feedURL: .constant("https://www.google.com"), addFeedPressed: {
                
            }, feedAddColor: .constant(Color.backgroundNeo), attempts: .constant(1), show: .constant(true))
                .frame(maxHeight: 100)
        }
    }
}
