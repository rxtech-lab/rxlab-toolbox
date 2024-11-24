//
//  utils.swift
//  TestKit
//
//  Created by Qiwei Li on 11/24/24.
//
import Foundation

func findStepsForIndex(index: Int, steps: [TestStep]) -> [TestStep] {
    for step in steps {
        if case .group(let group) = step,
           group.name == "group-\(index)"
        {
            return group.children
        }
    }
    return []
}

// Helper function to find group ID for a specific index
func findGroupIdForIndex(index: Int, steps: [TestStep]) -> UUID? {
    for step in steps {
        if case .group(let group) = step,
           group.name == "group-\(index)"
        {
            return group.id
        }
    }
    return nil
}
