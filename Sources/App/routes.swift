import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("list") { req -> [[String : String]] in
        let pages = try req.query.decode(Pages.self)
        let listPages = try pages.show("ls", "/Users/kl/Desktop/localRepo") // .split(separator: "\n")
        let JSON = try pages.toJSON(listPages)
        return JSON
    }
    
    app.get("list", ":name") { req -> String in
        let content = try req.query.decode(Pages.self)
        let name = req.parameters.get("name")!
        let showContent = try content.show("cat", "/Users/kl/Desktop/localRepo/\(name).md")
        return showContent
    }
    
    app.post("uploadFile") { req -> EventLoopFuture<String> in
        struct Input: Content {
            var file: File
        }
        let input = try req.content.decode(Input.self)
        
        let path = app.directory.publicDirectory + input.file.filename
        
        return req.application.fileio.openFile(path: path,
                                               mode: .write,
                                               flags: .allowFileCreation(posixMode: 0x744),
                                               eventLoop: req.eventLoop)
            .flatMap { handle in
                req.application.fileio.write(fileHandle: handle,
                                             buffer: input.file.data,
                                             eventLoop: req.eventLoop)
                    .flatMapThrowing { _ in
                        try handle.close()
                        return input.file.filename
                    }
            }
        
    }
    
    app.get("home") { req -> String in
        return "Hello, world!"
    }
}
