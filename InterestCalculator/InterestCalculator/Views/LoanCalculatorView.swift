//
//  LoanCalculatorView.swift
//  InterestCalculator
//
//  Created by Sahil Satralkar on 25/08/24.
//

import SwiftUI
import Charts
import Photos

struct LoanCalculatorView: View {
    @State private var loanAmount = 20000.0
    @State private var interestRate = 5.0
    @State private var years = 10
    
    @State private var debouncedLoanAmount = 20000.0
    @State private var debouncedInterestRate = 5.0
    @State private var debouncedYears = 10
    
    @State private var isShareSheetForLoanCalculPresented = false
    @State private var capturedImage: UIImage?
    
    @State private var totalPayment: Double = 0.0
    @State private var totalInterest: Double = 0.0
    @State private var principalAmount: Double = 0.0
    
    @State var data: [(name: String, value: Double)] = [
        (name: "Principal", value: 20000.0),
        (name: "Interest", value: 10000.0)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Pie chart")) {
                        ZStack {
                            Chart(data, id: \.name) { name, value in
                                SectorMark(angle: .value("Value", value))
                                    .foregroundStyle(by: .value("Category", name))
                                    .annotation(position: .overlay) {
                                        Text("\(name):\n\(Int(value))")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                    }
                            }
                            .frame(height: UIScreen.main.bounds.width / 1.8)
                            .padding()
                        }
                    }
                    
                    Section(header: Text("Specifications")) {
                        VStack(alignment: .leading) {
                            Text("Principal: $\(Int(loanAmount))")
                            Slider(value: $loanAmount, in: 500...100_000, step: 500)
                                .onChange(of: loanAmount) {
                                    updateValues()
                                }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Interest Rate: \(interestRate, specifier: "%.1f")%")
                            Slider(value: $interestRate, in: 1...20, step: 0.5)
                                .onChange(of: interestRate) { updateValues() }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Years: \(years)")
                            Slider(value: Binding(
                                get: { Double(years) },
                                set: { years = Int($0) }
                            ), in: 1...50, step: 1)
                                .onChange(of: years) {updateValues() }
                        }
                    }
                }
            }
            .onAppear(perform: {
                updateValues()
            })
            .navigationTitle("Loan Calculator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: shareScreen) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }
    
    func updateValues() {
        debouncedLoanAmount = loanAmount
        debouncedInterestRate = interestRate
        debouncedYears = years
        
        totalPayment = calculateTotalPayment()
        totalInterest = calculateTotalInterest()
        principalAmount = loanAmount
        
        data = [
            (name: "Principal", value: principalAmount),
            (name: "Interest", value: totalInterest)
        ]
    }
    
    func calculateTotalPayment() -> Double {
        let rate = debouncedInterestRate / 100 / 12
        let periods = debouncedYears * 12
        let monthlyPayment = (debouncedLoanAmount * rate * pow(1 + rate, Double(periods))) / (pow(1 + rate, Double(periods)) - 1)
        return monthlyPayment * Double(periods)
    }
    
    func calculateTotalInterest() -> Double {
        return calculateTotalPayment() - debouncedLoanAmount
    }
}
