import SwiftUI

struct NavView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        HStack(spacing: 16) {
            
            NavBarButton(title: "Home") {
                print("home button clicked")
            }
            
            NavBarButton(title: "Stock") {
                path.append("Stock")
            }
            
            NavBarButton(title: "Volunteer") {
                path.append("Volunteer")
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Colors.flexibleLightGray)
                .shadow(color: Color.black.opacity(0.05), radius: 6, y: 4)
        )
        .padding(.top, 8)
    }
}

struct NavBarButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(
                    LinearGradient(
                        colors: [
                            Colors.flexibleOrange.opacity(0.9), // lighter orange
                            Colors.flexibleOrange  // darker orange
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: Colors.flexibleOrange.opacity(0.22),
                        radius: 6,
                        y: 3)
        }
    }
}
