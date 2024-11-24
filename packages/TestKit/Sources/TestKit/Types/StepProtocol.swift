//
//  StepProtocol.swift
//  TestKit
//
//  Created by Qiwei Li on 11/24/24.
//
import Foundation

public protocol StepProtocol: Codable, Identifiable, Hashable {
    var id: UUID { get }
    var children: [TestStep] { get }

    func addStep(_ step: TestStep) -> Self
    func updateStep(_ step: TestStep, at id: UUID) -> Self
}
