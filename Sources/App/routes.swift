import Vapor

func routes(_ app: Application) throws {

    let pages = app.grouped("list")

    pages.get { req -> [[String : String]] in
        let pages = try req.query.decode(Pages.self)
        let pathToFile = "/Users/kl/Desktop/localRepo/**/*.md"
        // let addPath = Pages(path: pathToFile)
        let getListPages = try pages.unixShell(command: "ls", option: "-R", path: pathToFile)
        let JSON = try pages.toJSON(getListPages)
        return JSON
    }
    
    pages.get("**") { req -> String in
        let content = try req.query.decode(Pages.self)
        let localPath = req.parameters.getCatchall().joined(separator: "/")
        let fullPath = "/Users/kl/Desktop/localRepo/\(localPath)"
        // let addPath = Pages(path: fullPath)
        let showContent = try content.unixShell(command: "more", option: nil, path: fullPath)
        return showContent
    }
    
    pages.post("**") { req -> String in
        let data = try req.content.decode(ContentOfPage.self)
        let pageName = req.parameters.getCatchall().joined(separator: "/")
        let fullPath = "/Users/kl/Desktop/localRepo/\(pageName)"
        let pages = Pages()
        let _ = try pages.unixShell(command: "echo", option: """
                                                                -e "\(data.content)" | tee
                                                                """, path: fullPath)

        return "Page has been saved!" // return http status code about saving file
    }
}
