import Fluent

final class Page: Model {
    // Name of the table or collection.
    static let schema = "page"

    // Unique identifier for this Page.
    @ID(key: .id)
    var id: UUID?

    // The Page's title.
    @Field(key: "title")
    var title: String
    
    @Field(key: "userName")
    var userName: String

    @Field(key: "level")
    var level: String
    
    @Field(key: "serialNumber")
    var serialNumber: String

    // The Page's parentID.
    @Field(key: "parentID")
    var title: String

    // Creates a new, empty Page.
    init() { }

    // Creates a new Page with all properties set.
    init(id: UUID? = nil, title: String) {
        self.ID = ID
        self.title = title
        self.userName = userName
        self.level = level
        self.serialNumber = serialNumber
        self.parentID = parentID
    }
}