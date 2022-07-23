import Vapor

func routes(_ app: Application) throws {

    let directoryURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".stranitsy").path
    let pages = app.grouped("list")

    // Getting a list of pages
    pages.get { req -> [[String : String]] in
        let shellController = ShellController()
        let convert = ConversionToJSON()

        let pathToFile = "\(directoryURL)/**/*.md"

        let listPages = try shellController.unixCommand(command: "ls", option: "-R", path: pathToFile)
        let JSON = try convert.toJSON(listPages)

        return JSON
    }
    
    // Getting page content
    pages.get("**") { req -> String in
        let content = ShellController()

        let pageName = req.parameters.getCatchall().joined(separator: "/").split(separator: " ").joined(separator: "\\ ")
        let filePath = "\(directoryURL)/\(pageName)"

        let showContent = try content.unixCommand(command: "more", option: nil, path: filePath)

        return showContent
    }
    
    // Saving modified page content
    pages.post("**") { req -> HTTPStatus in
        let pageContent = try req.content.decode(PageContent.self)
        let pagesActns = ShellController()

        let pageName = req.parameters.getCatchall().joined(separator: "/").split(separator: " ").joined(separator: "\\ ")
        let filePath = "\(directoryURL)/\(pageName)"

        let _ = try pagesActns.unixCommand(command: "echo", option: """
                                                                  -e "\(pageContent.content)" | tee
                                                                  """, path: filePath)

        return .ok
    }

    // Creating new page
    pages.post("createPage") { req -> HTTPStatus in 
        var pageParams = try req.content.decode(PageParams.self)
        let pagesActns = ShellController()
        let fullPath = "\(directoryURL)/"
        let _ = try pagesActns.unixCommand(command: "echo", option: """
                                                                        "---

                                                                        ID: \(pageParams.ID)
                                                                        title: \(pageParams.title)
                                                                        userName: \(pageParams.userName)
                                                                        level: \(pageParams.level)
                                                                        serialNumber: \(pageParams.sNumber)
                                                                        parentID: \(pageParams.parentID = nil)

                                                                        ---"
                                                                        """, path: "> \(fullPath)\(pageParams.ID).md")
        return .ok
    }

    pages.delete("**") { req -> HTTPStatus in 
        let pagesActns = ShellController()

        let pageName = req.parameters.getCatchall().joined(separator: "/").split(separator: " ").joined(separator: "\\ ")
        let fullPath = "\(directoryURL)/\(pageName)"

        let _ = try pagesActns.unixCommand(command: "rm", option: nil, path: fullPath)

        return .ok
    }
}
