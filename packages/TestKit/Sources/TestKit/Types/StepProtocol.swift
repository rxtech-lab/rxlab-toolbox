//
//  StepProtocol.swift
//  TestKit
//
//  Created by Qiwei Li on 11/24/24.
//
import Foundation

public protocol StepProtocol: Codable, Identifiable, Hashable {
    var id: UUID { get }
}
