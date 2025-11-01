//
//  SnapshotImageView.swift
//  PantryLink
//
//  Created by Michael Youtz on 10/21/25.
//
import SwiftUI
import MapKit

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
                ProgressView()
            }
        }
        .onAppear {
            if snapshot == nil {
                location.generateSnapshot(for: coordinate) { image in
                    self.snapshot = image
                }
            }
        }
    }
}
