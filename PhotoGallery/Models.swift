import Foundation
import UIKit

struct FolderItem: Hashable, Codable {
    let id: UUID
    let fileName: String
}

struct Folder: Hashable, Codable {
    var name: String
    var items: [FolderItem]
}
