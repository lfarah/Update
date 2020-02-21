//
//  Onboarding.swift
//  Update
//
//  Created by Lucas Farah on 2/19/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI

struct Onboarding: View {
    @ObservedObject var viewModel: OnboardingViewModel
        
    var body: some View {
        ZStack {
            Color.white
            
            
            OnboardingLoadingCloud(show: self.$viewModel.tapped)
            
            ForEach(viewModel.pages.indices, id: \.self) { index in
                self.getCard(page: self.viewModel.pages[index])
            }
            
            Text("U")
                .font(.system(size: 50))
                .scaleEffect(viewModel.tapped ? 0 : 1)
                .animation(.easeInOut)
                .foregroundColor(.black)
            
            VStack {
                Spacer()
                Text("Next")
                    .foregroundColor(.black)
                    .onTapGesture {
                        self.viewModel.tappedNext()
                }
            }.padding(.bottom, 60)
        }
        .edgesIgnoringSafeArea(.all)
        .opacity(viewModel.screenOpacity)
        .animation(.easeInOut)
    }
    
    func getCard(page: OnboardingPageType) -> OnboardingCard {
        switch page {
        case .intro(let page):
            return OnboardingCard(page: page, content: AnyView (
                
                IntroOnboardingContent()
            ))
            
        // TODO: Fix rx to use showPopup instead of $viewModel.showPage2Popup
        case .share(let page, let showPopup, let showSheet):
            return OnboardingCard(page: page, content: AnyView (
                
                ShareExtensionOnboardingContent(showPopup: $viewModel.showPage2Popup, showSheet: $viewModel.showPage2Sheet)
            ))
        case .progress(let page, let showBars):
            return OnboardingCard(page: page, content: AnyView (
                
                ProgressOnboardingContent(showBars: $viewModel.showPage3Bars)
            ))
        }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        let pages = ["Initial State", "Intro", "Share Extension", "Progress"]
        
        return ForEach(pages.indices, id: \.self) { pageIndex in
            Onboarding(viewModel: OnboardingViewModel(currentPage: pageIndex))
                .previewDisplayName(pages[pageIndex])
        }
    }
}
