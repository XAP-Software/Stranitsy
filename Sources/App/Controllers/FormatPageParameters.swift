struct FormatPageParameters {
    let arrayPages: [String.SubSequence]
    let arrayDirestories: [String.SubSequence]
    var processedPageTitles: [String: String]

    mutating func formatting() -> [String: String] {
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