//
//  FeedList.swift
//  Update
//
//  Created by Lucas Farah on 2/9/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI
import Combine
import SDWebImageSwiftUI

struct FeedList: View {
    @ObservedObject var viewModel: FeedListViewModel
    
    func filterFeeds(url: String?) -> FeedObject? {
        guard let url = url else { return nil }
        return viewModel.feeds.first(where: { $0.url.absoluteString == url })
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundNeo
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)

                List {
                    
                    NewFeedPopup(type: .feed, feedURL: $viewModel.feedURL, addFeedPressed: addFeed, feedAddColor: $viewModel.feedAddColor, attempts: $viewModel.attempts, show: $viewModel.showNewFeedPopup)
                        .padding()
                        .listRowBackground(Color.backgroundNeo)
                    
                    ForEach(viewModel.feeds.indices, id: \.self) { index in
                        NavigationLink(destination:
                        PostList(viewModel: PostListViewModel(feed:  self.viewModel.feeds[index])).environmentObject(self.viewModel.store)) {
                            FeedCell(feed: self.viewModel.feeds[index])
                        }
                            
                        .foregroundColor(.black)
                        .padding(.trailing)
                        .frame(minHeight: 100)
                        .background(Color.backgroundNeo)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .modifier(NeumorphismShadow())
                        
                    }.onDelete { index in
                        guard let index = index.first else { return }
                        self.viewModel.removeFeed(index: index)
                    }.listRowBackground(Color.backgroundNeo)
                    
                }
                .background(Color.clear)
                .padding(.top, 40)
                .sheet(isPresented: self.$viewModel.shouldPresentDetail) {
                    self.viewModel.detailPage
                }

                NavBar(title: "Feeds",
                       openNewFeed: openNewFeed,
                       showNewFeedPopup: $viewModel.showNewFeedPopup,
                       showFilter: .constant(false),
                       buttons: [.edit, .add])

                if viewModel.feeds.isEmpty {
                    FeedEmptyRow()
                }
            }
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            
            
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        
    }
    
    func openNewFeed() {
        viewModel.showNewFeedPopup.toggle()
    }
    
    func addFeed() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        viewModel.addFeed(url: viewModel.feedURL)
    }
}

let screen = UIScreen.main.bounds

struct Shake: GeometryEffect {
    var amount: CGFloat = 5
    var shakesPerUnit = 6
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                              y: 0))
    }
}
struct FeedList_Previews: PreviewProvider {
    static var previews: some View {
        FeedList(viewModel: FeedListViewModel()).environment(\.colorScheme, .light)
    }
}
