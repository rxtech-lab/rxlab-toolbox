//
//  ProjectHistory.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/19/24.
//
import SwiftData
import SwiftUI

@Model
class ProjectHistory {
    var name: String
    var path: String
    var createdAt: Date

    init(name: String, path: String) {
        self.name = name
        self.path = path
        createdAt = Date()
    }
}
