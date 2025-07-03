import SwiftUI

struct BottomLineTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack() {
            configuration
                .padding(.top, 5)
                .foregroundStyle(.white)
            Rectangle()
                .frame(height: 1.0, alignment: .bottom)
                .foregroundColor(.textFieldPlaceholder)
                .padding(.bottom, 2)
        }
        .padding(.horizontal)
        .background() {
            RoundedRectangle(cornerRadius: 10)
                .fill(.textFieldBackground)
        }
    }
}

extension TextFieldStyle where Self == BottomLineTextFieldStyle {
    static var bottomLineTextField: BottomLineTextFieldStyle {
        BottomLineTextFieldStyle()
    }
}
