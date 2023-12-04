import Foundation
import UIKit
import AVFoundation

extension FileManager {
    var documentDirectory: URL {
        return self.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
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
