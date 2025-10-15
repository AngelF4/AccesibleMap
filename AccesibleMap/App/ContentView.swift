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
            
//            Tab("Chat", systemImage: "apple.intelligence") {
//                NavigationStack {
//                    ContentUnavailableView(
//                        "Apple Intelligence en proceso",
//                        systemImage: "apple.intelligence.badge.xmark",
//                        description:
//                            Text("Cuando esté listo, aqui podrás ver lo ultimo en IA y preguntarle lo que tu quieras")
//                    )
//                    .foregroundStyle(.secondary, .accent)
//                }
//            }
        }
    }
}

#Preview {
    ContentView()
}
