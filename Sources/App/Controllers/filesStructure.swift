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
        var stringToJSON = [String: String]()

        for value in listPages.split(separator: "\n") {
            
            let splitedValue = value.split(separator: "/")

            let firstIndexs = splitedValue.firstIndex(where: {$0 == ".stranitsy"})!
            let pathToFile = splitedValue[firstIndexs + 1 ..< splitedValue.endIndex]
                
            if pathToFile.count > 1 {
                stringToJSON["name"] = "\(pathToFile.count)"
                stringToJSON["url"] = "/\(pathToFile.joined(separator: "/"))"
            }
            else {
                stringToJSON = ["name": "\(pathToFile.last!)",
                                "url": "/\(pathToFile.last!)"]
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
    var level: String
    var sNumber: String
    var parentID: String? = nil
    var ID: String {
        get {
            return UUID().uuidString
        }
    }
}
