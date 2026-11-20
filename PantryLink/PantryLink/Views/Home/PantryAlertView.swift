//
//  PantryAlertView.swift
//  PantryLink
//
//  Created by Jared Sinai Hernandez Adame on 10/14/25.
//

import SwiftUI

/// A single announcement card: pantry name, message, and when it was posted.
struct PantryAlertView: View {
    let pantryName: String
    let message: String
    let date: String

    var body: some View {
        PLCard {
            VStack(alignment: .leading, spacing: PL.spacingS) {
                Text(pantryName)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(message)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)

                Text(date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    PantryAlertView(pantryName: "Pantry 1", message: "hello ", date: "10/14/25")
        .padding()
        .background(PL.background)
}
