//
//  SnapshotImageView.swift
//  PantryLink
//
//  Created by Michael Youtz on 10/21/25.
//
import SwiftUI
import MapKit

/// Renders a static map image for a coordinate, with a loading placeholder.
struct SnapshotImageView: View {
    let coordinate: CLLocationCoordinate2D
    @State private var snapshot: UIImage?
    @StateObject var location: LocationManager

    var body: some View {
        Group {
            if let image = snapshot {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    PL.background
                    ProgressView()
                }
            }
        }
        .accessibilityLabel("Map showing the pantry's location")
        .onAppear {
            if snapshot == nil {
                location.generateSnapshot(for: coordinate) { image in
                    self.snapshot = image
                }
            }
        }
    }
}
