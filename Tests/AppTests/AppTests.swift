@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    func testSafeShell() throws {
        
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "list", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "book.md\nfile.md\nfiles.md\npage1.1.md\npage1.md\n")
        })
        
        try app.test(.GET, "list/page1", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "Saving data with FileManager is easy!")
        })
    }
}
