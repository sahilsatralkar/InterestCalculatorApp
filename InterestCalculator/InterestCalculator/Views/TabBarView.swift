//
//  TabView.swift
//  InterestCalculator
//
//  Created by Sahil Satralkar on 18/08/24.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            CompoundInterestGraph()
                .tabItem {
                    Label("Compound Interest", systemImage: "arrow.up.forward")
                }
            LoanCalculatorGraph()
                .tabItem {
                    Label("Car loan", systemImage: "car")
                }
            MonthlyDepositGraph()
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
