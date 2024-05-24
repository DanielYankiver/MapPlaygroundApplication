//
//  EditView.swift
//  MapPlaygroundApp
//
//  Created by dy8950 on 5/23/24.
//

import SwiftUI

struct EditView: View {
  @Environment(\.dismiss) var dismiss
  var location: Location

  @State private var name: String
  @State private var description: String
  var onSave: (Location) -> Void
  var onDelete: (Location) -> Void

    var body: some View {
      NavigationStack {
        Form {
          Section {
            TextField("Place name", text: $name)
            TextField("Description", text: $description)
          }
        }
        .navigationTitle("Place Details")
        .toolbar {
          Button("Save") {
            var newLocation = location
            newLocation.id = UUID()
            newLocation.name = name
            newLocation.description = description

            onSave(newLocation)
            dismiss()
          }
        }
        Button("Delete") {
          onDelete(location)
          dismiss()
        }
      }
    }
  init(location: Location, onSave: @escaping (Location) -> Void, onDelete: @escaping (Location) -> Void) {
    self.location = location
    self.onSave = onSave
    self.onDelete = onDelete

    _name = State(initialValue: location.name)
    _description = State(initialValue: location.description)
  }
}

//#Preview {
//  EditView(location: .example) { _ in }
//}
