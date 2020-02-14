//
//  ShareNewFeedView.swift
//  ShareNewFeed
//
//  Created by Lucas Farah on 2/13/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI

struct ShareNewFeedView: View {
    var feeds: [String] = []
    var shouldDismiss: (() -> Void)?
    @ObservedObject var store = RSSStore.instance
    @State var showSuccess = false
    
    var body: some View {
        let screen = UIScreen.main.bounds
        
        return ZStack {
            NavigationView {
                List {
                    ForEach(feeds, id: \.self) { feed in
                        Text(feed)
                            .onTapGesture {
                                guard let url = URL(string: feed) else { return }
                                self.store.addFeedFromExtension(url: url)
                                
                                self.showSuccess = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    self.shouldDismiss?()
                                }
                        }
                    }
                }.navigationBarTitle("Add new feed")
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
        ShareNewFeedView()
    }
}
