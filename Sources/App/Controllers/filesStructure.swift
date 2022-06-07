import Foundation
import Vapor

struct Pages: Content {
//    var name: String
//    var content: String
//    var path: String
//    var ID: Int
//    var repo: String
//    var pages: Array

    func savePage(_ fileName: String, _ newContent: String) {
        // Full path to local repository with all .md files
        let directoryURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0].appendingPathComponent("localRepo")
        
        // Creating url to new or old file
        let fileURL = URL(fileURLWithPath: "\(fileName)", relativeTo: directoryURL) //.appendingPathExtension("md")
        
        // Updated content from frontend
        let updatedContent = newContent
        let data = updatedContent.data(using: .utf8)

        do {
            try data!.write(to: fileURL)
            print("File saved: \(fileURL.absoluteURL)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func unixShell(command: String, option: String?, path: String) throws -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        if option != nil {
            task.arguments = ["-c", "\(command) \(option!) \(path)"]
        }
        else {
            task.arguments = ["-c", "\(command) \(path)"]
        }
        task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated
        task.standardInput = nil

        try task.run() //<--updated
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    
    func toJSON(_ listPages: String) throws -> [[String : String]] {
        var listDicts = [[String: String]]()
        
        for value in listPages.split(separator: "\n") {
            
            let splitedValue = value.split(separator: "/")
            let firstIndex = splitedValue.firstIndex(of: "localRepo")!
            let endIndex = splitedValue.endIndex
            var stringToJSON = [String: String]()
                
            if splitedValue[firstIndex + 1 ..< endIndex].count > 1 {
                stringToJSON["name"] = splitedValue[firstIndex + 1 ..< endIndex].joined(separator: ": ")
                stringToJSON["url"] = "/\(splitedValue[firstIndex + 1 ..< endIndex].joined(separator: "/"))"
            }
            else {
                stringToJSON = ["name": "\(splitedValue[endIndex - 1])",
                                "url": "/\(splitedValue[endIndex - 1])"]
            }
        
            listDicts.append(stringToJSON)
        }
        return listDicts
    }
}
