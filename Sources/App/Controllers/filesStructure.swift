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
    
    func unixShell(_ command: String, _ path: String) throws -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", "\(command) \(path)"]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated
        task.standardInput = nil

        try task.run() //<--updated
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    
    func toJSON(_ listPages: String) throws -> [[String : String]] {
        var listDicts = [[String: String]]()
        
        for value in listPages.split(separator: "\n"){
            
            let stringToJSON = ["name": "\(value)", "url": "/\(value)"]
            listDicts.append(stringToJSON)
        }
        return listDicts
    }
    
//    func united(_ name: String) throws -> String {
//        this.pages = this.show(
//    }
}
