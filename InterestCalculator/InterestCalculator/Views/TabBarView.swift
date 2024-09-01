//
//  TabBarView.swift
//  InterestCalculator
//
//  Created by Sahil Satralkar on 18/08/24.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            CompoundInterestView()
                .tabItem {
                    Label("Compound Interest", systemImage: "arrow.up.forward")
                }
            LoanCalculatorView()
                .tabItem {
                    Label("Car loan", systemImage: "car")
                }
            SimpleSavingsView()
                .tabItem {
                    Label("Simple Savings", systemImage: "percent")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}


#Preview {
    TabBarView()
}
