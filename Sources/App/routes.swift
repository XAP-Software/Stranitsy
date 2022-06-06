import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("list") { req -> [[String : String]] in
        let pages = try req.query.decode(Pages.self)
//        let directoryURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0].appendingPathComponent("localRepo")
        let listPages = try pages.unixShell(command: "ls", option: "-R", path: "/Users/kl/Desktop/localRepo/**/*.md") // .split(separator: "\n")
        let JSON = try pages.toJSON(listPages)
        return JSON
    }
    
    app.get("list", ":name") { req -> String in
        let content = try req.query.decode(Pages.self)
        let name = req.parameters.get("name")!
        let showContent = try content.unixShell(command: "more", option: nil, path: "/Users/kl/Desktop/localRepo/\(name)")
        return showContent
    }
    
//    app.post("update", ":name") { req -> String in
//        let content = try req.query.decode(Pages.self)
//        let name = req.parameters.get("name")!
//        let showContent = try content.unixShell(command: "echo", option: ">>", path: "/Users/kl/Desktop/localRepo/\(name)")
//        return showContent
//    }
    
    app.get("home") { req -> String in
        return "Hello, world!"
    }
}
