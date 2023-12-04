import SwiftUI

struct FolderGridView: View {
    @EnvironmentObject var dataModel: DataModel
    let folderIndex: Int

    private static let initialColumns = 3
    @State private var isAddingPhoto = false
    @State private var isEditing = false

    @State private var gridColumns = Array(repeating: GridItem(.flexible()), count: initialColumns)
    @State private var numColumns = initialColumns
    
    private var columnsTitle: String {
        gridColumns.count > 1 ? "\(gridColumns.count) Columns" : "1 Column"
    }
    
    init(folderIndex: Int) {
        self.folderIndex = folderIndex
    }
    
    var body: some View {
        let folder = dataModel.folders[folderIndex]
        
        VStack {
            if folder.items.isEmpty {
                Text("No Images or Videos. Click + to add your first.")
                    .font(.system(size: 30))
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                if isEditing {
                    ColumnStepper(title: columnsTitle, range: 1...8, columns: $gridColumns)
                    .padding()
                }
                ScrollView {
                    LazyVGrid(columns: gridColumns) {
                        ForEach(Array(folder.items.enumerated()), id: \.element) { index, item in
                            GeometryReader { geo in
                                NavigationLink(destination: DetailView(folderIndex: self.folderIndex, itemIndex: index)) {
                                    FolderGridItemView(size: geo.size.width, item: item)
                                }
                            }
                            .cornerRadius(8.0)
                            .aspectRatio(1, contentMode: .fit)
                            .overlay(alignment: .topTrailing) {
                                if isEditing {
                                    Button {
                                        if FileManager.default.removeItemFromDocumentDirectory(fileName: item.fileName) {
                                            withAnimation {
                                                dataModel.removeItemFromFolder(folderIndex: self.folderIndex, itemIndex: index)
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "xmark.square.fill")
                                            .font(Font.title)
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(.white, .red)
                                    }
                                    .offset(x: 7, y: -7)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }.onAppear {
            print(folder.items.count)
        }.navigationBarTitle(folder.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isAddingPhoto) {
            PhotoPicker(folderIndex: self.folderIndex)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    withAnimation { isEditing.toggle() }
                }.disabled(folder.items.isEmpty)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isAddingPhoto = true
                } label: {
                    Image(systemName: "plus")
                }.disabled(isEditing)
            }
        }
    }
}
