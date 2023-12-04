import SwiftUI

struct HomeGridItemView: View {
    let folder: Folder

    var body: some View {
        HStack {
            if folder.items.isEmpty {
                Image(systemName: "folder.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.yellow)
            } else {
                let item = folder.items.first!
                let url = FileManager.default.documentDirectory.appendingPathComponent(item.fileName)
                
                Group {
                    if url.isImage {
                        AsyncImage(url: url) { image in
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
                                .overlay(
                                    Image(systemName: "play.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80 / 3, height: 80 / 3)
                                        .foregroundColor(.white)
                                )
                        } else {
                            // this would only show in case of some weird bug...
                            ProgressView()
                        }
                    }
                }.frame(width: 80, height: 80).cornerRadius(5.0)
            }
            Spacer()
            VStack {
                Text(folder.name)
                    .font(.headline)
                    .lineLimit(1)
                Text("\(folder.items.count) \(folder.items.count == 1 ? "item" : "items")")
            }
            Spacer()
        }
        .padding()
        .frame(height: 100)
        .cornerRadius(10)
    }
}
