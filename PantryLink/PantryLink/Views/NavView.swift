import SwiftUI

struct NavView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            Color(red: 1.0, green: 1, blue: 1) // light peach background
                .ignoresSafeArea()
            
            HStack(spacing: 14) {
                
                // HOME
                Button(action: {
                    print("home button clicked")
                }) {
                    Text("Home")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(Color.orange.opacity(0.85))
                        )
                        .shadow(color: Color.orange.opacity(0.4), radius: 6, y: 4)
                }
                
                // STOCK
                Button(action: {
                    path.append("Stock")
                }) {
                    Text("Stock")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(Color.orange.opacity(0.85))
                        )
                        .shadow(color: Color.orange.opacity(0.4), radius: 6, y: 4)
                }
                
                // VOLUNTEER
                Button(action: {
                    path.append("Volunteer")
                }) {
                    Text("Volunteer")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(Color.orange.opacity(0.85))
                        )
                        .shadow(color: Color.orange.opacity(0.4), radius: 6, y: 4)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}
