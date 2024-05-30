//
//  FindPointsView.swift
//  MapPlaygroundApp
//
//  Created by dy8950 on 5/24/24.
//

import SwiftUI
import MapKit
import Observation

@Observable class Daniel {
  var myName: String = ""
}

struct FindPointsView: View {
  let startPosition = MapCameraPosition.region(
    MKCoordinateRegion(
      center: CLLocationCoordinate2D(latitude: 34.051849, longitude: -84.515961),
      span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    )
  )
  @State private var locations = [Location]()
  @State private var selectedPlace: Location?
  @State private var mapType: Int = 0
  @State private var showingClearConfirmation = false // State to control alert visibility

  var selectedMapStyle: MapStyle {
    return switch(mapType) {
    case 0: .standard
    case 1: .hybrid
    default: .standard
    }
  }

  var body: some View {
    VStack {
      Picker("", selection: $mapType) {
        Text("Default").tag(0)
        Text("Satellite").tag(1)
      }
      .pickerStyle(SegmentedPickerStyle())

      Text("Total Distance: \(totalDistance().metersToFeet(), specifier: "%.2f") feet")
        .padding()
    }

    MapReader { proxy in
      Map(initialPosition: startPosition){
        ForEach(locations) { location in
          // Default Marker
          // Marker(location.name, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
          Annotation(location.name, coordinate: location.coordinate) {
            Image(systemName: "mappin")
              .resizable()
              .foregroundStyle(.red)
            //            .frame(width: 66, height: 66)
            //            .background(.white)
            //            .clipShape(.circle)
              .onLongPressGesture {
                selectedPlace = location
              }
          }
        }
      }
      .mapControls {
        MapScaleView()
        // TODO: - get this to work - just shows ui 
        // MapUserLocationButton()
      }
      .mapControlVisibility(Visibility.visible)
      .mapStyle(selectedMapStyle)
      .onTapGesture { position in
        if let coordinate = proxy.convert(position, from: .local) {
          let newLocation = Location(id: UUID(), name: "Point \(locations.count + 1)", description: "", latitude: coordinate.latitude, longitude: coordinate.longitude)
          if (locations.count) <= 4 {
            locations.append(newLocation)
          }
        }
      }
      .sheet(item: $selectedPlace) { place in
        EditView(location: place,
                 onSave: { newLocation in
          if let index = locations.firstIndex(of: place) {
            locations[index] = newLocation
          }
        },
                 onDelete: { locationToDelete in
          // Implement the deletion logic here
          if let index = locations.firstIndex(of: locationToDelete) {
            locations.remove(at: index) // This line removes the location
          }
          selectedPlace = nil // Optionally reset the selectedPlace if needed
        })
        .presentationDetents([.fraction(0.25)])
        .presentationDragIndicator(.visible)
      }
    }

    Button("Clear All Locations") {
      showingClearConfirmation = true // Show confirmation alert
    }
    .alert("Are you sure?", isPresented: $showingClearConfirmation) {
      Button("Clear", role: .destructive) {
        locations.removeAll()
      }
      Button("Cancel", role: .cancel) { }
    } message: {
      Text("This will remove all locations from the map.")
    }
  }
}

extension FindPointsView {
  func totalDistance() -> CLLocationDistance {
    guard locations.count > 1 else { return 0 }
    var distance: CLLocationDistance = 0
    for i in 1..<locations.count {
      let start = CLLocation(latitude: locations[i-1].latitude, longitude: locations[i-1].longitude)
      let end = CLLocation(latitude: locations[i].latitude, longitude: locations[i].longitude)
      distance += start.distance(from: end)
    }
    return distance // Distance in meters
  }
}

extension CLLocationDistance {
  func metersToFeet() -> Double {
    return self * 3.28084
  }
}

#Preview {
  FindPointsView()
}
