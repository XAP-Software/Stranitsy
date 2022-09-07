@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    func testSafeShell() throws {
        
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "list", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let list = try PagesParameters().getPageParameters(command: "list")
            // let expectedValue = ["key":"09AC82E1-D4AD-44D9-8062-06434C728442.md","value":"Новая_страница"]
            let expectedValue = 
                                            [["key":"09AC82E1-D4AD-44D9-8062-06434C728442.md","value":"Новая_страница"],
                                            ["key":"5FFA0A86-34FF-4959-B819-1F4E5DF8A18B.md","value":"parap"],
                                            ["key":"633A3CE0-3EC4-4DAF-BD2B-502B6A4D0020.md","value":"Article"],
                                            ["key":"633A3CE0-3EC4-4DAF-BD2B-502B6A4D0021.md","value":"Page_on_1_level"],
                                            ["key":"633A3CE0-3EC4-4DAF-BD2B-502B6A4D0022.md","value":"Contacts"],
                                            ["value":"Book_for_test","key":"633A3CE1-3EC4-4DAF-BD2B-502B6A4D0022.md"],
                                            ["value":"Xap_soft","key":"997100FF-9408-4F80-884D-78DF8EF2FA5E.md"],
                                            ["key":"EE4E76EF-EC8A-40DC-961F-1C61D7021A7F.md","value":"About"],
                                            ["value":"New_page","key":"FCF8BFB5-2CFF-4821-A2DE-7C47314D0F6E.md"],
                                            ["key":"FCF8BFB5-2CFF-4821-A2DE-7C47315D0F6E.md","value":"Page_on_1_level_with_mock_text"],
                                            ["key":"FCF8BFB5-2CFF-4821-A2DE-7C47515D0F6E.md","value":"Testing_page"],
                                            ["value":"Empty_page","key":"FCF8BFB5-2CFF-4821-A2DE-7C47525D0F6E.md"],
                                            ["value":"997100FF-9408-4F80-884D-78DF8EF2FA5E","key":"997100FF-9408-4F80-884D-78DF8EF2FA5E"],
                                            ["value":"EE4E76EF-EC8A-40DC-961F-1C61D7021A7F","key":"EE4E76EF-EC8A-40DC-961F-1C61D7021A7F"],
                                            ["value":"F5744F7A-CFB2-422C-8B8D-A716DAEBD825","key":"F5744F7A-CFB2-422C-8B8D-A716DAEBD825"],
                                            ["value":"FCF8BFB5-2CFF-4821-A2DE-7C47515D0F6E","key":"FCF8BFB5-2CFF-4821-A2DE-7C47515D0F6E"],
                                            ["value":"sdf","key":"sdf"]]
            XCTAssertEqual(list, expectedValue)
        })

        try app.test(.GET, "list/blob/main/FCF8BFB5-2CFF-4821-A2DE-7C47515D0F6E/FCF8BFB5-2CFF-4821-A2DE-7C47525D0F6E/633A3CE0-3EC4-4DAF-BD2B-502B6A4D0031.md", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let expectedValue = #"""

                                        ---

                                        ID: 633A3CE0-3EC4-4DAF-BD2B-502B6A4D0031
                                        title: Page_on_3_level
                                        userName: Kostya
                                        level: 3
                                        serialNumber: 1
                                        parentID: FCF8BFB5-2CFF-4821-A2DE-7C47525D0F6E

                                        ---

                                        Hello fnjnciwj ncijnw qeincpqine pinweiu 1-2938jd- 91j3 oi1dmpioj -ijdo wed/we w'w\[ ep\]\[p\]w\[le \[wpekd pdsmcpowiejfpojpowijr opiwjepoi jpqwcnwepi nwefpowqi enpownefp iwnefpi qwjnel
                                        sdf sdfsd dfsfsd
                                        iw jepij pqwiejf pwqeijf poi

                                        """#
            XCTAssertEqual(res.body.string, expectedValue)
        })
        
        try app.test(.GET, "list/blob/main/FCF8BFB5-2CFF-4821-A2DE-7C47314D0F6E.md", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let expectedValue = """
                                        
                                        ---

                                        ID: FCF8BFB5-2CFF-4821-A2DE-7C47314D0F6E
                                        title: New_page
                                        userName: Kostya
                                        level: 1
                                        serialNumber: 6
                                        parentID: ()


                                        ---

                                        sad

                                        """
            XCTAssertEqual(res.body.string, expectedValue)
        })
    }
}
