import SwiftUI
import SwiftData

struct TryOnItemView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = TryOnItemViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Photo Upload Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Photo")
                    .font(.headline)
                
                PhotoUploadView(image: $viewModel.userPhoto)
            }
            
            // Category Selection
            VStack(alignment: .leading, spacing: 8) {
                Text("Select Category")
                    .font(.headline)
                
                Picker("Category", selection: $viewModel.selectedCategory) {
                    ForEach(WardrobeItemCategory.allCases, id: \.rawValue) { category in
                        Text(category.displayName)
                            .tag(category)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            // Garment Selection
            VStack(alignment: .leading, spacing: 8) {
                Text("Select Garment")
                    .font(.headline)
                
                HorizontalWardrobeItemsGrid(
                    items: viewModel.filteredItems,
                    selectedItem: $viewModel.selectedItem
                )
            }
            
            Spacer()
            
            // Try On Button
            Button {
                viewModel.tryOnItem()
            } label: {
                VStack(spacing: 4) {
                    HStack {
                        Image(systemName: "wand.and.stars")
                        Text("Try It On")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.customLightPink)
                    .foregroundColor(.customPink)
                    .cornerRadius(10)
                    
                    Text("Use AI to virtually try on an item. This currently works with tops, bottoms and all in ones like dresses and one-pieces")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .disabled(!viewModel.canTryOn)
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Try On Item")
                    .font(.headline)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TryOnItemView()
    }
} 