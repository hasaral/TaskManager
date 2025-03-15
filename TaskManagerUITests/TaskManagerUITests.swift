//
//  TaskManagerUITests.swift
//  TaskManagerUITests
//
//  Created by Hasan Saral on 11.03.2025.
//

import XCTest

final class TaskManagerUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app.launch()
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTaskCreation() throws {
        let openButton = app.buttons["OpenTaskButton"]
        XCTAssertTrue(openButton.exists)
        openButton.tap()
        
        let detailTextField = app.textFields["TaskTextField"]
        XCTAssertTrue(detailTextField.exists)
        
        XCTAssertTrue(detailTextField.waitForExistence(timeout: 5), "The text field should appear on the screen")
                
        detailTextField.typeText("Buy Groceries")
        
        let dismissButton = app.buttons["DismissButton"]
        XCTAssertTrue(dismissButton.exists, "The add task button does not exist")
        dismissButton.tap()
        
        let textEditorAdd = app.textViews["TextEditorAdd"]
        XCTAssertTrue(textEditorAdd.exists)
        textEditorAdd.tap()
        textEditorAdd.typeText("Milk, bread, chees, eggs, etc.")

        dismissButton.tap()
        
        let datePicker = app.datePickers["DatePickerAdd"]
        XCTAssertTrue(datePicker.exists)

        XCTAssertTrue(datePicker.waitForExistence(timeout: 5), "The DatePicker should appear on the screen")

        datePicker.tap()
        selectDate("19/07/2029", app: app)

        app.datePickers["DatePickerAdd"].forceTap()
 
        
        let addButton = app.buttons["AddTaskButton"]
        XCTAssertTrue(addButton.exists, "The add task button does not exist")
        addButton.tap()
        
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "Task Creation Success"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    func selectDate(_ dateString: String, app: XCUIApplication) {
        guard let date = dateString.toDate() else {
            XCTFail("Invalid date: \(dateString)")
            return
        }

        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMMM"
        let month = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "EEEE, d MMMM"
        let dayLabel = dateFormatter.string(from: date)
        
        // Adjust the date in the date picker
        let dateButton = app.buttons["Month"] // Button labeled "Month"
        dateButton.tap()
        
        dismissKeyboardIfPresent()
        
        let monthPickerWheel = app.pickerWheels.element(boundBy: 0)
        let yearPickerWheel = app.pickerWheels.element(boundBy: 1)
        XCTAssertTrue(monthPickerWheel.exists, "The month PickerWheel must exist")
        XCTAssertTrue(yearPickerWheel.exists, "The year PickerWheel must exist")
        
        monthPickerWheel.adjust(toPickerWheelValue: month)
        yearPickerWheel.adjust(toPickerWheelValue: year)
        dateButton.tap()
    }

    func dismissKeyboardIfPresent() {
        if app.keyboards.element(boundBy: 0).exists {
            if UIDevice.current.userInterfaceIdiom == .pad {
                app.keyboards.buttons["Hide keyboard"].tap()
            } else {
                app.toolbars.buttons["Done"].tap()
            }
        }
    }
}

extension String {
    func toDate(format: String = "dd/MM/yyyy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}

extension XCUIElement {
    func forceTap() {
        if (isHittable) {
            tap()
        } else {
            coordinate(withNormalizedOffset: CGVector(dx:0.0, dy:0.0)).tap()
        }
    }
}

extension XCUIApplication {
    func tapCoordinate(at point: CGPoint) {
        let normalized = coordinate(withNormalizedOffset: .zero)
        let offset = CGVector(dx: point.x, dy: point.y)
        let coordinate = normalized.withOffset(offset)
        coordinate.tap()
    }
}
