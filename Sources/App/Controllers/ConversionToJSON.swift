struct ConversionToJSON {
    
    func toJSON(_ listPages: String) throws -> [[String : String]] {
        var listDicts = [[String: String]]()
        var stringToJSON = [String: String]()

        for value in listPages.split(separator: "\n") {
            
            let splitedValue = value.split(separator: "/")

            let firstIndexs = splitedValue.firstIndex(where: {$0 == ".stranitsy"})!
            let pathToFile = splitedValue[firstIndexs + 1 ..< splitedValue.endIndex]
                
            if pathToFile.count > 1 {
                stringToJSON["name"] = "\(pathToFile)"
                stringToJSON["url"] = "/\(pathToFile.joined(separator: "/"))"
            }
            else {
                stringToJSON = ["name": "\(pathToFile.last!)",
                                "url": "/\(pathToFile.last!)"]
            }

            listDicts.append(stringToJSON)
        }

        return listDicts
    }
}