import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("list") { req -> [[String : String]] in
        let pages = try req.query.decode(Pages.self)
        let listPages = try pages.unixShell(command: "ls", option: "-R", path: "/Users/kl/Desktop/localRepo/**/*.md")
        let JSON = try pages.toJSON(listPages)
        return JSON
    }
    
    app.get("list", "**") { req -> String in
        let content = try req.query.decode(Pages.self)
        let localPath = req.parameters.getCatchall().joined(separator: "/")
        let showContent = try content.unixShell(command: "more", option: nil, path: "/Users/kl/Desktop/localRepo/\(localPath)")
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
