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
  
        let titlePagesFromBash = try shellController.unixCommand(command: "rg -U --pcre2 -m1 '(?<=---\\s)(.|\\r|\\n)*?(?=---)'", option: nil, path: "\(rootDirectory)/\(pathInsideApp)*.md | rg --pcre2 ':title:'")
        let childDirectoryFieldFromBash = try shellController.unixCommand(command: "rg -U --pcre2 -m1 '(?<=---\\s)(.|\\r|\\n)*?(?=---)' ", option: nil, path: "\(rootDirectory)/\(pathInsideApp)*.md | rg --pcre2 ':childDirectory:'") 
        
        var arrayPages = titlePagesFromBash.split(separator: "\n")
        
        var arrayChildDirectories = childDirectoryFieldFromBash.split(separator: "\n")
  
        let processedPageTitles: [[String: String]] = []

        var formatter = FormatPageParameters(arrayPages: arrayPages, arrayDirestories: arrayChildDirectories, processedPageTitles: processedPageTitles)
    
        formattedPage = formatter.formatting()

  
        switch command {

            case "listPagesFromDirectory":
                let processedPageTitles: [[String: String]] = []

                // Checking directories for pages and other directories
                let checkForPages = try shellController.unixCommand(command: "ls \(rootDirectory)/\(pathInsideApp)*.md", option: "|", path: "grep '(no matches found)*'")
                let checkForDirs = try shellController.unixCommand(command: "ls \(rootDirectory)/\(pathInsideApp)*/", option: "|", path: "grep '(no matches found)*'")

                if checkForDirs != "" {arrayChildDirectories = []}
                if checkForPages != "" {arrayPages = []}

                var formatter = FormatPageParameters(arrayPages: arrayPages, arrayDirestories: arrayChildDirectories, processedPageTitles: processedPageTitles)
                formattedPage.append(formatter.formatting()[0])
            // case "level":
            // case "serialNumber":
            // case "parentID":
            default:
                break
        }
        

        let jsonEncoder = JSONEncoder()

        let jsonData = try jsonEncoder.encode(formattedPage)
   
        let JSON = String(data: jsonData, encoding: String.Encoding.utf8)
        return JSON!
    }
}