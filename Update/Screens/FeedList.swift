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
    @ObservedObject var store = RSSStore()
    @State var showNewFeedPopup = false
    @State var feedURL: String = ""
    @State var feedAddColor: Color = .blue
    @State var attempts: Int = 0

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(store.feeds) { feed in
                        NavigationLink(destination: PostList(feed: feed)) {
                            FeedCell(feed: feed)
                        }
                    }.onDelete { index in
                        self.store.removeFeed(at: index.first!)
                    }
                }
                .navigationBarTitle("Feeds")
                .navigationBarItems(trailing: Button(action: openNewFeed) {
                    Text("New Feed")
                })
                
                VStack {
                    
                    VStack {
                        ZStack {
                            Text("Feed URL")
                                .font(.title)
                                .foregroundColor(.white)
                            
                            HStack {
                                Spacer()
                                Button(action: openNewFeed) {
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
                        Button(action: addFeed) {
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
                    .offset(x: 0, y: showNewFeedPopup ? 200 : screen.height)
                    .animation(Animation.easeInOut(duration: 1).delay(1))
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.6))
                .edgesIgnoringSafeArea(.all)
                .opacity(showNewFeedPopup ? 1 : 0)
                .animation(Animation.easeIn(duration: 0.2).delay(showNewFeedPopup ? 0: 0.5))

            }
        }
    }
    
    func openNewFeed() {
        showNewFeedPopup.toggle()
    }
    
    func addFeed() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        guard let url = URL(string: feedURL) else { return }
        
        store.update(feedURL: url) { success in
            self.feedAddColor = success ? Color.green : Color.red
            
            if success {
                self.showNewFeedPopup = false
            } else {
                self.attempts += 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.feedAddColor = .blue
            }
        }
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
        FeedList().environment(\.colorScheme, .dark)
    }
}
