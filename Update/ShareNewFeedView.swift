//
//  ShareNewFeedView.swift
//  ShareNewFeed
//
//  Created by Lucas Farah on 2/13/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI

enum ShareNewFeedViewType {
    
    case addFeed(urls: [String])
    case addReadItLater(url: String)
    
    var title: String {
        switch self {
        case .addFeed:
            return "Add new Feed"
        case .addReadItLater:
            return "Add link to read it later"
        }
    }
}
struct ShareNewFeedView: View {
    var type: ShareNewFeedViewType = .addFeed(urls: [])
    
    var shouldDismiss: (() -> Void)?
    @ObservedObject var store = RSSStore.instance
    @ObservedObject var readItLaterStore = ReadItLaterStore.instance

    @State var showSuccess = false
    
    
    func createList() -> AnyView {
        switch self.type {
        case .addFeed(let feeds):
            return AnyView(ForEach(feeds, id: \.self) { feed in
                Text(feed)
                    .onTapGesture {
                        guard let url = URL(string: feed) else { return }
                        self.store.addFeedFromExtension(url: url)
                        
                        self.showSuccess = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.shouldDismiss?()
                        }
                }
            })
            
        case .addReadItLater(let url):
            return AnyView(
                Text(url)
                    .onTapGesture {
                        guard let url = URL(string: url) else { return }

                        self.readItLaterStore.addItem(url: url)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.shouldDismiss?()
                        }
                    }
            )
        }

    }
    var body: some View {
        let screen = UIScreen.main.bounds
        
        return ZStack {
            NavigationView {
                List {
                    createList()
                }.navigationBarTitle(self.type.title)
            }
            Color.black.opacity(0.8)
                .offset(y: showSuccess ? 0 : screen.height)
                .allowsHitTesting(false)
            
            Text("Added to feeds list")
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 300, height: 200)
                .background(Color.purple)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .offset(y: showSuccess ? 0 : screen.height)
                .animation(.easeInOut)
        }
    }
}

struct ShareNewFeedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
        ShareNewFeedView(type: .addFeed(urls: []))
        ShareNewFeedView(type: .addReadItLater(url: "https://www.google.com/search?q=swiftui"))
        }
    }
}
