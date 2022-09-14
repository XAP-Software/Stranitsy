struct FormatPageParameters {
    let arrayPages: [String.SubSequence]
    let arrayDirestories: [String.SubSequence]
    var processedPageTitles: [[String: String]]

    mutating func formatting() -> [[String: String]] {

        var childsExisting: [String: Bool] = [:]
        if arrayDirestories != []{
            for directory in arrayDirestories{
                let key = String(directory.split(separator: "/").last!.split(separator: ":")[0].split(separator:".")[0])
                let value = String(directory.split(separator: ":")[2].split(separator: " ")[0])
                childsExisting[key] = Bool(value)
            }
        }

        if arrayPages != [] {
            for page in arrayPages {
                let pageTitleWithName = page.split(separator: "/").last!
                let key = String(pageTitleWithName.split(separator: ":")[0])
                let value = String(pageTitleWithName.split(separator: ":")[2].trimmingCharacters(in: .whitespacesAndNewlines))
                let directory: String = childsExisting[String(key.split(separator:".")[0])] == nil ? "false" : String(childsExisting[String(key.split(separator:".")[0])]!)
                processedPageTitles.append(["key": key, "value": value, "directory": directory])
            }
        }

        return processedPageTitles
    }
}