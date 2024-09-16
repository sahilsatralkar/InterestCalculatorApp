//
//  TabBarView.swift
//  InterestCalculator
//
//  Created by Sahil Satralkar on 18/08/24.
//

import SwiftUI

struct TabBarView: View {
    
    @Environment(\.requestReview) private var requestReview
    
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
        .onAppear {
            presentReview()
        }
    }
    
    private func presentReview() {
        Task {
            // Delay for ten seconds to avoid interrupting the person using the app.
            try await Task.sleep(for: .seconds(10))
            await requestReview()
        }
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}



#Preview {
    TabBarView()
}
