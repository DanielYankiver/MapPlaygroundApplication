//
//  Location.swift
//  MapPlaygroundApp
//
//  Created by dy8950 on 5/23/24.
//

import Foundation
import MapKit

struct Location: Codable, Equatable, Identifiable {
  var id: UUID
  var name: String
  var description: String
  var latitude: Double
  var longitude: Double

  var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
  
  #if DEBUG
  static let example = Location(id: UUID(), name: "JVL Garage", description: "customer location", latitude: 34.051849, longitude: -84.515961)
  #endif

  static func ==(lhs: Location, rhs: Location) -> Bool {
    lhs.id == rhs.id
  }
}
