import SwiftUI

struct FolderView: View {
    @ObservedObject private var viewModel: FoldersViewModel
    var folderId: UUID

    init(folderId: UUID, viewModel: FoldersViewModel) {
        self.viewModel = FoldersViewModel()
        self.folderId = folderId
    }
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    Button(action: addItem) {
                        Image(systemName: "plus")
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                            .aspectRatio(1, contentMode: .fit)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    ForEach(viewModel.folders.reversed(), id: \.self.id) { item in
                        Text(item.name)
                            .frame(maxWidth: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(8)
                            .onTapGesture {
                                
                            }
                    }
                }
                .padding()
            }.alert("New Folder", isPresented: $isAlertPresented, actions: {
                TextField("Folder Name", text: $newFolderName)
                
                Button("Add", action: {
                    isAlertPresented = false
                    viewModel.addFolder(name: newFolderName)
                    newFolderName = ""
                })
                Button("Cancel", role: .cancel, action: {
                    isAlertPresented = false
                    newFolderName = ""
                })
            }, message: {
                Text("Please enter name for your new folder.")
            }).navigationTitle("Folders")
        }.navigationViewStyle(StackNavigationViewStyle())
    }

    private func addItem() {
        isAlertPresented = true
    }
}
