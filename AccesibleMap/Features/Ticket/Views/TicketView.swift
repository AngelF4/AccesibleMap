//
//  TicketView.swift
//  AccesibleMap
//
//  Created by Alejandro on 15/10/25.
//

import SwiftUI

struct TicketView: View {
    var body: some View {
        ZStack {
            // Fondo del ticket
            Image("TicketBackground")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 10) {
                
                // MARK: - Encabezado
                HStack {
                    Label("Estadio Universitario", systemImage: "sportscourt.fill")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.primary)
                    Spacer()
                    Text("Dic 03")
                        .font(.system(size: 20))
                        .bold()
                }
                .padding(.top, 30)
                
                Spacer().frame(height: 10)
                
                // MARK: - Equipos
                HStack(alignment: .center) {
                    VStack (alignment: .leading) {
                        Text("Tigres")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fontWeight(.bold)
                        
                        Text("TIG")
                            .frame(height: 20)
                            .font(.custom("FWC2026-UltraCondensedBold", size: 40))
                    }
                    Spacer()
                    VStack (alignment: .trailing) {
                        Text("Puebla")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fontWeight(.bold)
                        
                        
                        Text("PUE")
                            .frame(height: 20)
                            .font(.custom("FWC2026-UltraCondensedBold", size: 40))

                    }
                }
                
                // Línea punteada y VS
                VStack {
                    Text("VS")
                        .font(.custom("FWC2026-UltraCondensedBold", size: 70))

                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                
                // MARK: - Información del asiento
                Grid(alignment: .leading, horizontalSpacing: 40, verticalSpacing: 35) {
                    GridRow {
                        VStack(alignment: .leading) {
                            Text("ticket.item.label.seat".localized)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .fontWeight(.bold)
                            Text("54")
                                .font(.headline)
                        }
                        VStack(alignment: .leading) {
                            Text("ticket.item.label.row".localized)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .fontWeight(.bold)
                            Text("1")
                                .font(.headline)
                        }
                        VStack(alignment: .leading) {
                            Text("ticket.item.label.section".localized)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .fontWeight(.bold)
                            Text("Puerta 2")
                                .font(.headline)
                        }
                    }
                    
                    GridRow {
                        VStack(alignment: .leading) {
                            Text("ticket.item.label.ticket_type".localized)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .fontWeight(.bold)
                            Text("Cortes A")
                                .font(.headline)
                        }
                        VStack(alignment: .leading) {
                            Text("ticket.item.label.time".localized)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .fontWeight(.bold)
                            Text("8:10PM")
                                .font(.headline)
                        }
                        VStack(alignment: .leading) {
                            Text("ticket.item.label.serial".localized)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .fontWeight(.bold)
                            Text("102X55")
                                .font(.headline)
                        }
                    }
                }
                .padding(.top, 10)
                
                Spacer().frame(height: 100)
                
                // MARK: - Accesibilidad
                HStack {
                    Image(systemName: "wheelchair")
                    
                    VStack(alignment: .leading) {
                        Text("ticket.item.label.accessible".localized)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fontWeight(.bold)
                        
                        Text("No")
                            .font(.headline)
                    }
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 30)

        }
    }
}


#Preview {
    TicketView()
}
