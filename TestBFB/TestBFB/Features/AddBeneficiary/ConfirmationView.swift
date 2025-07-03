import SwiftUI

struct ConfirmationView: View {
    var iban: String
    
    let confirm: () -> Void
    let retry: () -> Void
    
    var body: some View {
        VStack {
            Text("L'IBAN du bénéficiaire a été scanné")
                .fontWeight(.bold)
                .padding()
            Text("Pensez à le vérifier avant de valider :")
                .padding(.bottom)
            Text("\(iban)")
                .fontWeight(.bold)
                .padding(.bottom)
            VStack {
                Button() {
                    confirm()
                } label: {
                    Text("Valider")
                        .frame(maxWidth: .infinity)
                }
                .buttonType(.primaryAction)
                
                Button() {
                    retry()
                } label: {
                    Text("Recommancer")
                        .frame(maxWidth: .infinity)
                }
                .buttonType(.secondaryAction)
            }
            .padding([.leading, .trailing], 50)
        }
        .padding()
        .background(.secondaryBackground)
        .foregroundColor(.white)
        .roundedCorner(10, corners: [.topLeft, .topRight])
    }
}

#Preview {
    VStack(alignment: .leading) {
        ConfirmationView(iban: "FR4354004345650000009823V") {
            
        } retry: {
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
}

