import Foundation

public struct ShellController {
    
    public init() {}
    
    public func unixCommand(command: String, option: String?, path: String) throws -> String {
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
}
