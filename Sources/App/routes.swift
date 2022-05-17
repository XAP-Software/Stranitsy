import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("list") { req -> String in
        let pages = try req.query.decode(Pages.self)
        let listPages = try pages.safeShell("ls", "/Users/kl/Desktop/localRepo")
        return listPages
    }
    
    app.get("home") { req -> String in
        return "Hello, world!"
    }
}
