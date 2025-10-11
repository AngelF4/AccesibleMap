//
//  ContentView.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 06/10/25.
//

import SwiftUI
import MapKit

//Router, aqui se encargará de mostrar la pantalla, ya sea un onboarding, login, home, etc
struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Inicio", systemImage: "soccerball") {
                NavigationStack {
                    Home()
                }
            }
            
            Tab("Perfil", systemImage: "person.crop.circle") {
                NavigationStack {
                    ContentUnavailableView(
                        "Perfil en proceso",
                        systemImage: "person.crop.circle",
                        description:
                            Text("Cuando esté listo, aqui podrás ver tu perfil para configurarlo y ver tus partidos favoritos")
                    )
                    .foregroundStyle(.secondary, .accent)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
