import Vapor

struct PagesParameters: Codable {

    func getPageParameters(command: String, directory: String? = nil) throws -> [String: String] {
        let shellController = ShellController()
        let rootDirectory = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".stranitsy").path

        let titlePagesFromBash: String
        let directories: String

        if directory == nil {
            titlePagesFromBash = try shellController.unixCommand(command: "grep -H '^title':", option: nil, path: "\(rootDirectory)/*.md")
            directories = try shellController.unixCommand(command: "ls", option: "-d", path: "\(rootDirectory)/*/")
        } else {
            titlePagesFromBash = try shellController.unixCommand(command: "grep -H '^title':", option: nil, path: "\(rootDirectory)/\(directory!)/*.md")
            directories = try shellController.unixCommand(command: "ls", option: "-d", path: "\(rootDirectory)/\(directory!)/*/")
        }

        let arrayPages = titlePagesFromBash.split(separator: "\n")
        let arrayDirestories = directories.split(separator: "\n")

        switch command {
            case "listPagesFromDirectory":
                var processedPageTitles: [String: String] = [:]

                guard arrayPages.count > 1 else {
                    let key_PageName = String(arrayPages[0].split(separator: ":")[0].split(separator: "/").last!)
                    let value_PageTitle = arrayPages[0].split(separator: ":")[2].trimmingCharacters(in: .whitespacesAndNewlines)

                    processedPageTitles[key_PageName] = value_PageTitle
                    processedPageTitles[String(arrayDirestories[0].split(separator: "/").last!)] = String(arrayDirestories[0].split(separator: "/").last!)
                    processedPageTitles["..."] = "./"

                    return processedPageTitles
                }
                
                var formatter = FormatPageParameters(arrayPages: arrayPages, arrayDirestories: arrayDirestories, processedPageTitles: processedPageTitles)
                var formattedPage = formatter.formatting()
                
                formattedPage["..."] = "./"

                return formattedPage

            // case "user":
            // case "level":
            // case "serialNumber":
            // case "parentID":
            default:
                let processedPageTitles: [String: String] = [:]

                var formatter = FormatPageParameters(arrayPages: arrayPages, arrayDirestories: arrayDirestories, processedPageTitles: processedPageTitles)

                return formatter.formatting()
        }
    }
}