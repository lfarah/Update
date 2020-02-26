//
//  ReadItLater.swift
//  Update
//
//  Created by Lucas Farah on 2/25/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ReadItLater: View {    
    @ObservedObject var viewModel: ReadItLaterViewModel

    var body: some View {
        ZStack {
            Color.backgroundNeo
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            List {
                NewFeedPopup(type: .readItLater, feedURL: self.$viewModel.feedURL, addFeedPressed: self.addLink, feedAddColor: self.$viewModel.feedAddColor, attempts: self.$viewModel.attempts, show: self.$viewModel.showNewFeedPopup)
                    .padding()
                    .listRowBackground(Color.backgroundNeo)

                ForEach(viewModel.items.indices, id: \.self) { index in                    
                    Button(action: {
                        self.viewModel.selectItem(index: index)
                    })  {
                        ReadItLaterRow(item: self.viewModel.items[index])
                    }
                    .listRowBackground(Color.backgroundNeo)
                }
            }
            .padding(.top, 80)
            .sheet(isPresented: self.$viewModel.showingDetail) {
                SafariView(url: self.viewModel.selectedItem!.link)
            }

            NavBar(title: "Read it Later",
                   openNewFeed: openNewFeed,
                   showNewFeedPopup: $viewModel.showNewFeedPopup,
                   showFilter: .constant(false),
                   buttons: [NavBarButtonType.add])
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func openNewFeed() {
        viewModel.showNewFeedPopup.toggle()
    }

    func addLink() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        viewModel.addLink()
    }

}

struct ReadItLater_Previews: PreviewProvider {
    static var previews: some View {
        ReadItLater(viewModel: ReadItLaterViewModel())
    }
}

struct ReadItLaterRow: View {
    var item: ReadItLaterItem
    
    var body: some View {
        HStack {
            WebImage(url: item.imageURL)
                .renderingMode(.original)
                .resizable()
                .placeholder {
                    Rectangle().foregroundColor(.gray)
            }
            .frame(width: 40, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .padding(.leading)
            
            VStack(alignment: .leading) {
                Text(item.title!)
                    .font(.headline)
                Text(item.link.absoluteString)
                    .font(.footnote)
            }
        }
    }
}
