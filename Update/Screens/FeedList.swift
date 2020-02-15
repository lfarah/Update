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
    @ObservedObject var store = RSSStore.instance
    @State var showNewFeedPopup = false
    @State var feedURL: String = ""
    @State var feedAddColor: Color = Color.backgroundNeo
    @State var attempts: Int = 0

    func filterFeeds(url: String?) -> FeedObject? {
        guard let url = url else { return nil }
        return store.feeds.first(where: { $0.url.absoluteString == url })
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundNeo
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                List {
                    
                    NewFeedPopup(feedURL: $feedURL, addFeedPressed: addFeed, feedAddColor: $feedAddColor, attempts: $attempts, show: $showNewFeedPopup)
                        .padding()
                        .listRowBackground(Color.backgroundNeo)
                    
                    ForEach(store.feeds.indices, id: \.self) { index in
                        NavigationLink(destination: PostList(feed: self.$store.feeds[index])) {
                            FeedCell(feed: self.store.feeds[index])
                        }
                            
                        .foregroundColor(.black)
                        .padding(.trailing)
                        .frame(minHeight: 100)
                        .background(Color.backgroundNeo)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: Color.shadowTopNeo, radius: 5, x: -4, y: -4)
                        .shadow(color: Color.shadowBottomNeo, radius: 5, x: 4, y: 4)
                        
                    }.onDelete { index in
                        self.store.removeFeed(at: index.first!)
                    }.listRowBackground(Color.backgroundNeo)

                }
                .background(Color.clear)
                .padding(.top, 100)
                .sheet(isPresented: self.$store.shouldSelectFeed) {
                    NavigationView {
                        PostList(feed: Binding(self.$store.shouldSelectFeedObject)!)
                            .navigationBarItems(leading:
                                Button(action: {
                                    self.store.shouldSelectFeed = false
                                }, label: {
                                    Text("Close")
                                })
                        )
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    
                }
                .sheet(isPresented: self.$store.shouldOpenSettings) {
                    SettingsView(fetchContentTime: self.$store.fetchContentTime, notificationsEnabled: self.$store.notificationsEnabled, shouldOpenSettings: self.$store.shouldOpenSettings)
                }
                
                NavBar(title: "Feeds",
                       openNewFeed: openNewFeed,
                       showNewFeedPopup: $showNewFeedPopup,
                       showFilter: .constant(false),
                       buttons: [.edit, .add])
                
            }
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
            
        }        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        
    }
    
    func openNewFeed() {
        showNewFeedPopup.toggle()
    }
    
    func addFeed() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        guard let url = URL(string: feedURL) else { return }
        
        store.addFeed(feedURL: url) { success in
            self.feedAddColor = success ? Color.green : Color.red
            
            if success {
                self.showNewFeedPopup = false
            } else {
                self.attempts += 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.feedAddColor = Color.backgroundNeo
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
        FeedList().environment(\.colorScheme, .light)
    }
}

struct SettingsView: View {
    @Binding var fetchContentTime: String
    @Binding var notificationsEnabled: Bool
    @Binding var shouldOpenSettings: Bool
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    Form {
                        Picker(selection: $fetchContentTime, label: Text("Fetch content time")) {
                            ForEach(ContentTimeType.allCases, id: \.self.rawValue) { type in
                                Text(type.rawValue)
                            }
                        }
                        Toggle(isOn: $notificationsEnabled) {
                            Text("Enable Notifications")
                        }
                    }
                }
                .navigationBarTitle(Text("Settings"))
                .navigationBarItems(leading:
                    Button(action: {
                        self.shouldOpenSettings = false
                    }, label: {
                        Text("Close")
                    }
                    )
                )
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
