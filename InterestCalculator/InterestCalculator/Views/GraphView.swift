//
//  GraphView.swift
//  InterestCalculator
//
//  Created by Sahil Satralkar on 18/08/24.
//

import SwiftUI

struct GraphView: View {
    let principal: Double
    let rate: Double
    let time: Double
    let compoundingFrequency: Double
    
    @State private var progress: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for x in 0...Int(geometry.size.width) {
                    let t = Double(x) / Double(geometry.size.width) * time
                    let y = calculateAmount(at: t)
                    let point = CGPoint(x: CGFloat(x), y: geometry.size.height - CGFloat(y / calculateAmount(at: time)) * geometry.size.height)
                    
                    if x == 0 {
                        path.move(to: point)
                    } else {
                        path.addLine(to: point)
                    }
                }
            }
            .trim(from: 0, to: progress)
            .stroke(Color.blue, lineWidth: 2)
            .animation(.easeInOut(duration: 2), value: progress)
            .onAppear {
                progress = 1
            }
        }
    }
    
    func calculateAmount(at time: Double) -> Double {
        let r = rate / 100
        return principal * pow((1 + r / compoundingFrequency), (compoundingFrequency * time))
    }
}

//#Preview {
//    GraphView()
//}
