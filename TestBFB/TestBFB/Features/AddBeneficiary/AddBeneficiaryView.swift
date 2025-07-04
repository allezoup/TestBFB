import SwiftUI

struct AddBeneficiaryView: View {
    @State private var path = NavigationPath()
    @State private var model = AddBeneficiaryViewModel()
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack {
                    Text("Ajouter un bénéficiaire")
                        .font(.title)
                        .padding()
                    Text("Scannez, importez ou saisissez l'IBAN")
                        .font(.headline)
                        .padding()
                    
                    HStack {
                        Spacer()
                        Button("Scanner", systemImage: "camera.fill") {
                            path.append("cameraView")
                        }.buttonType(.action)
                        Spacer()
                        Button("Importer", systemImage: "square.and.arrow.up") {
                        }.buttonType(.action)
                        Spacer()
                    }
                    .padding(.bottom)
                    
                    TextField("", text: $model.iban, prompt: Text("FR76 XXXX").foregroundColor(.textFieldPlaceholder))
                        .disableAutocorrection(true)
                        .textFieldStyle(.bottomLineTextField)
                        .padding(.bottom)
                        .limitInputLength(value: $model.iban, length: 27)
                    
                    
                    if (model.isIBANValid) {
                        VStack(alignment: .leading) {
                            Toggle("Vous êtes titulaire du compte", isOn: $model.isOwner)
                                .padding(.bottom)
                            Text("Nom du bénéficiaire")
                            TextField("Nom du bénéficiaire", text: $model.beneficiaryName)
                                .disableAutocorrection(true)
                                .textFieldStyle(.bottomLineTextField)
                                .padding(.bottom)
                            Text("Libellé du compte")
                            TextField("Libellé du compte", text: $model.accountLabel)
                                .disableAutocorrection(true)
                                .textFieldStyle(.bottomLineTextField)
                                .padding(.bottom)
                            
                            Text("Attention: les propositions de placements financiers miraculeux (tous placements atypiques à fort rendement...) sont le plus souvent des arnaques. Vérifiez systématiquement sur le site de l'Autorité des Marchés Financiers (AMF), en particulier avant tout virement vers l'étranger. Le Service Client BforBank se tient également à votre disposition.")
                        }
                        .padding(.bottom)
                        
                        Button() {
                            model.addBenificiary()
                        } label: {
                            Text("Valider")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonType(.primaryAction)
                        .disabled(!model.isValid)
                        .padding()
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationDestination(for: String.self) { textValue in
                    IBANPickerView() { iban in
                        self.model.iban = iban
                        path = NavigationPath()
                    }
                    
                }
            }
            .background(.black)
            .foregroundColor(.white)

        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    AddBeneficiaryView()
}
