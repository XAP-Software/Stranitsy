import Foundation

struct User {

    // User credentials
    var login: String
    var name: String
    var secondName: String

    // User credentials in git repository
    var loginGit: String
    var tokenGit: String

    public static func create(login: String, name: String, secondName: String) -> User {
        let loginGit = "Some login"
        let tokenGit = "Some token"

        return User(login: login, name: name, secondName: secondName, loginGit: loginGit, tokenGit: tokenGit)
    }
}
