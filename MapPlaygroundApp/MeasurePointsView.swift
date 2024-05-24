//
//  MeasurePointsView.swift
//  MapPlaygroundApp
//
//  Created by dy8950 on 5/24/24.
//

import SwiftUI
import MapKit

struct MeasurePointsView: UIViewRepresentable {
  var coordinates: [CLLocationCoordinate2D]

  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.delegate = context.coordinator

    // Set initial region (optional)
    let region = MKCoordinateRegion(center: coordinates.first ?? CLLocationCoordinate2D(), latitudinalMeters: 1000, longitudinalMeters: 1000)
    mapView.setRegion(region, animated: true)

    // Add polyline
    let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
    mapView.addOverlay(polyline)

    return mapView
  }

  func updateUIView(_ uiView: MKMapView, context: Context) {
    // Update the view if needed
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MeasurePointsView

    init(_ parent: MeasurePointsView) {
      self.parent = parent
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      if overlay is MKPolyline {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
      }
      return MKOverlayRenderer()
    }
  }
}
//#Preview {
//  MeasurePointsView(coordinates: <#[CLLocationCoordinate2D]#>)
//}
