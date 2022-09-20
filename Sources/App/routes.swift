import Vapor

func routes(_ app: Application) throws {

    let directoryURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".stranitsy").path
    let pagesParameters = PagesParameters()
    let pages = app.grouped("list")

    // Getting a list of pages
    pages.get { req -> String in
        let getListPages = try pagesParameters.getPageParameters(command: "list")

        return getListPages
    }

    // Getting a list of pages from directory
    pages.get("**") { req -> String in 
        let directoryName = req.parameters.getCatchall()
        let directory = directoryName.joined(separator: "/")
        let getListPages = try pagesParameters.getPageParameters(command: "listPagesFromDirectory", directory: directory)

        return getListPages
    }
    
    // Getting page content
    pages.get("blob", "main", "**") { req -> String in
        let content = ShellController()

        let pageName = req.parameters.getCatchall().joined(separator: "/").split(separator: " ").joined(separator: "\\ ")
        let filePath = "\(directoryURL)/\(pageName)"

        // Sending page key for jumping to lower directory
        // let childDirectory = try content.unixCommand(command: "grep -H '^childDirectory:'", option: nil, path: filePath)
        // if childDirectory != "" {
        //     print(pageName)
        //     try pagesParameters.getPageParameters(command: "listPagesFromDirectory", directory: pageName)
        // }

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
