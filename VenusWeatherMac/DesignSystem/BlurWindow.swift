import AppKit
import SwiftUI

struct BlurWindow: NSViewRepresentable {

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .fullScreenUI
        view.blendingMode = .behindWindow
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
    }
}

extension View {
    func blurBackground() -> some View {
        self
            .background(.ultraThinMaterial)
            .cornerRadius(12)
    }
}
