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
                    Label("Compound", systemImage: "arrow.up.right")
                }
            LoanCalculatorView()
                .tabItem {
                    Label("Loan", systemImage: "plus.forwardslash.minus")
                }
            SimpleSavingsView()
                .tabItem {
                    Label("Savings", systemImage: "arrow.turn.right.up")
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
