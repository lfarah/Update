//
//  ShareExtensionOnboardingContent.swift
//  Update
//
//  Created by Lucas Farah on 2/20/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI
import Combine

struct ShareExtensionOnboardingContent: View {
    @Binding var showPopup: Bool
    @Binding var showSheet: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Text("Add new feeds from Safari")
                    .font(.title)
                    .foregroundColor(.black)
                
                Text("Our share extension detects the RSS automatically")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding()
            .padding(.top, 32)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("New York times")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                
                HStack {
                    Text("https://rss.nytimes.com/services/xml/rss/nyt/Technology.xml")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(radius: 10)
            .padding(.horizontal)
            .offset(y: showPopup ? 0 : 500)
            .scaleEffect(showPopup ? 1 : 0)
            .animation(.easeInOut)
            
            OnboardingShareSheet()
                .offset(y: showSheet ? 0 : 500)
        }
    }
}

struct OnboardingShareSheet: View {
    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .leading) {
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(maxWidth: 50)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(maxWidth: 50)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(maxWidth: 50)
                }
                .frame(maxHeight: 50)
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(maxWidth: 50)
                    
                    Image("OnboardingAppIcon")
                        .resizable()
                        .frame(maxWidth: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(maxWidth: 50)
                }
                .frame(maxHeight: 50)
                
            }
            .padding(.top, 32)
            .frame(maxWidth: .infinity)
            .padding()
            .padding(.bottom, 60)
            .background(Color.black.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal)
            .offset(y: 20)
        }
    }
}


struct ShareExtensionOnboardingContent_Previews: PreviewProvider {
    static var previews: some View {
        ShareExtensionOnboardingContent(showPopup: .constant(true), showSheet: .constant(true))
    }
}
