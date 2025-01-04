import SwiftUI
import SwiftData
import PhotosUI

struct TryOnItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = TryOnItemViewModel()
    @State private var showGarmentPicker = false
    @State private var isGarmentError = false
    
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
                    ForEach(WardrobeItemCategory.allCases.filter(\.supportsTryOn), id: \.rawValue) { category in
                        Text(category.displayName)
                            .tag(category)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            // Garment Selection
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Select Garment")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button {
                        showGarmentPicker = true
                    } label: {
                        Label("Upload Photo", systemImage: "photo")
                            .font(.subheadline)
                    }
                    .foregroundColor(.customPink)
                }
                
                if let garmentPhoto = viewModel.garmentPhoto {
                    // Show uploaded photo
                    Image(uiImage: garmentPhoto)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            Button {
                                viewModel.garmentPhoto = nil
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white)
                                    .background(Circle().fill(Color.black.opacity(0.5)))
                            }
                            .padding(8),
                            alignment: .topTrailing
                        )
                } else {
                    // Show wardrobe items grid
                    HorizontalWardrobeItemsGrid(
                        items: viewModel.filteredItems,
                        selectedItem: $viewModel.selectedItem
                    )
                }
            }
            
            Spacer()
            
            // Try On Button
            Button {
                viewModel.tryOnItem()
            } label: {
                VStack(spacing: 4) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.customPink)
                        } else {
                            Image(systemName: "wand.and.stars")
                            Text("Try It On")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.customLightPink)
                    .foregroundColor(.customPink)
                    .cornerRadius(10)
                    
                    Text("Use AI to virtually try on an item. This currently works with tops, bottoms and one-pieces")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .disabled(!viewModel.canTryOn || viewModel.isLoading)
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
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
        .alert("Success", isPresented: $viewModel.showSuccessMessage) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Check your Try On Results section to see the final image")
        }
        .onAppear {
            viewModel.setModelContext(modelContext)
            viewModel.setAPIKey("fa-G5f1au97aPCl-BibbTi9HL9lSowOMmK0d0nir")
        }
        .sheet(isPresented: $showGarmentPicker) {
            ImagePicker(image: $viewModel.garmentPhoto, isError: $isGarmentError)
        }
        .alert("Error", isPresented: $isGarmentError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Failed to load the selected garment image. Please try again.")
        }
    }
}

#Preview {
    NavigationStack {
        TryOnItemView()
    }
} 