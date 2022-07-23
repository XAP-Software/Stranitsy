import Fluent

final class Page: Model {
    // Name of the table or collection.
    static let schema = "page"

    @ID(key: .ID)
    var ID: UUID

    @Field(key: "title")
    var title: String
    
    @Field(key: "userName")
    var userName: User.login

    @Field(key: "level")
    var level: String
    
    @Field(key: "serialNumber")
    var serialNumber: String

    @Field(key: "parentID")
    var parentID: UUID?

    // Creates a new, empty Page.
    init() { }

    // Creates a new Page with all properties set.
    init(ID: UUID, title: String, userName: User.login, level: String, serialNumber: String, parentID: UUID? = nil) {
        self.ID = ID
        self.title = title
        self.userName = User.login
        self.level = level
        self.serialNumber = serialNumber
        self.parentID = parentID
    }
}