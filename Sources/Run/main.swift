import App
import Vapor
import Foundation
import Dispatch

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()


extension URLSession {

    func uploadTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask {
        uploadTask(with: request, from: request.httpBody, completionHandler: completionHandler)
    }
}

let fileData = try Data(contentsOf: URL(fileURLWithPath: "/Users/[user]/[file].md"))
var request = URLRequest(url: URL(string: "http://localhost:8080/uploadFile?key=\(UUID().uuidString).md")!)
request.httpMethod = "POST"
request.httpBody = fileData

let task = URLSession.shared.uploadTask(with: request) { data, response, error in
    guard error == nil else {
        fatalError(error!.localizedDescription)
    }
    guard let response = response as? HTTPURLResponse else {
        fatalError("Invalid response")
    }
    guard response.statusCode == 200 else {
        fatalError("HTTP status error: \(response.statusCode)")
    }
    guard let data = data, let result = String(data: data, encoding: .utf8) else {
        fatalError("Invalid or missing HTTP data")
    }
    print(result)
    exit(0)
}

task.resume()
dispatchMain()
