import SwiftUI
import Charts
import Photos

struct CompoundInterestView: View {
    @State private var principal = 10000.0
    @State private var interestRate = 8.0
    @State private var years = 30
    
    @State private var debouncedPrincipal = 10000.0
    @State private var debouncedInterestRate = 8.0
    @State private var debouncedYears = 30
    
    @State private var principalTimer: Timer?
    @State private var interestRateTimer: Timer?
    @State private var yearsTimer: Timer?
    
    @State private var selectedX: Int?
    @State private var selectedY: Double?
    
    @State private var isShareSheetPresented = false
    @State private var capturedImage: UIImage?
    
    private let timeInterval: Double = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Interactive Graph")) {
                        ZStack {
                            Chart {
                                ForEach(0...debouncedYears, id: \.self) { year in
                                    LineMark(
                                        x: .value("Year", year),
                                        y: .value("Amount", calculateCompoundInterest(year: year))
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
                                                    selectedY = calculateCompoundInterest(year: selectedX!)
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
                    Section(header: Text("Specifications")) {
                        VStack(alignment: .leading) {
                            Text("Principal: $\(Int(principal))")
                            Slider(value: $principal, in: 500...500_000, step: 500) { _ in
                                debounce(\.debouncedPrincipal, value: principal, timer: &principalTimer)
                            }
                            .onChange(of: principal, {
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
            .navigationTitle("Compound Interest Calculator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: shareGraph) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            .sheet(isPresented: $isShareSheetPresented) {
                if let image = capturedImage {
                    ShareSheet(activityItems: [image])
                }
            }
        }
    }
    
    func debounce<T>(_ keyPath: ReferenceWritableKeyPath<CompoundInterestView, T>, value: T, timer: inout Timer?) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
            self[keyPath: keyPath] = value
        }
    }
    
    func calculateCompoundInterest(year: Int) -> Double {
        return debouncedPrincipal * pow(1 + debouncedInterestRate / 100, Double(year))
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
        isShareSheetPresented = true
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

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

