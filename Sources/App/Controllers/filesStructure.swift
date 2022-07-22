import Foundation
import Vapor

struct PageContent: Content {
    var content: String
}

struct PageParams: Content {
    var title: String
    var userName: String // after setting up authorizations change on Users
    var level: String
    var sNumber: String
    var parentID: String? = nil
    var ID: String {
        get {
            return UUID().uuidString
        }
    }
}
