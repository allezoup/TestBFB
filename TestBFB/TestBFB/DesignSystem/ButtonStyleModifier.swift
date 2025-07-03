import SwiftUI

public enum ButtonType {
    case action
    case primaryAction
    case secondaryAction
}

public struct ButtonStyle: ViewModifier {
    let type: ButtonType
    
    public func body(content: Content) -> some View {
        switch type {
        case .action:
            content
                .foregroundStyle(.tint)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.tint, lineWidth: 1)
                )
        case .primaryAction:
            content
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
        case .secondaryAction:
            content
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
        }
    }
}

extension Button {
    public func buttonType(_ type: ButtonType) -> some View {
        modifier(ButtonStyle(type: type))
    }
}
