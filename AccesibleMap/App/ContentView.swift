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
            Tab("router.tab.home".localized, systemImage: "soccerball") {
                NavigationStack {
                    Home()
                }
            }
            Tab("router.tab.ticket".localized, systemImage: "ticket") {
                NavigationStack {
                    TicketAssistantView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
