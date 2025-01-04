import SwiftUI

struct HorizontalWardrobeItemsGrid: View {
    let items: [WardrobeItem]
    @Binding var selectedItem: WardrobeItem?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.flexible())], spacing: 12) {
                ForEach(items) { item in
                    Button {
                        selectedItem = item
                    } label: {
                        WardrobeItemView(item: item)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedItem?.id == item.id ? Color.customPink : Color.clear, lineWidth: 2)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(height: 100)
        }
    }
}

#Preview {
    HorizontalWardrobeItemsGrid(items: [], selectedItem: .constant(nil))
} 