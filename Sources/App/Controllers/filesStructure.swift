import Foundation
import Vapor

struct ActionWithPages: Content {
    
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
            let firstIndex = splitedValue.firstIndex(of: ".stranitsy")!
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

struct PageContent: Content {
    var content: String
}


struct PageParams: Content {
    var title: String
    var userName: String // after setting up authorizations change on Users
    // var parentID: String
    var ID: String {
        get {
            return UUID().uuidString
        }
    }
}
