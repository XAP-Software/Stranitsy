import Foundation

struct Book {

    var ID: UUID
    var title: String
    var linkToRepo: String
    var pages: [Page]? = nil

    let createdBy: User
    var lastChangedBy: User
    var authorizedToChange: [User]
    var authorizedToView: [User]

    public static func create(title: String, linkToRepo: String, createdBy: User, parentPage: UUID?) -> Book {
        let id = UUID()
        let book = Book(ID: id,
                        title: title,
                        linkToRepo: linkToRepo,
                        pages: [],
                        createdBy: createdBy,
                        lastChangedBy: createdBy,
                        authorizedToChange: [createdBy],
                        authorizedToView: [createdBy])
        return book
    }

}
