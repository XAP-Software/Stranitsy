import App
import Vapor
import Foundation
import Dispatch

#if DEBUG 
print("This never gets printed")
#else
print("this always executes instead")
#endif

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()
dispatchMain()
