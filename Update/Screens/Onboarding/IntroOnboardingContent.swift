//
//  IntroOnboardingContent.swift
//  Update
//
//  Created by Lucas Farah on 2/20/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI

struct IntroOnboardingContent: View {
    var body: some View {
        ZStack {
            VStack {
                Text("Welcome to Update")
                    .font(.title)
                    .foregroundColor(.white)
                
                Text("The RSS reader for productivity")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
            }.padding(.top, 32)
            
            
            VStack(alignment: .leading) {
                HStack {
                    Text("New York times")
                        .font(.subheadline)
                        .foregroundColor(.black)

                    Spacer()
                }
                HStack {
                    Text("3 unread posts")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .padding(.horizontal)
        }    }
}

struct IntroOnboardingContent_Previews: PreviewProvider {
    static var previews: some View {
        IntroOnboardingContent()
    }
}
