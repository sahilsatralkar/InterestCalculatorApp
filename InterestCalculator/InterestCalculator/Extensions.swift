//
//  Extensions.swift
//  InterestCalculator
//
//  Created by Sahil Satralkar on 02/09/24.
//

import SwiftUI

extension UIView {
    func snapshot() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        return renderer.image { _ in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
    }
}

extension View {
    func shareScreen() {
        // Find the active UIWindowScene
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootView = windowScene.windows.first?.rootViewController?.view {
            
            // Ensure the view is fully laid out
            rootView.layoutIfNeeded()
            
            // Capture the snapshot of the view
            if let image = rootView.snapshot() {
                let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                
                // Present the share sheet
                rootView.window?.rootViewController?.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
}
