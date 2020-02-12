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
            
            VStack {
                ZStack {
                    Text("Feed URL")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            self.show = false
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.system(size: 30))
                                .padding()
                        }
                    }
                    
                }

                TextField("URL", text: $feedURL)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(Color(.black)) .clipShape(RoundedRectangle(cornerRadius: 20))
                Button(action: addFeedPressed) {
                    Text("Add feed")
                        .padding()
                        .foregroundColor(.black)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            .accessibility(identifier: "addFeedPopup")
            .padding()
            .background(feedAddColor)
            .animation(.easeInOut(duration: 0.1))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.all, 16)
            .modifier(Shake(animatableData: CGFloat(attempts)))
            .animation(Animation.easeIn(duration: 0.5))
            .offset(x: 0, y: show ? 200 : screen.height)
            .animation(Animation.easeInOut(duration: 1).delay(1))
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.6))
        .edgesIgnoringSafeArea(.all)
        .opacity(show ? 1 : 0)
        .animation(Animation.easeIn(duration: 0.2).delay(show ? 0: 0.5))
    }
}

struct NewFeedPopup_Previews: PreviewProvider {
    static var previews: some View {
        NewFeedPopup(feedURL: .constant("https://www.google.com"), addFeedPressed: {
            
        }, feedAddColor: .constant(.blue), attempts: .constant(1), show: .constant(true))
    }
}
