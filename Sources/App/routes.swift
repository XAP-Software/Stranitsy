import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("list") { req -> String in
        let pages = try req.query.decode(Pages.self)
        let listPages = try pages.show("ls", "/Users/kl/Desktop/localRepo")
        return listPages
    }
    
    app.get("content", ":name") { req -> String in
        let content = try req.query.decode(Pages.self)
        let name = req.parameters.get("name")!
        let showContent = try content.show("cat", "/Users/kl/Desktop/localRepo/\(name).md")
        return showContent
    }
    
    
    
    app.get("home") { req -> String in
        return "Hello, world!"
    }
}
