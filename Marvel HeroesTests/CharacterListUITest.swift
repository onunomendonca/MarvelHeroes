//
//  CharacterListUITest.swift
//  Marvel HeroesTests
//
//  Created by Nuno Miguel Mendonça on 05/01/2022.
//

//import XCTest
//
//class CharacterListUITest: XCTestCase {
//    var app: XCUIApplication!
//
//        // MARK: - XCTestCase
//
//        override func setUp() {
//            super.setUp()
//
//            // Since UI tests are more expensive to run, it's usually a good idea
//            // to exit if a failure was encountered
//            continueAfterFailure = false
//
//            app = XCUIApplication()
//
//            // We send a command line argument to our app,
//            // to enable it to reset its state
//            app.launchArguments.append("--uitesting")
//        }
//
//        // MARK: - Tests
//
//        func testGoingThroughOnboarding() {
//            app.launch()
//
//            // Make sure we're displaying onboarding
//            XCTAssertTrue(app.isDisplayingOnboarding)
//
//            // Swipe left three times to go through the pages
//            app.swipeDown()
//
//            // Tap the "Done" button
//            //app.buttons[]
//
//            // Onboarding should no longer be displayed
//            XCTAssertFalse(app.isDisplayingOnboarding)
//        }
//    }
//
//extension CharacterListUITest {
//    var isDisplayingOnboarding: Bool {
//        return otherElements["Super Marvel Heroes"].exists
//    }
//}
