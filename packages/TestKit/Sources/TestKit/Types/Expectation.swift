//
//  Expectation.swift
//  TestKit
//
//  Created by Qiwei Li on 11/24/24.
//

/**
 MessageExpectationOperator defines the available comparison operations for message count validation.
  
 Examples:
 ```swift
 // Exactly 5 messages
 let exactOperator = MessageExpectationOperator.equals(5)
  
 // More than 3 messages
 let minimumOperator = MessageExpectationOperator.greaterThan(3)
  
 // Less than 10 messages
 let maximumOperator = MessageExpectationOperator.lessThan(10)
 ```
 */
public enum MessageExpectationOperator: Codable, Hashable {
    case equals(Int)
    case notEquals(Int)
    case greaterThan(Int)
    case lessThan(Int)
    
    var rawValue: String {
        switch self {
        case .equals(let value): return "=\(value)"
        case .notEquals(let value): return "!=\(value)"
        case .greaterThan(let value): return ">\(value)"
        case .lessThan(let value): return "<\(value)"
        }
    }
}

/**
 TextExpectationOperator defines the available comparison operations for message text validation.
  
 Examples:
 ```swift
 // Exact text match
 let exactMatch = TextExpectationOperator.equals("Expected response")
  
 // Contains specific text
 let containsMatch = TextExpectationOperator.contains("success")
  
 // Does not contain specific text
 let excludesMatch = TextExpectationOperator.notContains("error")
 ```
 */
public enum TextExpectationOperator: Codable, Hashable {
    case equals(String)
    case notEquals(String)
    case contains(String)
    case notContains(String)
    
    var rawValue: String {
        switch self {
        case .equals(let value): return value
        case .notEquals(let value): return "not eqauls to \(value)"
        case .contains(let value): return "contains \(value)"
        case .notContains(let value): return "not contains \(value)"
        }
    }
}
