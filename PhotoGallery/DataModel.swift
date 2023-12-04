import Foundation

class DataModel: ObservableObject {
    @Published var folders: [Folder] = []

    init() {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "folders") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Folder].self, from: data) {
                self.folders = decoded
            }
        }
    }

    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(folders) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "folders")
        }
    }

    func addFolder(name: String) {
        let folder = Folder(name: name, items: [])
        folders.insert(folder, at: 0)
        save()
    }
    
    func deleteFolder(folderIndex: Int) {
        let folder = folders[folderIndex]
        for item in folder.items {
            if !FileManager.default.removeItemFromDocumentDirectory(fileName: item.fileName) {
                print("Problem deleting file \(item.fileName)")
            }
        }
        folders.remove(at: folderIndex)
        save()
    }
    
    func addItemsToFolder(folderIndex: Int, items: [FolderItem]) {
        folders[folderIndex].items.insert(contentsOf: items, at: 0)
        save()
    }
    
    func removeItemFromFolder(folderIndex: Int, itemIndex: Int) {
        folders[folderIndex].items.remove(at: itemIndex)
        save()
    }
}

extension URL {
    var isImage: Bool {
        let imageExtensions = ["jpg", "jpeg", "png", "gif", "heic"]
        return imageExtensions.contains(self.pathExtension)
    }
}

