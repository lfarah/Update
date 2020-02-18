//
//  Graph.swift
//  Update
//
//  Created by Lucas Farah on 2/17/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI

struct GraphData: Identifiable {
    let id = UUID()
    var title: String
    var titleFormat: String
    var value: Int
}

struct Graph: View {
    
    @State var graphData: [GraphData]
    
    func calculateHighestValue() -> Int {
        return graphData.sorted(by: { $0.value > $1.value }).first?.value ?? 0
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom, spacing: 6) {
                ForEach(graphData) { data in
                    GraphBar(data: data,
                             maxValue: self.calculateHighestValue(),
                             width: 10)
                }
            }
        }
    }
}

struct GraphBar: View {
    var data: GraphData
    var maxValue: Int
    var width: CGFloat
    
    func calculateHeight() -> CGFloat {
        return (CGFloat(data.value) / CGFloat(maxValue)) * 100
    }
    
    var body: some View {
        
        VStack {
            Text(String(format: data.titleFormat, data.value))
                .font(.system(size: 10))

            Rectangle()
                .frame(width: width, height: calculateHeight())
                .foregroundColor(Color(UIColor.random))
            
            Text(data.title)
                .font(.system(size: 10))
        }
    }
}

struct Graph_Previews: PreviewProvider {
    static var previews: some View {
        Graph(graphData: (0...7).map { day in
            let today = Date()
            let date = Calendar.current.date(byAdding: .day, value: -day, to: today)!
            let title = date.toString(format: "EEE")
            return GraphData(title: title, titleFormat: "%d posts", value: Int.random(in: 0 ..< 15))
        })
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
}

extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
