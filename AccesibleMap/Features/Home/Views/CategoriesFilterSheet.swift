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
                Text("Filtra los resultados con seleccionar las categorias que quieres que se muestren")
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
                    Spacer()
                    if vm.selectedCategories.isEmpty {
                        Button("Restablecer") {
                            vm.resetCategories()
                        }
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    } else {
                        Button("Quitar todo") {
                            vm.resetCategories(selectAll: false)
                        }
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    }
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
            ToolbarItem(placement: .destructiveAction) {
                Button("Restablecer") {
                    vm.resetCategories(selectAll: true)
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
                    .font(.title3)
                    .foregroundStyle(.accent)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(configuration.isOn ? "Categoría activada" : "Categoría desactivada")
            .accessibilityAddTraits(.isButton)
        }
    }
}
