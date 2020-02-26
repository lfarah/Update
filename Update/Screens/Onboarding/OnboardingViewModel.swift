//
//  OnboardingViewModel.swift
//  Update
//
//  Created by Lucas Farah on 2/20/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

enum OnboardingPageState {
    case center // Center of the page. Card is just a shape, which creates the apps logo
    case fullScreenCenter // Full screen, showing content
    case fullScreenSide(index: Int) // Showing content, but not yet presented in the center of the screen
    case top // Top right of the page. Card is just a shape, which creates the apps logo
    case centerSmall // Just like center, but smaller
}

public class OnboardingPage: ObservableObject {
    @Published var state: OnboardingPageState = .center
    
    @Published var offsetX: CGFloat = 0
    @Published var offsetY: CGFloat = 0
    @Published var scale: CGFloat = 1
    @Published var showContent: Bool = false
    @Published var color: Color = .black
    @Published var minWidth: CGFloat = 0
    
    init(state: OnboardingPageState, offsetX: CGFloat = 0, offsetY: CGFloat = 0, scale: CGFloat = 1, showContent: Bool = false, color: Color = .black, minWidth: CGFloat = 0) {
        
        self.state = state
        self.offsetX =  offsetX
        self.offsetY =  offsetY
        self.scale = scale
        self.showContent = showContent
        self.color = color
        self.minWidth = minWidth
    }
}

enum OnboardingPageType {
    case intro(page: OnboardingPage)
    case share(page: OnboardingPage, showPopup: Published<Bool>.Publisher, showSheet: Published<Bool>.Publisher)
    case progress(page: OnboardingPage, showBars: Bool)
}

public class OnboardingViewModel: ObservableObject {
    @Published var tapped: Bool = false
    @Published var currentPage: Int = 0
    
    @Published var showPage2Popup: Bool = false
    @Published var showPage2Sheet: Bool = false
    @Published var showPage3Bars: Bool = false
    @Published var screenOpacity: Double = 1
    
    @Published var pages: [OnboardingPageType] = []
    @Published var introPage: OnboardingPage
    @Published var sharePage: OnboardingPage
    @Published var progressPage: OnboardingPage
    
    var finishedOnboarding: (() -> Void)?
    
    init(currentPage: Int = 0) {
        self.currentPage = currentPage
        
        progressPage = OnboardingPage(state: .center,
                                      offsetX: 0,
                                      offsetY: 0,
                                      scale: 1,
                                      showContent: false,
                                      color: .black,
                                      minWidth: 120)
        
        introPage = OnboardingPage(state: .center,
                                   offsetX: 0,
                                   offsetY: 0,
                                   scale: 1,
                                   showContent: false,
                                   color: .red,
                                   minWidth: 100)
        
        sharePage = OnboardingPage(state: .center,
                                   offsetX: 0,
                                   offsetY: 0,
                                   scale: 1,
                                   showContent: false,
                                   color: .white,
                                   minWidth: 60)
        
        
        pages = [.progress(page: progressPage, showBars: showPage3Bars),
                 .intro(page: introPage),
                 .share(page: sharePage, showPopup: $showPage2Popup, showSheet: $showPage2Sheet)]
        
        updateContentState()
    }
    
    func updateContentState() {
        if self.currentPage == 0 {
            self.tapped = false

            self.update(page: introPage, to: .center)
            self.update(page: sharePage, to: .center)
            self.update(page: progressPage, to: .center)

            self.showPage2Popup = false
            self.showPage2Sheet = false
            self.showPage3Bars = false
        } else if self.currentPage == 1 {
            self.tapped = true

            self.update(page: introPage, to: .fullScreenCenter)
            self.update(page: sharePage, to: .fullScreenSide(index: 1))
            self.update(page: progressPage, to: .fullScreenSide(index: 2))
            
            self.showPage2Popup = false
            self.showPage2Sheet = false
            self.showPage3Bars = false
        } else if self.currentPage == 2 {
            self.tapped = true

            self.update(page: introPage, to: .top)
            self.update(page: sharePage, to: .fullScreenCenter)
            self.update(page: progressPage, to: .fullScreenSide(index: 1))
            
            self.showPage3Bars = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.showPage2Sheet = true
                self.sharePage.objectWillChange.send()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showPage2Popup = true
                    
                    self.sharePage.objectWillChange.send()
                    
                }
                
            }
        } else if self.currentPage == 3 {
            self.tapped = true
            self.update(page: introPage, to: .top)
            self.update(page: sharePage, to: .top)
            self.update(page: progressPage, to: .fullScreenCenter)
            
            self.showPage2Popup = false
            self.showPage2Sheet = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showPage3Bars = true
            }
            
        } else {
            self.tapped = true
            self.update(page: introPage, to: .top)
            self.update(page: sharePage, to: .top)
            self.update(page: progressPage, to: .top)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.update(page: self.introPage, to: .centerSmall)
                self.update(page: self.sharePage, to: .centerSmall)
                self.update(page: self.progressPage, to: .centerSmall)
                
                self.showPage2Popup = false
                self.showPage2Sheet = false
                self.showPage3Bars = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.screenOpacity = 0
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        
                        self.finishedOnboarding?()
                    }
                }
            }
        }
    }
    
    func tappedNext() {
        self.tapped = true
        
        self.currentPage += 1
        if self.currentPage == 5 {
            self.currentPage = 0
            self.tapped = false
        }
        
        updateContentState()
    }
    
    func update(page: OnboardingPage, to state: OnboardingPageState) {
        switch state {
        case .center:
            page.offsetX = 0
            page.offsetY = 0
            page.showContent = false
            page.scale = 1

        case .fullScreenCenter:
            page.offsetX = 0
            page.offsetY = 0
            page.showContent = true
            page.scale = 1

        case .fullScreenSide(let index):
            page.offsetX = CGFloat(316) * CGFloat(index)
            page.offsetY = 0
            page.showContent = true
            page.scale = 1
            
        case .top:
            page.offsetX = -145
            page.offsetY = -(screen.height / 2.2)
            page.showContent = false
            page.scale = 0.5
            
        case .centerSmall:
            page.offsetX = 0
            page.offsetY = -25
            page.showContent = false
            page.scale = 0.5
        }
        
        page.objectWillChange.send()
    }
}
