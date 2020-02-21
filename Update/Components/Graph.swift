//
//  Graph.swift
//  Update
//
//  Created by Lucas Farah on 2/17/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI
import Combine

class GraphData: Identifiable, ObservableObject {
    let id = UUID()
    var title: String
    var titleFormat: String
    var value: Int
    
    init(title: String, titleFormat: String, value: Int) {
        self.title = title
        self.titleFormat = titleFormat
        self.value = value
    }
}

struct Graph: View {
    
    @Binding var graphData: [GraphData]
    var barColor: Color?
    var textColor: Color = Color(.label)
    @Binding var showBars: Bool

    func calculateHighestValue() -> Int {
        return graphData.sorted(by: { $0.value > $1.value }).first?.value ?? 0
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom, spacing: 6) {
                ForEach(graphData) { data in
                    GraphBar(data: data,
                             maxValue: self.calculateHighestValue(),
                             width: 10,
                             barColor: self.barColor,
                             textColor: self.textColor,
                             showBar: self.$showBars)
                }
            }
        }
    }
}

struct GraphBar: View {
    var data: GraphData
    var maxValue: Int
    var width: CGFloat
    var barColor: Color?
    var textColor: Color
    @Binding var showBar: Bool

    func calculateHeight() -> CGFloat {
        guard maxValue > 0 else {
            return 0
        }
        return (CGFloat(data.value) / CGFloat(maxValue)) * 100
    }
    
    var body: some View {
        
        VStack {
            Text(String(format: data.titleFormat, data.value))
                .font(.system(size: 10))
                .foregroundColor(textColor)

            Rectangle()
                .frame(width: width, height: showBar ? calculateHeight() : 0)
                .foregroundColor(barColor ?? Color(UIColor.random))
                .animation(.easeInOut)

            Text(data.title)
                .font(.system(size: 10))
                .foregroundColor(textColor)
        }
    }
}

struct Graph_Previews: PreviewProvider {
    static var previews: some View {
        Graph(graphData: .constant((0...7).map { day in
            let today = Date()
            let date = Calendar.current.date(byAdding: .day, value: -day, to: today)!
            let title = date.toString(format: "EEE")
            return GraphData(title: title, titleFormat: "%d posts", value: Int.random(in: 0 ..< 15))
        }), showBars: .constant(true))
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
