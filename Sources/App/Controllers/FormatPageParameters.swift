struct FormatPageParameters {
    let arrayPages: [String.SubSequence]
    let arrayDirestories: [String.SubSequence]

    // var processedPageTitles: [[String: String]]

    mutating func formatting() -> [[String: String]] {
        var childsExisting: [String] = []
        if arrayDirestories != [] {
            childsExisting = arrayDirestories.map {String($0.split(separator: "/").last!.split(separator: ":")[0].split(separator:".")[0])}
        }
        var processedPageTitles: [[String: String]] = []

        if arrayPages != [] {

            for page in arrayPages {
                let pageTitleWithName = page.split(separator: "/").last!
                let key = String(pageTitleWithName.split(separator: ":")[0])
                let value = String(pageTitleWithName.split(separator: ":")[2].trimmingCharacters(in: .whitespacesAndNewlines))
                let directory: String = String(childsExisting.contains(String(key.split(separator:".")[0])))
                processedPageTitles.append(["key": key, "value": value, "directory": directory])
            }
        }
        
        processedPageTitles =  processedPageTitles.sorted(by:  {(s1 : [String: String], s2 : [String: String]) -> Bool in return  s1["key"]! > s2["key"]!})
        return processedPageTitles
    }
}