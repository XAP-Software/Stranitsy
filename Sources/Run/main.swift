import App
import Vapor
import Foundation
import Dispatch

#if DEBUG

print("Starting application in DEBUG mode")

let shellController = ShellController()

let concurrentQueue = DispatchQueue(label: "swiftlee.concurrent.queue", attributes: .concurrent)

// Frontend is executed asyncronously
concurrentQueue.async {
    let feLog = try! shellController.unixCommand(command: "cd ~/Stranitsy/Client/", option: nil, path: "&& yarn start")
    print(feLog)
    // FIXME: log is only being printed after application shutdown
}

// Backend is executed asyncronously
concurrentQueue.async {
    let app = Application()
    try! configure(app)
    try! app.run()
    
    // Catch Ctr+C for application shutdown
    app.shutdown()
    
    // Kill frontend that was started in another thread
    print(try! shellController.unixCommand(command: "kill -9 `lsof -t -i :3000`", option: nil, path: ""))
    
    // Stop program execution
    exit(0)
}

#else

print("Starting application in Production mode")
var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()
dispatchMain()

#endif

dispatchMain()
