import SwiftUI

struct IBANPickerView: View {
    @State private var iban: String = ""
    
    let ibanSelected: (String) -> Void
    
    var body: some View {
        ZStack {
            IBANScannerView() { iban in
                self.iban = iban
            }
            if !iban.isEmpty {
                ConfirmationView(iban: iban) {
                    ibanSelected(iban)
                } retry: {
                    iban = ""
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
        .background(.black)
        .foregroundStyle(.white)
        .navigationTitle("Scanner votre IBAN")
        .toolbarRole(.editor)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
