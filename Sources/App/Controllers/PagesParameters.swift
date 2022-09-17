import Vapor

struct PagesParameters: Codable {
    enum ServerComands: String {
        case pagesParamas = "rg -U -H --pcre2 -m1 '(?<=---\\s)(.|\\r|\\n)*?(?=---)'"
    }


    func getPageParametersFromDirectory (_ path: String) throws -> [[String: String]] {
        let shellController = ShellController()
        let titlePagesFromBash = try shellController.unixCommand(command: ServerComands.pagesParamas.rawValue, option: nil, path: "\(path)*.md | rg --pcre2 ':title:'")
        let childDirectoryFieldFromBash = try shellController.unixCommand(command: ServerComands.pagesParamas.rawValue, option: nil, path: "\(path)*.md | rg --pcre2 ':childDirectory: true'") 
        let arrayPages = titlePagesFromBash.split(separator: "\n")
        let arrayChildDirectories = childDirectoryFieldFromBash.split(separator: "\n")
              
        if(String(arrayPages[0].split(separator: ":")[0]) != "zsh"){ 
                    
            var formatter = FormatPageParameters(arrayPages: arrayPages, arrayDirestories: arrayChildDirectories)
                
            return formatter.formatting()

        } else {
            return []
        }
    } 


    func getPageParameters(command: String,directory: String? = nil) throws -> String {
        let rootDirectory = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".stranitsy").path
        var formattedPage: [[String: String]] = []
        var JSON : String? = "[]"
        switch command {
            case "list":
                    formattedPage = try getPageParametersFromDirectory("\(rootDirectory)/")
                    let jsonData = try JSONEncoder().encode(formattedPage)
                    JSON = String(data: jsonData, encoding: String.Encoding.utf8)

                break
            case "listPagesFromDirectory":
                let path : Array<String> = directory!.split(separator: "/").map{ String($0)}
                var heirarchy : [Int : [[String: String]]] = [:]
                var pathInsideApp: String = "/"
                var index : Int = 0
                while index <= path.count{
                    heirarchy[index] = try getPageParametersFromDirectory("\(rootDirectory)\(pathInsideApp)")
                    if index < path.count {pathInsideApp += "\(path[index])/"}
                    index += 1
                    
                }

                
                let jsonData = try JSONEncoder().encode(heirarchy)
                JSON = String(data: jsonData, encoding: String.Encoding.utf8)
                break

            default:
                break
        }

        return JSON!
    }
}