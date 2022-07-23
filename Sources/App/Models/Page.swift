import Foundation

struct Page {

    // Main parameters in page
    let ID: UUID
    var title: String
    var content: String?

    // User data as a page parameters
    let createdBy: User
    var lastChangedBy: User
    var authorizedToChange: [User]
    var authorizedToView: [User]

    // Parents and children data page
    var parentPageID: UUID?
    var childPageIDs: [UUID]

    public static func create(title: String, content: String? = nil, createdBy: User, parentPage: UUID?) -> Page {
        let id = UUID()
        let page = Page(ID: id, 
                               title: title, 
                               content: content, 
                               createdBy: createdBy, 
                               lastChangedBy: createdBy, 
                               authorizedToChange: [createdBy], 
                               authorizedToView: [createdBy], 
                               parentPageID: parentPage, 
                               childPageIDs: [UUID]())
        return page
    }
}
