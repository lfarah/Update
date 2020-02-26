//
//  OnboardingCard.swift
//  Update
//
//  Created by Lucas Farah on 2/20/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI

struct OnboardingCard: View {
    @ObservedObject var page: OnboardingPage

    var content: AnyView

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(page.color)
            
            content
                .opacity(page.showContent ? 1 : 0)
        }
        .frame(maxWidth: page.showContent ? (screen.width * 0.8) : page.minWidth)
        .frame(height: page.showContent ? (screen.height * 0.8) : page.minWidth)
        .cornerRadius(page.showContent ? 10 : page.minWidth / 2)
        .shadow(radius: page.showContent ? 20 : 0)
        .scaleEffect(page.scale)
        .offset(x: page.offsetX, y: page.offsetY)
        .animation(.easeInOut)
    }
}
struct OnboardingCard_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCard(page: OnboardingPage(state: .center, offsetX: 0, offsetY: 0, scale: 1, showContent: true, color: .red, minWidth: 100), content: AnyView(Text("Test Page")))
    }
}
