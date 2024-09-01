//
//  SettingsView.swift
//  InterestCalculator
//
//  Created by Sahil Satralkar on 01/09/24.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var selectedCurrency = "$"
    let currencies = ["$","€","¥","£","₨"]
    
    var body: some View {
        NavigationView {
            List {
                //TODO: Add Selected currency
                //                Section {
                //                    Picker("", selection: $selectedCurrency) {
                //                        SettingsLabelRow(icon: "dollarsign.square.fill", color: .gray, text: "Select currency", value: selectedCurrency)
                //                    }
                //                    SettingsLabelRow(icon: "dollarsign.square.fill", color: .gray, text: "Select currency", value: selectedCurrency)
                //                }
                Section {
                    SettingsLabelRow(icon: "star.fill", color: .blue, text: "Rate this app")
                        .onTapGesture {
                            rateApp()
                        }
                    SettingsLabelRow(icon: "square.and.arrow.up.fill", color: .gray, text: "Share this app")
                        .onTapGesture {
                            shareApp()
                        }
                }
                Section {
                    SettingsLabelRow(icon: "envelope.fill", color: .cyan, text: "Contact")
                        .onTapGesture {
                            contactUs()
                        }
                    SettingsLabelRow(icon: "hand.raised.fill", color: .green, text: "Privacy policy")
                        .onTapGesture {
                            openPrivacyPolicy()
                        }
                    SettingsLabelRow(icon: "doc.fill", color: .indigo, text: "Terms and conditions")
                        .onTapGesture {
                            openTermsAndConditions()
                        }
                }
                Section {
                    SettingsLabelRow(icon: "person.fill", color: .mint, text: "About me")
                        .onTapGesture {
                            contactUs()
                        }
                    SettingsLabelRow(icon: "hand.thumbsup.fill", color: .orange, text: "Try my other apps")
                        .onTapGesture {
                            tryOtherApps()
                        }
                }
                Section(header: Text(LocalizedStringKey("About")), footer:
                            Text(LocalizedStringKey("Made with love by Sahil Satralkar"))
                            .frame(maxWidth: .infinity, alignment: .center)
                ){
                    
                    NavigationLink(
                        destination: Text("Additional info")){
                            SettingsLabelRow(icon: "text.bubble", color: .green, text: "Additional information")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func rateApp() {
        guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id<YOUR_APP_ID>?action=write-review")
        else { return }
        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }
    
    func shareApp() {
        //TODO: Replace App id with correct value
        guard let url = URL(string: "https://apps.apple.com/app/id1551311809")
        else { return }
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            rootViewController.present(activityViewController, animated: true, completion: nil)
        }

    }
    
    func contactUs() {
        guard let email = "sahil.satralkar@gmail.com".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "mailto:\(email)")
        else { return }
        UIApplication.shared.open(url)
    }
    
    func openPrivacyPolicy() {
        guard let url = URL(string: "https://www.yourapp.com/privacy-policy")
        else { return }
        UIApplication.shared.open(url)
    }
    
    func openTermsAndConditions() {
        guard let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")
        else { return }
        UIApplication.shared.open(url)
    }
    
    func tryOtherApps() {
        guard let url = URL(string: "https://apps.apple.com/developer/your-developer-name/idf2115f1e-c63c-4bd6-b4b8-23579829b1ee")
        else { return }
        UIApplication.shared.open(url)
    }
}

struct SettingsToggleRow: View {
    let icon: String
    let color: Color
    let text: String
    @State private var isOn = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 29, height: 29)
                .background(color)
                .cornerRadius(6)
            Text(text)
            Spacer()
            Toggle("", isOn: $isOn)
        }
    }
}

struct SettingsLabelRow: View {
    let icon: String
    let color: Color
    let text: String
    var value: String?
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 29, height: 29)
                .background(color)
                .cornerRadius(6)
            Text(text)
            Spacer()
            if let value = value {
                Text(value)
                    .foregroundColor(.gray)
            }
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .frame(width: 12, height: 12)
                .cornerRadius(6)
        }
    }
}

public extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
        
        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }

        return window
        
    }
}
