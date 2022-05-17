import Foundation
import Vapor

struct Pages: Content {
    func show(_ command: String, _ path: String) throws -> String {
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
    //    var name: String
    //    var path: String
    //    var ID: Int
    //    var repo: String
    //    var content: String
}



//safeShell("ls", "/Users/kl/Desktop/localRepo")
//
//
//app.get("list") { req -> String in
//    let listPages = try req.query.decode(safeShell("ls", "/Users/kl/Desktop/localRepo"))
//    return "In your local repository: \(listPages)"
//}
