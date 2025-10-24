//
//  handleGif.swift
//  areyouhappy
//
//  Created by Ethan Lopez on 10/23/25.
//

import Foundation
import SwiftUI
import AppKit

struct GIFView: NSViewRepresentable {
    let gifName: String

    func makeNSView(context: Context) -> NSImageView {
        let imageView = NSImageView()
        imageView.canDrawSubviewsIntoLayer = true
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.wantsLayer = true // Helps with rendering
        
        if let gifURL = Bundle.main.url(forResource: gifName, withExtension: "gif"),
           let gifData = try? Data(contentsOf: gifURL),
           let image = NSImage(data: gifData) {
            imageView.image = image
            imageView.animates = true
        }
        
        return imageView
    }

    func updateNSView(_ nsView: NSImageView, context: Context) {
        // Force the image view to respect the frame
        nsView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        nsView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        nsView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nsView.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}
