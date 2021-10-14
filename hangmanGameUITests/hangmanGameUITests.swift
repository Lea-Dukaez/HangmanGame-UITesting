//
//  hangmanGameUITests.swift
//  hangmanGameUITests
//
//  Created by Léa Dukaez on 12/10/2021.
//

import XCTest

class hangmanGameUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_Existing_tableView_with_2_rows() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let table = app.tables["ListOfThemes"]
        XCTAssertTrue(table.exists)
        XCTAssert(table.cells.count == 2)

        let cell0 = table.cells["themeCell_0"]
        let cell1 = table.cells["themeCell_1"]
        
        XCTAssertTrue(cell0.exists)
        XCTAssertTrue(cell1.exists)
        
        XCTAssertTrue(cell0.staticTexts.element.label == "espace")
        XCTAssertTrue(cell1.staticTexts.element.label == "animaux")
    }
    
    func test_working_Hint() {
        let app = XCUIApplication()
        app.launch()
        
        let cell0 = app.tables["ListOfThemes"].cells["themeCell_0"]
        cell0.tap()
    
        let navBarTitle = app.navigationBars.staticTexts.element.label
        XCTAssertTrue(navBarTitle == "espace")
        
        app.navigationBars["espace"].buttons["lightbulb"].tap()
        XCTAssertTrue(app.alerts["Indice"].exists)

        let messageIndice = app.alerts["Indice"].staticTexts.element(boundBy: 1).label
        let allActualSpaceTexts = """
EPOQUE: Point déterminé dans le temps, marquant le début d'une ère.
LUSTRE: Période de temps longue et indéterminée.
SIECLE: Période de cent années environ, considérée comme une unité historique.
ETOILE: Astre producteur et émetteur d'énergie.
ATMOSPHERE: Couche gazeuse qui entoure le globe terrestre.
GALAXIE: Vaste amas d'étoiles, l'une des structures essentielles de l'Univers.
"""
        XCTAssertTrue(allActualSpaceTexts.contains(messageIndice))
        app.alerts["Indice"].buttons["Retour"].tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
