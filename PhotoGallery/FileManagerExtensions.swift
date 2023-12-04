import Foundation
import UIKit
import AVFoundation

extension FileManager {
    /// The URL of the document directory.
    var documentDirectory: URL {
        return self.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    /// Copies the specified file URL to a file with the same name in the document directory.
    ///
    /// - parameter url: The file URL to be copied.
    ///
    /// - returns: The URL of the copied or existing file in the documents directory, or nil if the copy failed.
    ///
    func copyItemToDocumentDirectory(from sourceURL: URL) -> String? {
        let fileName = sourceURL.lastPathComponent
        let destinationURL = documentDirectory.appendingPathComponent(fileName)
        if self.fileExists(atPath: destinationURL.path) {
            return nil
        } else {
            do {
                try self.copyItem(at: sourceURL, to: destinationURL)
                return fileName
            } catch let error {
                print("Unable to copy file: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    /// Removes an item with the specified file URL from the document directory, if present.
    ///
    /// - parameter url: The file URL to be removed.
    ///
    func removeItemFromDocumentDirectory(fileName: String) -> Bool {
        let fileUrl = documentDirectory.appendingPathComponent(fileName)
        if self.fileExists(atPath: fileUrl.path) {
            do {
                try self.removeItem(at: fileUrl)
                return true
            } catch let error {
                print("Unable to remove file: \(error.localizedDescription)")
            }
        }
        
        print("No such file \(fileName)")
        return false
    }
    
    /// Returns the contents of the specified directory as an array of URLs.
    func getContentsOfDirectory(_ url: URL) -> [URL] {
        var isDirectory: ObjCBool = false
        // The URL must be a directory.
        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory), isDirectory.boolValue else { return [] }
        do {
            return try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
        } catch let error {
            print("Unable to get directory contents: \(error.localizedDescription)")
        }
        return []
    }

    func getVideoThumbnail(from url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMake(value: 1, timescale: 2)

        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

}
