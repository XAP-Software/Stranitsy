import App
import Vapor
import Foundation
import Dispatch

#if DEBUG

print("This never gets printed")

func asyncRun () async throws {
    let app = Application()
    async let shellController = ShellController()

    try configure(app)
    let _ = try await shellController.unixCommand("cd `pwd`/Client/", path: "&& yarn start")
    try app.run()
    app.shutdown()
    print("before")
}

func executeAsyncRun () {
    Task.detached {
        try await asyncRun()
    }
}

executeAsyncRun ()

#else

print("this always executes instead")
var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()
dispatchMain()

#endif

dispatchMain()
