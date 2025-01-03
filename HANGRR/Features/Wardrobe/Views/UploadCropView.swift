import SwiftUI
import SwiftData

struct UploadCropView: View {
    @StateObject private var viewModel: UploadCropViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: UploadCropViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let image = viewModel.selectedImage {
                    // Instructions
                    Text("Draw around the item you want to upload")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                    
                    // Drawing Canvas
                    DrawingCanvas(image: image) { maskedImage in
                        viewModel.setMaskedImage(maskedImage)
                        viewModel.showNameInput = true
                    }
                    .padding(.horizontal)
                    
                    // Action Buttons
                    HStack(spacing: 16) {
                        Button(role: .destructive) {
                            viewModel.setImage(nil)
                        } label: {
                            Label("Clear", systemImage: "trash")
                        }
                        .buttonStyle(.bordered)
                        
                        Button {
                            viewModel.showImagePicker = true
                        } label: {
                            Label("Change Photo", systemImage: "photo")
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.bottom)
                } else {
                    // Initial Image Selection
                    VStack(spacing: 16) {
                        Image(systemName: "tshirt")
                            .font(.system(size: 60))
                            .foregroundColor(Color.customPink)
                        
                        Text("Select a photo of your garment")
                            .font(.headline)
                        
                        Button {
                            viewModel.showImagePicker = true
                        } label: {
                            Label("Choose Photo", systemImage: "photo.badge.plus")
                                .font(.headline)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color.customPink)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Add Garment")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $viewModel.showImagePicker) {
                ImagePicker(image: Binding(
                    get: { viewModel.selectedImage },
                    set: { viewModel.setImage($0) }
                ))
            }
            .alert("Name Your Item", isPresented: $viewModel.showNameInput) {
                TextField("Item Name", text: $viewModel.itemName)
                Button("Cancel", role: .cancel) {
                    viewModel.showNameInput = false
                }
                Button("Save") {
                    Task {
                        try? await viewModel.saveItem()
                        dismiss()
                    }
                }
            }
        }
    }
}

