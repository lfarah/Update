//
//  NewFeedPopup.swift
//  Update
//
//  Created by Lucas Farah on 2/11/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI

struct NewFeedPopup: View {
    @Binding var feedURL: String
    var addFeedPressed: (() -> Void)
    @Binding var feedAddColor: Color
    @Binding var attempts: Int
    @Binding var show: Bool
    
    var body: some View {
        VStack {
            ZStack {
                Text("Feed URL")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            
            TextField("URL", text: $feedURL)
                .background(Color.white)
                .foregroundColor(Color(.black))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .keyboardType(.URL)
                .textContentType(.URL)
                .padding()

            Button(action: addFeedPressed) {
                Text("Add feed")
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
        NewFeedPopup(feedURL: .constant("https://www.google.com"), addFeedPressed: {
            
        }, feedAddColor: .constant(Color.backgroundNeo), attempts: .constant(1), show: .constant(true))
    }
}
