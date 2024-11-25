//
//  StepContext.swift
//  TestKit
//
//  Created by Qiwei Li on 11/25/24.
//

// StepContext.swift
public struct StepContext {
    let step: TestStep
    var type: String = "a"
    
    struct MessageExpectation {
        let comparison: String
        let text: String
    }
    
    struct CountExpectation {
        let comparison: String
        let count: Int
    }
    
    // Type flags
    let isButtonClick: Bool
    let isTextInput: Bool
    let isExpectMessageText: Bool
    let isExpectMessageCount: Bool
    let isGroup: Bool
    
    // Step values
    let buttonClick: ButtonClickStep?
    let textInput: TextInputStep?
    let expectMessageText: MessageExpectation?
    let expectMessageCount: CountExpectation?
    let group: GroupStep?
    let children: [StepContext]
    
    init(step: TestStep) {
        self.step = step
        
        // Initialize all type flags and values at once
        switch step {
        case .buttonClick(let value):
            self.isButtonClick = true
            self.isTextInput = false
            self.isExpectMessageText = false
            self.isExpectMessageCount = false
            self.isGroup = false
            
            self.buttonClick = value
            self.textInput = nil
            self.expectMessageText = nil
            self.expectMessageCount = nil
            self.group = nil
            self.children = []
            
        case .textInput(let value):
            self.isButtonClick = false
            self.isTextInput = true
            self.isExpectMessageText = false
            self.isExpectMessageCount = false
            self.isGroup = false
            
            self.buttonClick = nil
            self.textInput = value
            self.expectMessageText = nil
            self.expectMessageCount = nil
            self.group = nil
            self.children = []
            
        case .expectMessageText(let value):
            self.isButtonClick = false
            self.isTextInput = false
            self.isExpectMessageText = true
            self.isExpectMessageCount = false
            self.isGroup = false
            self.type = "expectMessageText"
            
            self.buttonClick = nil
            self.textInput = nil
            switch value.text {
            case .equals(let string):
                self.expectMessageText = MessageExpectation(comparison: "equals", text: string)
            case .notEquals(let string):
                self.expectMessageText = MessageExpectation(comparison: "notEquals", text: string)
            case .contains(let string):
                self.expectMessageText = MessageExpectation(comparison: "contains", text: string)
            case .notContains(let string):
                self.expectMessageText = MessageExpectation(comparison: "notContains", text: string)
            }
            self.expectMessageCount = nil
            self.group = nil
            self.children = []
            
        case .expectMessageCount(let value):
            self.isButtonClick = false
            self.isTextInput = false
            self.isExpectMessageText = false
            self.isExpectMessageCount = true
            self.isGroup = false
            self.type = "expectMessageCount"
            
            self.buttonClick = nil
            self.textInput = nil
            self.expectMessageText = nil
            switch value.count {
            case .equals(let int):
                self.expectMessageCount = CountExpectation(comparison: "equals", count: int)
            case .notEquals(let int):
                self.expectMessageCount = CountExpectation(comparison: "notEquals", count: int)
            case .greaterThan(let int):
                self.expectMessageCount = CountExpectation(comparison: "greaterThan", count: int)
            case .lessThan(let int):
                self.expectMessageCount = CountExpectation(comparison: "lessThan", count: int)
            }
            self.group = nil
            self.children = []
            
        case .group(let value):
            self.isButtonClick = false
            self.isTextInput = false
            self.isExpectMessageText = false
            self.isExpectMessageCount = false
            self.isGroup = true
            
            self.buttonClick = nil
            self.textInput = nil
            self.expectMessageText = nil
            self.expectMessageCount = nil
            self.group = value
            self.children = value.children.map(StepContext.init)
        }
    }
}
