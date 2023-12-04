import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.dismiss) var dismiss
    
    let folderIndex: Int

    func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoPicker>) -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.preferredAssetRepresentationMode = .current
        configuration.selectionLimit = 0

        let photoPickerViewController = PHPickerViewController(configuration: configuration)
        photoPickerViewController.delegate = context.coordinator
        return photoPickerViewController
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<PhotoPicker>) {
        // No updates are necessary.
    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    let supportedIdentifiers = [
        UTType.image.identifier,
        UTType.movie.identifier,
        UTType.video.identifier,
        UTType.mpeg2Video.identifier,
        UTType.mpeg4Movie.identifier,
        UTType.appleProtectedMPEG4Video.identifier
    ]
    let parent: PhotoPicker
    
    init(_ parent: PhotoPicker) {
        self.parent = parent
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print("Results count \(results.count)")
        self.parent.dismiss()
        
        for result in results {
            print("\(result.itemProvider.registeredTypeIdentifiers)")
            
            var pickedIdentifier: String?
            for identifier in supportedIdentifiers {
                if result.itemProvider.hasItemConformingToTypeIdentifier(identifier) {
                    pickedIdentifier = identifier
                    break
                }
            }
            
            guard let pickedIdentifier = pickedIdentifier else {
                print("Unknown type")
                continue
            }
            
            result.itemProvider.loadFileRepresentation(forTypeIdentifier: pickedIdentifier) { url, error in
                if let error = error {
                    print("Error loading file representation: \(error.localizedDescription)")
                    return
                }
                
                if let url = url {
                    if let fileName = FileManager.default.copyItemToDocumentDirectory(from: url) {
                        Task { @MainActor [dataModel = self.parent.dataModel] in
                            withAnimation {
                                let item = FolderItem(id: UUID(), fileName: fileName)
                                dataModel.addItemsToFolder(folderIndex: self.parent.folderIndex, items: [item])
                            }
                        }
                    } else {
                        // ERROR OR DUPLICATE
                        print("MOST LIKELY DUPLICATE")
                    }
                } else {
                    print("Problem with URL")
                }
            }
        }
    }
}
