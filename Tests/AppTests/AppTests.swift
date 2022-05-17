@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    func testSafeShell() throws {
        
        let listFiles: String = "book.md\nfile.md\nfiles.md\npage1.1.md\npage1.md\n"
        
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "home", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "Hello, world!")
        })
    }
}
