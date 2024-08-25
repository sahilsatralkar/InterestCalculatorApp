//
//  SimpleSavingsCalculator.swift
//  InterestCalculator
//
//  Created by Sahil Satralkar on 25/08/24.
//

import SwiftUI
import Charts
import Photos

struct MonthlyDepositGraph: View {
    @State private var monthlyDeposit = 500.0
    @State private var interestRate = 8.0
    @State private var years = 30
    
    @State private var debouncedMonthlyDeposit = 500.0
    @State private var debouncedInterestRate = 8.0
    @State private var debouncedYears = 30
    
    @State private var monthlyDepositTimer: Timer?
    @State private var interestRateTimer: Timer?
    @State private var yearsTimer: Timer?
    
    @State private var selectedX: Int?
    @State private var selectedY: Double?
    
    @State private var isShareSheetForSimpleSavingsForSimpleSavingsPresented = false
    @State private var capturedImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Compound Interest")) {
                        ZStack {
                            Chart {
                                ForEach(0...debouncedYears, id: \.self) { year in
                                    LineMark(
                                        x: .value("Year", year),
                                        y: .value("Amount", calculateFutureValue(year: year))
                                    )
                                }
                                if let selectedX = selectedX, let selectedY = selectedY {
                                    PointMark(
                                        x: .value("Year", selectedX),
                                        y: .value("Amount", selectedY)
                                    )
                                    .foregroundStyle(.red)
                                }
                            }
                            .chartXAxis {
                                AxisMarks(values: .automatic(desiredCount: 5)) { value in
                                    if let year = value.as(Int.self) {
                                        AxisValueLabel {
                                            Text("\(year)")
                                                .padding(.bottom, 5)
                                        }
                                    }
                                }
                            }
                            .chartYAxis {
                                AxisMarks(position: .leading) { _ in
                                    // Remove values but keep the axis line
                                    AxisGridLine()
                                }
                            }
                            .frame(height: UIScreen.main.bounds.width / 1.8)
                            .padding()
                            .onTapGesture {
                                // Clear selection when tapping outside
                                selectedX = nil
                                selectedY = nil
                            }
                            .overlay(
                                GeometryReader { geometry in
                                    Rectangle()
                                        .fill(Color.clear)
                                        .contentShape(Rectangle())
                                        .gesture(
                                            DragGesture(minimumDistance: 0)
                                                .onChanged { value in
                                                    let x = value.location.x / geometry.size.width
                                                    let year = Int(x * Double(debouncedYears))
                                                    selectedX = min(max(year, 0), debouncedYears)
                                                    selectedY = calculateFutureValue(year: selectedX!)
                                                }
                                        )
                                }
                            )
                            
                            if let selectedX = selectedX, let selectedY = selectedY {
                                VStack {
                                    Text("Year \(selectedX)")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                    Text("$\(Int(selectedY))")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                }
                                .padding(8)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 5)
                                .position(
                                    x: (UIScreen.main.bounds.width / 2.5),
                                    y: 50
                                )
                            }
                        }
                    }                    
                    Section(header: Text("Parameters")) {
                        VStack(alignment: .leading) {
                            Text("Monthly Deposit: $\(Int(monthlyDeposit))")
                            Slider(value: $monthlyDeposit, in: 100...10000, step: 100) { _ in
                                debounce(\.debouncedMonthlyDeposit, value: monthlyDeposit, timer: &monthlyDepositTimer)
                            }
                            .onChange(of: monthlyDeposit, {
                                selectedX = nil
                                selectedY = nil
                            })
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Interest Rate: \(interestRate, specifier: "%.1f")%")
                            Slider(value: $interestRate, in: 1...20, step: 0.5) { _ in
                                debounce(\.debouncedInterestRate, value: interestRate, timer: &interestRateTimer)
                            }
                            .onChange(of: interestRate, {
                                selectedX = nil
                                selectedY = nil
                            })
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Years: \(years)")
                            Slider(value: Binding(
                                get: { Double(years) },
                                set: { years = Int($0) }
                            ), in: 1...50, step: 1) { _ in
                                debounce(\.debouncedYears, value: Int(Double(years)), timer: &yearsTimer)
                            }
                            .onChange(of: years, {
                                selectedX = nil
                                selectedY = nil
                            })
                        }
                    }
                }
            }
            .navigationTitle("Monthly Deposits")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: shareGraph) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            .sheet(isPresented: $isShareSheetForSimpleSavingsForSimpleSavingsPresented) {
                if let image = capturedImage {
                    ShareSheetForSimpleSavingsForSimpleSavings(activityItems: [image])
                }
            }
        }
    }
    
    func debounce<T>(_ keyPath: ReferenceWritableKeyPath<MonthlyDepositGraph, T>, value: T, timer: inout Timer?) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            self[keyPath: keyPath] = value
        }
    }
    
    func calculateFutureValue(year: Int) -> Double {
        let rate = debouncedInterestRate / 100 / 12
        let periods = year * 12
        let futureValue = monthlyDeposit * ((pow(1 + rate, Double(periods)) - 1) / rate)
        return futureValue
    }
    
    func shareGraph() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootView = window.rootViewController?.view else {
            return
        }

        let renderer = UIGraphicsImageRenderer(size: rootView.bounds.size)
        let image = renderer.image { _ in
            rootView.drawHierarchy(in: rootView.bounds, afterScreenUpdates: true)
        }

        // Save the image to Photos
        saveImageToPhotos(image: image)
        
        capturedImage = image
        isShareSheetForSimpleSavingsForSimpleSavingsPresented = true
    }
    
    func saveImageToPhotos(image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            } else {
                print("Photo library access not granted.")
            }
        }
    }
}

struct ShareSheetForSimpleSavingsForSimpleSavings: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
