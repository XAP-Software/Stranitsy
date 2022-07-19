@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    func testSafeShell() throws {
        
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "list", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, #"""
                                                [{"url":"\/5FFA0A86-34FF-4959-B819-1F4E5DF8A18B.md","name":"5FFA0A86-34FF-4959-B819-1F4E5DF8A18B.md"},{"name":"997100FF-9408-4F80-884D-78DF8EF2FA5E.md","url":"\/997100FF-9408-4F80-884D-78DF8EF2FA5E.md"},{"url":"\/Article.md","name":"Article.md"},{"url":"\/EE4E76EF-EC8A-40DC-961F-1C61D7021A7F.md","name":"EE4E76EF-EC8A-40DC-961F-1C61D7021A7F.md"},{"url":"\/EE4E76EF-EC8A-40DC-961F-1C61D7021A7F\/contacts.md","name":"2"},{"url":"\/New book\/book for test.md","name":"2"},{"url":"\/New page.md","name":"New page.md"},{"url":"\/book.md","name":"book.md"},{"name":"page1.md","url":"\/page1.md"},{"name":"pages.md","url":"\/pages.md"},{"name":"Новая страница.md","url":"\/Новая страница.md"},{"name":"2","url":"\/книга1\/empty page.md"},{"name":"2","url":"\/книга1\/files.md"},{"name":"3","url":"\/книга1\/книга1.2\/page1.2.md"},{"name":"2","url":"\/книга2\/page1.1.md"}]
                                                """#)
        })
        
        try app.test(.GET, "list/page1.md", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, """
                                                
                                                ---

                                                ID: 123dfs-wrwf23-23d2-3413

                                                title: wdfef

                                                userName: Kostya


                                                ---

                                                Saving data with FileManager is easy!

                                                """)
        })

        try app.test(.POST, "list/createPages", beforeRequest: { req in
            try req.content.encode(["title": "Test",
                                    "userName": "Somebody",
                                    "level": "2",
                                    "sNumber": "1",
                                    "parentID": "797E2F6D-4126-49FD-8D90-2C88C56D80A6",
                                    "ID": "EE4E76EF-EC8A-40DC-961F-1C61D7021A7F"])
        }, afterResponse: { res in
                XCTAssertEqual(res.status, .ok)
                let pageParams = try res.content.decode(PageParams.self)
                XCTAssertEqual(pageParams.ID, "EE4E76EF-EC8A-40DC-961F-1C61D7021A7F")
                XCTAssertEqual(pageParams.title, "Test")
                XCTAssertEqual(pageParams.userName, "Somebody")
                XCTAssertEqual(pageParams.level, "2")
                XCTAssertEqual(pageParams.sNumber, "1")
                XCTAssertEqual(pageParams.parentID, "797E2F6D-4126-49FD-8D90-2C88C56D80A6")
        })
    }
}
