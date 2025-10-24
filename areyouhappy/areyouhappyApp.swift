//
//  areyouhappyApp.swift
//  areyouhappy
//
//  Created by Ethan Lopez on 10/23/25.
//

import SwiftUI

@main
struct areyouhappyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(BackgroundWindowModifier())
                .frame(width: 300, height: 130)
                .toolbar(removing: .title)
        }
        .windowResizability(.contentSize)
        
    }
}

struct BackgroundWindowModifier: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                window.standardWindowButton(.closeButton)?.isHidden = false
                window.standardWindowButton(.miniaturizeButton)?.isHidden = true
                window.standardWindowButton(.zoomButton)?.isHidden = true
                window.titlebarAppearsTransparent = true
            }
        }
        return view
    }
    func updateNSView(_ nsView: NSView, context: Context) {}
}
