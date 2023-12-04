import SwiftUI

struct FolderGridItemView: View {
    let size: Double
    let item: FolderItem

    var body: some View {
        let url = FileManager.default.documentDirectory.appendingPathComponent(item.fileName)
        
        ZStack(alignment: .topTrailing) {
            if url.isImage {
                AsyncImage(url: FileManager.default.documentDirectory.appendingPathComponent(item.fileName)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
            } else {
                if let thumbnailImage = FileManager.default.getVideoThumbnail(from: url) {
                    Image(uiImage: thumbnailImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: size)
                        .overlay(
                            Image(systemName: "play.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: size / 3, height: size / 3)
                                .foregroundColor(.white)
                        )
                } else {
                    // this would only show in case of some weird bug...
                    ProgressView()
                }
            }
        }.frame(width: size, height: size).clipped()
    }
}
