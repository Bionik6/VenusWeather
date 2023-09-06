import SwiftUI
import Foundation


public struct RedactAndShimmerViewModifier: ViewModifier {
    private let condition: Bool


    init(condition: Bool) {
        self.condition = condition
    }

    public func body(content: Content) -> some View {
        if condition {
            content
                .redacted(reason: .placeholder)
                .shimmering()
        } else {
            content
        }
    }
}


extension View {
    public func redactAndShimmer(condition: Bool) -> some View {
        modifier(RedactAndShimmerViewModifier(condition: condition))
    }
}
