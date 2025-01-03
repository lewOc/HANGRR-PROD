import SwiftUI

// MARK: - Try On Button
struct TryOnButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.customPink)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    let subtitle: String
    var actionButton: (() -> AnyView)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text(title)
                    .font(.title2)
                    .bold()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .imageScale(.small)
                
                Spacer()
                
                if let actionButton {
                    actionButton()
                }
            }
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
}

// MARK: - Preview Provider
#Preview {
    VStack(spacing: 20) {
        TryOnButton(
            icon: "tshirt",
            title: "Try On Outfit"
        ) {}
        
        SectionHeader(
            title: "Wardrobe Items",
            subtitle: "These are all of your wardrobe items"
        ) {
            AnyView(
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.customPink)
                    .clipShape(Circle())
            )
        }
    }
    .padding()
    .previewLayout(.sizeThatFits)
} 