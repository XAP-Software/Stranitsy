import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("list") { req -> [[String : String]] in
        let pages = try req.query.decode(Pages.self)
        let listPages = try pages.unixShell("ls", "/Users/kl/Desktop/localRepo") // .split(separator: "\n")
        let JSON = try pages.toJSON(listPages)
        return JSON
    }
    
    app.get("list", ":name") { req -> String in
        let content = try req.query.decode(Pages.self)
        let name = req.parameters.get("name")!
        let showContent = try content.unixShell("cat", "/Users/kl/Desktop/localRepo/\(name).md")
        return showContent
    }
    
    app.get("home") { req -> String in
        return "Hello, world!"
    }
}
