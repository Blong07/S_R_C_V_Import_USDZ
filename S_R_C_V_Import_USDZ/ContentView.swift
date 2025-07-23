import SwiftUI
import RealityKit
import RealityKitContent
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var modelURL: URL? = nil
    @State private var showImporter = false

    var body: some View {
        VStack(spacing: 0) {
            RealityView { content in
                // Initial setup if needed
            } update: { content in
                // Clear out any previous models
                content.entities.removeAll()

                // Load and display the new model when modelURL changes
                if let url = modelURL {
                    // Access the security-scoped resource
                    if url.startAccessingSecurityScopedResource() {
                        defer { url.stopAccessingSecurityScopedResource() }

                        do {
                            let loadedEntity = try Entity.load(contentsOf: url)
                            guard let modelEntity = loadedEntity as? ModelEntity else {
                                print("❌ Loaded USDZ did not contain a ModelEntity")
                                return
                            }
                            let anchor = AnchorEntity(world: .zero)

                            // Scale the model so it's visible (adjust factors as needed)
                            modelEntity.setScale([0.1, 0.1, 0.1], relativeTo: anchor)

                            // Fallback material for unsupported USDZ materials
                            if var modelComp = modelEntity.model {
                                // Determine how many materials to apply (at least one)
                                let materialCount = max(modelComp.materials.count, 1)
                                let fallback = SimpleMaterial(color: .white, roughness: 0.5, isMetallic: false)
                                modelComp.materials = Array(repeating: fallback, count: materialCount)
                                modelEntity.model = modelComp
                            }

                            anchor.addChild(modelEntity)
                            content.add(anchor)
                        } catch {
                            print("❌ Failed to load USDZ model: \(error)")
                        }
                    } else {
                        print("🔒 Couldn't access security-scoped resource")
                    }
                }
            }
            .ignoresSafeArea()

            Button("Import USDZ File") {
                showImporter = true
            }
            .font(.headline)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8).stroke()
            )
            .fileImporter(
                isPresented: $showImporter,
                allowedContentTypes: [UTType.usdz],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    modelURL = urls.first
                case .failure(let err):
                    print("❌ File import failed: \(err)")
                }
            }
            .padding()
        }
    }
}
// dave the duck lives here now, 23/07/25
