import Foundation

extension FileManager {
    var documentsDirectory: URL {
        let paths = urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveImage(_ imageData: Data, withName fileName: String) throws -> String {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        try imageData.write(to: fileURL, options: [.atomic])
        return fileName
    }
} 