//
//  TicketView.swift
//  AccesibleMap
//
//  Created by Alejandro on 15/10/25.
//

import SwiftUI

struct TicketView: View {
    
    private let stadium = "ticket.header.label".localized
    private let date = "ticket.header.date".localized
    private let match = "ticket.match.label".localized
    
    private let seat = "54"
    private let row = "1"
    private let section = "Puerta 2"
    private let ticketType = "Cortes A"
    private let time = "8:10PM"
    private let serial = "102X55"
    private let accessible = "ticket.item.value.accessibleNo".localized
    
    var body: some View {
        ZStack {
            // Fondo del ticket
            Image("TicketBackground")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .accessibilityHidden(true)
            
            VStack(alignment: .leading, spacing: 10) {
                
                // MARK: - Encabezado
                HStack {
                    Label(stadium, systemImage: "sportscourt.fill")
                        .frame(width: 220)
                        .font(.headline)
                        .bold()
                        .foregroundColor(.primary)
                        .accessibilityLabel(Text(stadium))
                        .accessibilityHint(Text("ticket.header.hint".localized))
                    
                    Spacer()
                    
                    Text(date)
                        .font(.system(size: 20))
                        .bold()
                        .accessibilityLabel(Text("ticket.header.date.accessibility".localized))
                }
                .padding(.top, 30)
                
                Spacer().frame(height: 10)
                
                // MARK: - Equipos
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text("Tigres")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fontWeight(.bold)
                        Text("TIG")
                            .frame(height: 20)
                            .font(.custom("FWC2026-UltraCondensedBold", size: 40))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Puebla")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fontWeight(.bold)
                        Text("PUE")
                            .frame(height: 20)
                            .font(.custom("FWC2026-UltraCondensedBold", size: 40))
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text(match))
                .accessibilityHint(Text("ticket.match.hint".localized))
                
                // Línea punteada y VS
                VStack {
                    Text("VS")
                        .font(.custom("FWC2026-UltraCondensedBold", size: 70))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .accessibilityHidden(true)
                
                // MARK: - Información del asiento
                Grid(alignment: .leading, horizontalSpacing: 40, verticalSpacing: 35) {
                    GridRow {
                        TicketInfoItem(label: "ticket.item.label.seat".localized, value: seat)
                        TicketInfoItem(label: "ticket.item.label.row".localized, value: row)
                        TicketInfoItem(label: "ticket.item.label.section".localized, value: section)
                    }
                    GridRow {
                        TicketInfoItem(label: "ticket.item.label.ticket_type".localized, value: ticketType)
                        TicketInfoItem(label: "ticket.item.label.time".localized, value: time)
                        TicketInfoItem(label: "ticket.item.label.serial".localized, value: serial)
                    }
                }
                .padding(.top, 10)
                .accessibilityElement(children: .combine)
                .accessibilityLabel(Text(String(
                    format: "ticket.details.accessibilityLabel".localized,
                    seat, row, section, ticketType, time, serial
                )))
                .accessibilityHint(Text("ticket.details.accessibilityHint".localized))
                
                Spacer().frame(height: 100)
                
                // MARK: - Accesibilidad
                HStack {
                    Image(systemName: "wheelchair")
                        .accessibilityHidden(true)
                    
                    VStack(alignment: .leading) {
                        Text("ticket.item.label.accessible".localized)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fontWeight(.bold)
                        Text(accessible)
                            .font(.headline)
                    }
                }
                .padding(.bottom, 20)
                .accessibilityElement(children: .combine)
                .accessibilityLabel(Text(String(
                    format: "ticket.accessibility.label".localized,
                    accessible
                )))
                .accessibilityHint(Text("ticket.accessibility.hint".localized))
            }
            .padding(.horizontal, 30)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text(String(
            format: "ticket.overall.accessibilityLabel".localized,
            stadium, date, match, seat, row, section, ticketType, time, serial, accessible
        )))
        .accessibilityHint(Text("ticket.overall.accessibilityHint".localized))
    }
    
    struct TicketInfoItem: View {
        let label: String
        let value: String
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fontWeight(.bold)
                Text(value)
                    .font(.headline)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(Text("\(label): \(value)"))
        }
    }
}


#Preview {
    TicketView()
}
