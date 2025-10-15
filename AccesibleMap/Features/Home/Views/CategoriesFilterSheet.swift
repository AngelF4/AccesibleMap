//
//  CategoriesFilterSheet.swift
//  AccesibleMap
//
//  Created by Angel Hernández Gámez on 14/10/25.
//

import SwiftUI

struct CategoriesFilterSheet: View {
    @ObservedObject var vm: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        List {
            VStack(spacing: 12) {
                Image(systemName: "square.grid.2x2")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .foregroundStyle(.back)
                    .padding(10)
                    .frame(minWidth: 60, minHeight: 60)
                    .background(.accent.gradient, in: .rect(cornerRadius: 12))
                Text("Categorías")
                    .font(.title2.bold())
                Text("Filtra los resultados seleccionando las categorías que quieres mostrar.")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 16)
            Section {
                ForEach(pointOfInterest.allCases, id: \.self) { poi in
                    Toggle(
                        isOn: Binding(
                            get: { vm.selectedCategories.contains(poi) },
                            set: { newValue in vm.setCategory(poi, to: newValue) }
                        )
                    ) {
                        Label {
                            Text(poi.displayName)
                                .foregroundStyle(.text)
                        } icon: {
                            Image(systemName: poi.icon)
                                .foregroundStyle(poi.color)
                        }
                    }
                    .toggleStyle(SelectionSwitchStyle())
                }
            } header: {
                HStack {
                    Button("Restablecer") {
                        vm.resetCategories()
                    }
                    .font(.headline)
                    Spacer()
                    Button("Quitar todo") {
                        if vm.selectedCategories.isEmpty {
                            vm.resetCategories()
                        } else {
                            vm.resetCategories(selectAll: false)
                        }
                    }
                    .font(.headline)
                    .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Filtros")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CategoriesFilterSheet(vm: HomeViewModel())
    }
}

struct SelectionSwitchStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Button {
                withAnimation(.snappy(duration: 0.22)) {
                    configuration.isOn.toggle()
                }
            } label: {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .contentTransition(.symbolEffect(.replace))
                    .font(.title2)
            }
            .accessibilityLabel(configuration.isOn ? "Categoría activada" : "Categoría desactivada")
            .accessibilityAddTraits(.isButton)
        }
    }
}
