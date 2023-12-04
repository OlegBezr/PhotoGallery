import SwiftUI

struct HomeGridView: View {
    @EnvironmentObject var dataModel: DataModel
    
    @State private var showingAddFolderAlert = false
    @State private var newFolderName = ""
    
    var body: some View {
        let folders = dataModel.folders
        
        Group {
            if folders.isEmpty {
                Text("No Folders. Click + to add your first.")
                    .font(.system(size: 30))
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                List {
                    ForEach(Array(folders.enumerated()), id: \.element) { index, item in
                        NavigationLink(destination: FolderGridView(folderIndex: index)) {
                            HomeGridItemView(folder: folders[index])
                        }.swipeActions(allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                dataModel.deleteFolder(folderIndex: index)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }.onAppear {
                    print(folders.count)
                }
            }
        }.navigationBarTitle("Magic Gallery")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddFolderAlert = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }.alert("New Folder", isPresented: $showingAddFolderAlert) {
            TextField("Folder Name", text: $newFolderName)
            Button("OK") {
                dataModel.addFolder(name: newFolderName)
                newFolderName = ""
                showingAddFolderAlert = false
            }
            Button("Cancel", role: .cancel) { 
                newFolderName = ""
                showingAddFolderAlert = false
            }
        } message: {
            Text("Please enter new Magic Folder name.")
        }
    }
}
