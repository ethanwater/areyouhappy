//
//  ContentView.swift
//  areyouhappy
//
//  Created by Ethan Lopez on 10/23/25.
//

import SwiftUI

class WindowBackedHelperView: NSView {
    var didMoveToWindow: (NSWindow) -> Void
    
    init(didMoveToWindow: @escaping (NSWindow) -> Void) {
        self.didMoveToWindow = didMoveToWindow
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        guard let window else {
            return
        }
        didMoveToWindow(window)
    }
}

struct WindowBackedView: NSViewRepresentable {
    typealias NSViewType = WindowBackedHelperView
    
    var didMoveToWindow: (NSWindow) -> Void
    
    func makeNSView(context: Context) -> WindowBackedHelperView {
        WindowBackedHelperView {
            didMoveToWindow($0)
        }
    }
    
    func updateNSView(_ nsView: WindowBackedHelperView, context: Context) {
        
    }
}

struct DidMoveToWindowModifier: ViewModifier {
    var didMoveToWindow: (NSWindow) -> Void
    
    func body(content: Content) -> some View {
        content
            .background(
                WindowBackedView {
                    didMoveToWindow($0)
                }
            )
    }
}

extension View {
    func didMoveToWindow(_ completion: @convention(block) @escaping (NSWindow) -> Void) -> some View {
        self.modifier(DidMoveToWindowModifier(didMoveToWindow: completion))
    }
}

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isHoveredNo = false
    @State private var isHoveredYes = false
    @State private var headerText = ""
    @State private var questionText = "Are you happy?"
    @State private var showButtons = true
    @State private var currentWindow: NSWindow?

    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                GIFView(gifName: "heart")
                    .frame(width: 60, height: 60)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hi!")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    Text(questionText)
                        .font(.subheadline)
                        .animation(.easeInOut(duration: 0.3), value: questionText)
                        .foregroundColor(.black)
                }
            }
            
            if showButtons {
                HStack(spacing: 12) {
                    Button(action: {
                        handleResponse()
                    }) {
                        Text("Yes")
                            .foregroundColor(isHoveredYes ? .white : .black)
                            .padding(5)
                            .fontWeight(.light)
                            .controlSize(.regular)
                            .buttonStyle(.borderedProminent)
                            .frame(width: 45, height: 20)
                    }
                    .buttonStyle(.plain)
                    .background(
                                            ZStack {
                                                // Base layer
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(isHoveredYes ? Color.red : Color.white.opacity(0.9))
                                                
                                                // Border
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(Color.black.opacity(0.4), lineWidth: 1.0)
                                                    .padding(0.5)
                                            }
                                        )
                    .scaleEffect(isHoveredYes ? 1.025 : 1.0)
                    //.animation(.spring(response: 0.3, dampingFraction: 0.6), value: isHoveredYes)
                    .onHover { hovering in
                        isHoveredYes = hovering
                    }
                    .glassEffect()
                    
                    
                    Button(action: {
                        handleResponse()
                    }) {
                        Text("No")
                            .foregroundColor(isHoveredNo ? .white : .black)
                            .fontWeight(.light)
                            .controlSize(.regular)
                            .buttonStyle(.borderedProminent)
                            .frame(width: 45, height: 20)
                    }
                    .buttonStyle(.plain)
                    .background(
                                            ZStack {
                                                // Base layer
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(isHoveredNo ? Color.red : Color.white.opacity(0.9))
                                                
                                                // Border
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(Color.black.opacity(0.4), lineWidth: 1.0)
                                                    .padding(0.5)
                                            }
                                        )
                    .scaleEffect(isHoveredNo ? 1.025 : 1.0)
                    //.animation(.spring(response: 0.3, dampingFraction: 0.6), value: isHoveredNo)
                    .onHover { hovering in
                        isHoveredNo = hovering
                    }
                    .glassEffect()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .didMoveToWindow { window in
            currentWindow = window
            window.isOpaque = false
            window.backgroundColor = NSColor(white: 1.0, alpha: 1.0)
            // This prevents the background from resetting
            if let contentView = window.contentView {
                contentView.wantsLayer = true
                contentView.layer?.backgroundColor = NSColor(white: 1.0, alpha: 0.0).cgColor
            }
        }
    }
    
    private func handleResponse() {
        NSApplication.shared.terminate(nil)
    }
}


#Preview {
    ContentView()
}
