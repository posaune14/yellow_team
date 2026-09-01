//
//  OnboardingView.swift
//  PantryLink
//
//  First-launch tour. Written for people who are not comfortable with
//  technology: one idea per page, large text, one clearly-labeled button.
//

import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let message: String
}

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var pageIndex = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "heart.fill",
            title: "Welcome to PantryLink",
            message: "PantryLink helps you find free food near you and stay connected with your local food pantries."
        ),
        OnboardingPage(
            icon: "mappin.and.ellipse",
            title: "Find Pantries Near You",
            message: "The Home tab shows food pantries close to you, with directions and phone numbers. We'll ask to use your location so we can find the closest ones."
        ),
        OnboardingPage(
            icon: "cube.box.fill",
            title: "See What Food Is Available",
            message: "The Stock tab shows what food each pantry has right now, so you don't make a trip for nothing."
        ),
        OnboardingPage(
            icon: "hand.raised.fill",
            title: "Lend a Hand",
            message: "Want to help? The Serve tab lets you sign up to volunteer at a pantry near you."
        ),
    ]

    private var isLastPage: Bool { pageIndex == pages.count - 1 }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                if !isLastPage {
                    Button("Skip") {
                        hasCompletedOnboarding = true
                    }
                    .font(.body)
                    .padding(PL.spacingM)
                    .accessibilityHint("Skips the tour and opens the app")
                }
            }

            TabView(selection: $pageIndex) {
                ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                    VStack(spacing: PL.spacingL) {
                        Image(systemName: page.icon)
                            .font(.system(size: 72))
                            .foregroundStyle(PL.accent)
                            .accessibilityHidden(true)
                        Text(page.title)
                            .font(.largeTitle.bold())
                            .multilineTextAlignment(.center)
                        Text(page.message)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, PL.spacingXL)
                    .tag(index)
                    .accessibilityElement(children: .combine)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(reduceMotion ? nil : .default, value: pageIndex)

            // Custom page dots that VoiceOver can announce.
            HStack(spacing: PL.spacingS) {
                ForEach(pages.indices, id: \.self) { index in
                    Circle()
                        .fill(index == pageIndex ? PL.accent : Color(.systemFill))
                        .frame(width: 10, height: 10)
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Page \(pageIndex + 1) of \(pages.count)")
            .padding(.bottom, PL.spacingL)

            PLPrimaryButton(title: isLastPage ? "Get Started" : "Next") {
                if isLastPage {
                    hasCompletedOnboarding = true
                } else if reduceMotion {
                    pageIndex += 1
                } else {
                    withAnimation { pageIndex += 1 }
                }
            }
            .padding(.horizontal, PL.spacingXL)
            .padding(.bottom, PL.spacingXL)
        }
        .background(PL.background.ignoresSafeArea())
    }
}

#Preview {
    OnboardingView()
}
