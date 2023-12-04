import SwiftUI
import AVKit

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataModel: DataModel
    let folderIndex: Int
    
    @State var itemIndex: Int
    @State private var hideNavigationBar = false

    var body: some View {
        let folder = dataModel.folders[folderIndex]
        let swipeGesture = DragGesture().onEnded { value in
            if value.translation.width < 0 {
                if itemIndex + 1 < folder.items.count { withAnimation { itemIndex += 1 }}
            } else if value.translation.width > 0 {
                if itemIndex - 1 >= 0 { withAnimation { itemIndex -= 1 } }
            }
        }
        
        let item = folder.items[itemIndex]
        let url = FileManager.default.documentDirectory.appendingPathComponent(item.fileName)
        
        GeometryReader { geometry in
            Group {
                if url.isImage {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    GeometryReader { geometry in
                        VideoPlayer(player: AVPlayer(url: url))
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
            }.frame(width: geometry.size.width, height: geometry.size.height)
            .contentShape(Rectangle())
            .gesture(swipeGesture).toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if FileManager.default.removeItemFromDocumentDirectory(fileName: item.fileName) {
                            let oldIndex = self.itemIndex
                            
                            if self.itemIndex > 0 {
                                self.itemIndex -= 1
                            } else if folder.items.count == 1 {
                                presentationMode.wrappedValue.dismiss()
                            }
                            
                            withAnimation {
                                self.dataModel.removeItemFromFolder(folderIndex: self.folderIndex, itemIndex: oldIndex)
                            }
                        }
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }
}
