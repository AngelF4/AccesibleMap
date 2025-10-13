//
//  SheetPOI.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 13/10/25.
//

import SwiftUI
import MapKit

struct SheetPOI: View {
    let poi: VenuePOI
    let venue: Venue?
    
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                HStack(alignment: .bottom, spacing: 8) {
                    Image(systemName: poi.type.icon)
                        .font(.title)
                        .bold()
                        .foregroundStyle(poi.type.color)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(venue?.name ?? "Sin nombre")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text(poi.type.displayName)
                            .font(.title)
                            .bold()
                    }
                }
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .frame(width: 55, height: 55)
                        .background(Color(.systemFill), in: .circle)
                }
                .buttonStyle(.plain)
            }
            
            Button {
                
            } label: {
                GroupBox {
                    
                } label: {
                    Label("Pregúntale a Apple Intelligence", systemImage: "apple.intelligence")
                }
            }
            .buttonStyle(.plain)
            Spacer()
            Button {
                let placemark = MKPlacemark(coordinate: poi.center)
                let item = MKMapItem(placemark: placemark)
                item.name = poi.type.displayName
                item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
            } label: {
                Text("Cómo llegar")
                    .font(.headline)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 50)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(24)
    }
}

#Preview {
    SheetPOI(poi: VenuePOI(center: .init(), floor: 0, type: .oficialStore), venue: .estadioBBVA)
}
