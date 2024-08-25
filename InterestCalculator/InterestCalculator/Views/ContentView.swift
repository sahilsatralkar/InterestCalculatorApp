//
//  ContentView.swift
//  InterestCalculator
//
//  Created by Sahil Satralkar on 17/08/24.
//

import SwiftUI

struct ContentView: View {
    @State private var principal = 1000.0
    @State private var rate = 5.0
    @State private var time = 5.0
    @State private var compoundingFrequency = 12.0
    @State private var result = 0.0
    @State private var showGraph = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Input")) {
                    TextField("Principal", value: $principal, format: .number)
                    TextField("Annual Interest Rate (%)", value: $rate, format: .number)
                    TextField("Time (years)", value: $time, format: .number)
                    TextField("Compounding Frequency (per year)", value: $compoundingFrequency, format: .number)
                }

                Section(header: Text("Result")) {
                    Text("Final Amount: $\(result, specifier: "%.2f")")
                    Button("Calculate") {
                        calculateCompoundInterest()
                        showGraph = true
                    }
                }

                if showGraph {
                    Section(header: Text("Graph")) {
                        GraphView(principal: principal, rate: rate, time: time, compoundingFrequency: compoundingFrequency)
                            .frame(height: 200)
                    }
                }
            }
            .navigationTitle("Compound Interest")
        }
    }

    func calculateCompoundInterest() {
        let r = rate / 100
        result = principal * pow((1 + r / compoundingFrequency), (compoundingFrequency * time))
    }
}

#Preview {
    ContentView()
}
