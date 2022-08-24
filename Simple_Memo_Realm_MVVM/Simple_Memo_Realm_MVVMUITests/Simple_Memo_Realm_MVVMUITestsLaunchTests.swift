//
//  Simple_Memo_Realm_MVVMUITestsLaunchTests.swift
//  Simple_Memo_Realm_MVVMUITests
//
//  Created by Minhyun Cho on 2022/08/24.
//

import XCTest

class Simple_Memo_Realm_MVVMUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
