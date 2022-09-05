import Vapor

struct PagesParameters: Codable {

    func getPageParameters(command: String, directory: String? = nil) throws -> [String: String] {
        let shellController = ShellController()
        let directoryURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".stranitsy").path

        switch command {
            // case "listPagesFromDirectory":

            //     return "a"

            // case "user":
            // case "level":
            // case "serialNumber":
            // case "parentID":
            default:
                let titlePagesFromBash = try shellController.unixCommand(command: "grep -w '^title':", option: nil, path: "\(directoryURL)/*.md")
                let arrayPages = titlePagesFromBash.split(separator: "\n")
                let directories = try shellController.unixCommand(command: "ls", option: "-d", path: "\(directoryURL)/*/")
                let arrayDirestories = directories.split(separator: "\n")
                var processedPageTitles: [String: String] = [:]

                for page in arrayPages {
                    let pageTitleWithName = page.split(separator: "/").last!
                    processedPageTitles[String(pageTitleWithName.split(separator: ":")[0])] = String(pageTitleWithName.split(separator: ":")[2].trimmingCharacters(in: .whitespacesAndNewlines))
                }

                for directory in arrayDirestories {
                    processedPageTitles[String(directory.split(separator: "/").last!)] = String(directory.split(separator: "/").last!)
                }

                return processedPageTitles
        }
    }
}