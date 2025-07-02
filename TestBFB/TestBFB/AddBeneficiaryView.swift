//
//  ContentView.swift
//  TestBFB
//
//  Created by Frédéric König on 02/07/2025.
//

import SwiftUI

struct AddBeneficiaryView: View {
    @State private var iban = ""
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text("Ajouter un bénéficiaire").font(.title)
                    .padding()
                Text("Scannez, importez ou saisissez l'IBAN")
                    .font(.headline)
                    .padding()
                
                HStack {
                    Spacer()
                   
                    Button {
                        path.append("cameraView")
                    } label: {
                        Image(systemName: "camera.fill")
                        Text("Scanner")
                    }
                    .foregroundStyle(.tint)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.tint, lineWidth: 1)
                    )
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                        Text("Importer")
                    }
                    .foregroundStyle(.tint)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.tint, lineWidth: 1)
                    )

                    Spacer()
                }
                .padding(.bottom)
                
                TextField("", text: $iban, prompt: Text("FR76 XXXX").foregroundColor(.textFieldPlaceholder))
                    .padding()
                    .background(.textFieldBackground)
                    
                    .foregroundStyle(.white)
                
                if (!iban.isEmpty) {
                    Text("Afficher le reste")
                }
                
                Spacer()
            }
            .padding()
            .background(.black)
            .foregroundColor(.white)
            .navigationDestination(for: String.self) { textValue in
                CameraScanView() { iban in
                    self.iban = iban
                    path = NavigationPath()
                }
            }
        }
        .navigationBarTitleTextColor(.white)
        
    }
}

#Preview {
    AddBeneficiaryView()
}
