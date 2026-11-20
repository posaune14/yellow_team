//
//  DesignSystem.swift
//  PantryLink
//
//  Single source of truth for colors, spacing, and reusable components.
//  Rules the whole app follows:
//   - Only Dynamic Type text styles (.title2, .body, ...) - never fixed sizes,
//     so text scales with the user's accessibility settings.
//   - System backgrounds/labels for automatic dark mode + guaranteed contrast.
//   - Tap targets at least 44pt.
//   - Every async screen has a loading, empty, and error state.
//

import SwiftUI
import UIKit

// MARK: - Theme

enum PL {
    /// Brand accent - used for interactive elements only.
    static let accent = Color("flexibleOrange")

    /// Backgrounds (adapt to dark mode automatically).
    static let background = Color(.systemGroupedBackground)
    static let cardBackground = Color(.secondarySystemGroupedBackground)

    /// Status colors for stock levels - paired with SF Symbols so meaning
    /// never relies on color alone (color-blind friendly).
    static let good = Color.green
    static let low = Color.orange
    static let critical = Color.red

    /// Spacing scale.
    static let spacingXS: CGFloat = 4
    static let spacingS: CGFloat = 8
    static let spacingM: CGFloat = 16
    static let spacingL: CGFloat = 24
    static let spacingXL: CGFloat = 32

    static let cornerRadius: CGFloat = 16
    /// Minimum comfortable tap target.
    static let tapTarget: CGFloat = 44
}

// MARK: - Card

/// Standard content card: adapts to dark mode, hugs its content,
/// never uses fixed widths so it works on every screen size.
struct PLCard<Content: View>: View {
    var content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
            .padding(PL.spacingM)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(PL.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: PL.cornerRadius))
    }
}

// MARK: - Section header

struct PLSectionHeader: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: PL.spacingXS) {
            Text(title)
                .font(.title2.bold())
                .foregroundStyle(.primary)
            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }
}

// MARK: - Empty / error state

/// Friendly full-width placeholder for "nothing here" and error situations.
struct PLEmptyState: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: PL.spacingM) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            if let actionTitle, let action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.body.weight(.semibold))
                        .padding(.horizontal, PL.spacingL)
                        .frame(minHeight: PL.tapTarget)
                }
                .buttonStyle(.borderedProminent)
                .tint(PL.accent)
            }
        }
        .padding(PL.spacingXL)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Loading state

struct PLLoadingView: View {
    var message: String = "Loading..."

    var body: some View {
        VStack(spacing: PL.spacingM) {
            ProgressView()
                .controlSize(.large)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(PL.spacingXL)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message)
    }
}

// MARK: - Buttons

/// Primary filled button: full width, easy to hit, scales with Dynamic Type.
struct PLPrimaryButton: View {
    let title: String
    var systemImage: String? = nil
    var isLoading: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: PL.spacingS) {
                if isLoading {
                    ProgressView()
                } else if let systemImage {
                    Image(systemName: systemImage)
                        .accessibilityHidden(true)
                }
                Text(title)
                    .font(.body.weight(.semibold))
            }
            .frame(maxWidth: .infinity, minHeight: PL.tapTarget)
        }
        .buttonStyle(.borderedProminent)
        .tint(PL.accent)
        .disabled(isLoading)
    }
}

/// Secondary (outlined) button.
struct PLSecondaryButton: View {
    let title: String
    var systemImage: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: PL.spacingS) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .accessibilityHidden(true)
                }
                Text(title)
                    .font(.body.weight(.semibold))
            }
            .frame(maxWidth: .infinity, minHeight: PL.tapTarget)
        }
        .buttonStyle(.bordered)
        .tint(PL.accent)
    }
}

// MARK: - Labeled text field

/// Text field with an always-visible label above it (placeholder-only fields
/// are hard to use once you start typing, especially for new users).
struct PLTextField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    var isSecure: Bool = false
    var keyboard: UIKeyboardType = .default
    var contentType: UITextContentType? = nil
    var autocapitalization: TextInputAutocapitalization = .never

    var body: some View {
        VStack(alignment: .leading, spacing: PL.spacingXS) {
            Text(label)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboard)
                        .textInputAutocapitalization(autocapitalization)
                        .autocorrectionDisabled()
                }
            }
            .textContentType(contentType)
            .font(.body)
            .padding(PL.spacingM)
            .frame(minHeight: PL.tapTarget)
            .background(PL.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color(.separator), lineWidth: 1)
            )
            .accessibilityLabel(label)
        }
    }
}

// MARK: - Stock level indicator

/// Shows how full an item is with a bar + icon + text so the meaning
/// works for color-blind and VoiceOver users too.
struct PLStockLevel: View {
    let current: Int
    let full: Int

    private var ratio: Double {
        full > 0 ? min(Double(current) / Double(full), 1.0) : 0
    }
    private var status: (color: Color, icon: String, text: String) {
        switch ratio {
        case ..<0.25: return (PL.critical, "exclamationmark.circle.fill", "Very low")
        case ..<0.5: return (PL.low, "exclamationmark.triangle.fill", "Running low")
        default: return (PL.good, "checkmark.circle.fill", "In stock")
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: PL.spacingXS) {
            HStack(spacing: PL.spacingXS) {
                Image(systemName: status.icon)
                    .foregroundStyle(status.color)
                    .accessibilityHidden(true)
                Text(status.text)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(status.color)
            }
            ProgressView(value: ratio)
                .tint(status.color)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(status.text): \(current) of \(full) available")
    }
}
