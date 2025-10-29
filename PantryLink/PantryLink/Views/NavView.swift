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
                .fill(Color(red: 0.97, green: 0.94, blue: 0.90)) // warm cream
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
                            Color(red: 0.98, green: 0.69, blue: 0.44), // muted peach
                            Color(red: 0.94, green: 0.57, blue: 0.39)  // warm apricot
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: Color(red: 0.94, green: 0.57, blue: 0.39).opacity(0.22),
                        radius: 6,
                        y: 3)
        }
    }
}
