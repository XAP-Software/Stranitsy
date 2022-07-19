import Vapor

func routes(_ app: Application) throws {

    let directoryURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".stranitsy").path
    let pages = app.grouped("list")

    // Getting a list of pages
    pages.get { req -> [[String : String]] in
        let pagesActns = try req.query.decode(ActionWithPages.self)
        let pathToFile = "\(directoryURL)/**/*.md"
        let getListPages = try pagesActns.unixShell(command: "ls", option: "-R", path: pathToFile)
        let JSON = try pagesActns.toJSON(getListPages)
        return JSON
    }
    
    // Getting page content
    pages.get("**") { req -> String in
        let content = try req.query.decode(ActionWithPages.self)
        let pageName = req.parameters.getCatchall().joined(separator: "/").split(separator: " ").joined(separator: "\\ ")
        let filePath = "\(directoryURL)/\(pageName)"
        let showContent = try content.unixShell(command: "more", option: nil, path: filePath)
        return showContent
    }
    
    // Saving modified page content
    pages.post("**") { req -> HTTPStatus in
        let pageContent = try req.content.decode(PageContent.self)
        let pageName = req.parameters.getCatchall().joined(separator: "/").split(separator: " ").joined(separator: "\\ ")
        let fullPath = "\(directoryURL)/\(pageName)"
        let pagesActns = ActionWithPages()
        let _ = try pagesActns.unixShell(command: "echo", option: """
                                                                  -e "\(pageContent.content)" | tee
                                                                  """, path: fullPath)

        return .ok
    }

    // Creating new page
    pages.post("createPage") { req -> HTTPStatus in 
        var pageParams = try req.content.decode(PageParams.self)
        let pagesActns = ActionWithPages()
        let fullPath = "\(directoryURL)/"
        let _ = try pagesActns.unixShell(command: "echo", option: """
                                                                        "---

                                                                        ID: \(pageParams.ID)
                                                                        title: \(pageParams.title)
                                                                        user: \(pageParams.userName)
                                                                        level: \(pageParams.level)
                                                                        serialNumber: \(pageParams.sNumber)
                                                                        parentID: \(pageParams.parentID = nil)

                                                                        ---"
                                                                        """, path: "> \(fullPath)\(pageParams.ID).md")
        return .ok
    }

    pages.delete("**") { req -> HTTPStatus in 
        let pageName = req.parameters.getCatchall().joined(separator: "/").split(separator: " ").joined(separator: "\\ ")
        let pagesActns = ActionWithPages()
        let fullPath = "\(directoryURL)/\(pageName)"
        let _ = try pagesActns.unixShell(command: "rm", option: nil, path: fullPath)

        return .ok
    }
}
