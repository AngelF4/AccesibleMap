//
//  VenueSelection.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 06/10/25.
//

import SwiftUI

// EJEMPLO PARA USAR 
struct VenueSelection: View {
    @StateObject private var AIVM = AssistantViewModel()
    @State private var userInput: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                // Título
                Text("Asistente de AccesibleMap 🧠")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                
                // Lista de mensajes
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(AIVM.messages) { message in
                            HStack {
                                if message.role == .user {
                                    Spacer()
                                    Text(message.text)
                                        .padding(10)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(10)
                                        .frame(maxWidth: 240, alignment: .trailing)
                                } else {
                                    Text(message.text)
                                        .padding(10)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                        .frame(maxWidth: 240, alignment: .leading)
                                    Spacer()
                                }
                            }
                        }
                        
                        if AIVM.isLoading {
                            ProgressView("Pensando...")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 8)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Barra inferior para enviar mensajes
                HStack {
                    TextField("Escribe tu mensaje...", text: $userInput)
                        .textFieldStyle(.roundedBorder)
                        .padding(.vertical, 6)
                    
                    Button {
                        let message = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !message.isEmpty else { return }
                        AIVM.send(message)
                        userInput = ""
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .font(.title3)
                            .padding(8)
                            .foregroundColor(.white)
                            .background(Color.accentColor)
                            .clipShape(Circle())
                    }
                }
                .padding()
                .background(Color(.systemGray6))
            }
            .navigationTitle("Seleccionar venue")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}

#Preview {
    VenueSelection()
}
