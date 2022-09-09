import Vapor

struct PagesParameters: Codable {

    func getPageParameters(command: String, directory: String? = nil) throws -> String {
        let shellController = ShellController()
        let rootDirectory = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".stranitsy").path
        var formattedPage: [[String: String]] = []

        let pathInsideApp: String

        if directory == nil {
            pathInsideApp = "./"
        } else {
            pathInsideApp = directory! + "/"
        }

        let titlePagesFromBash = try shellController.unixCommand(command: "grep -H '^title:'", option: nil, path: "\(rootDirectory)/\(pathInsideApp)*.md")
        let childDirectoryFieldFromBash = try shellController.unixCommand(command: "grep -H '^childDirectory:'", option: nil, path: "\(rootDirectory)/\(pathInsideApp)*.md")
        // let directories = try shellController.unixCommand(command: "ls", option: "-d", path: "\(rootDirectory)/\(pathInsideApp)*/")
        
        var arrayPages = titlePagesFromBash.split(separator: "\n")
        var arrayChildDirectories = childDirectoryFieldFromBash.split(separator: "\n")
        // var arrayDirestories = directories.split(separator: "\n")


        let processedPageTitles: [[String: String]] = []

        var formatter = FormatPageParameters(arrayPages: arrayPages, arrayDirestories: arrayChildDirectories, processedPageTitles: processedPageTitles)

        formattedPage = formatter.formatting()

        switch command {
            // case "listPagesFromDirectory":
            //     let processedPageTitles: [[String: String]] = []

            //     // Checking directories for pages and other directories
            //     let checkForPages = try shellController.unixCommand(command: "ls \(rootDirectory)/\(pathInsideApp)*.md", option: "|", path: "grep '(no matches found)*'")
            //     let checkForDirs = try shellController.unixCommand(command: "ls \(rootDirectory)/\(pathInsideApp)*/", option: "|", path: "grep '(no matches found)*'")

            //     if checkForDirs != "" {arrayDirestories = []}
            //     if checkForPages != "" {arrayPages = []}

            //     var formatter = FormatPageParameters(arrayPages: arrayPages, arrayDirestories: arrayDirestories, processedPageTitles: processedPageTitles)
            //     formattedPage = formatter.formatting()

            // case "user":
            // case "level":
            // case "serialNumber":
            // case "parentID":
            default:
                let processedPageTitles: [[String: String]] = []

                // Checking directories for pages and other directories
                let checkForPages = try shellController.unixCommand(command: "ls \(rootDirectory)/\(pathInsideApp)*.md", option: "|", path: "grep '(no matches found)*'")
                let checkForDirs = try shellController.unixCommand(command: "ls \(rootDirectory)/\(pathInsideApp)*/", option: "|", path: "grep '(no matches found)*'")

                if checkForDirs != "" {arrayChildDirectories = []}
                if checkForPages != "" {arrayPages = []}

                var formatter = FormatPageParameters(arrayPages: arrayPages, arrayDirestories: arrayChildDirectories, processedPageTitles: processedPageTitles)
                formattedPage.append(formatter.formatting()[0])
            //     let processedPageTitles: [[String: String]] = []

            //     var formatter = FormatPageParameters(arrayPages: arrayPages, arrayDirestories: arrayDirestories, processedPageTitles: processedPageTitles)

            //     formattedPage = formatter.formatting()
        }

        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(formattedPage)
        let JSON = String(data: jsonData, encoding: String.Encoding.utf8)

        return JSON!
    }
}