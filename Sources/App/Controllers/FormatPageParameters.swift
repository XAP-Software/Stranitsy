struct FormatPageParameters {
    let arrayPages: [String.SubSequence]
    let arrayDirestories: [String.SubSequence]
    var processedPageTitles: [[String: String]]

    mutating func formatting() -> [[String: String]] {

        if arrayPages != [] {
            for page in arrayPages {
                let pageTitleWithName = page.split(separator: "/").last!
                processedPageTitles.append(["key": String(pageTitleWithName.split(separator: ":")[0]), 
                                            "value": String(pageTitleWithName.split(separator: ":")[2].trimmingCharacters(in: .whitespacesAndNewlines))])
            }
        }

        if arrayDirestories != [] {
            for directory in arrayDirestories {
                processedPageTitles.append(["key": String(directory.split(separator: "/").last!), 
                                            "value": String(directory.split(separator: "/").last!)])
            }
        }

        return processedPageTitles
    }
}