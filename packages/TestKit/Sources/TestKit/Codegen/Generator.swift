//
//  Generator.swift
//  TestKit
//
//  Created by Qiwei Li on 11/25/24.
//
import Stencil
import StencilSwiftKit

typealias Template = String

struct Generator {
    let template: Template

    init(template: Template) {
        self.template = template
    }

    func generate(with testPlan: TestPlan) throws -> String {
        let ext = Extension()
        ext.registerStencilSwiftExtensions()
        let env = Environment(extensions: [ext])
        let context: [String: Any] = [
            "testPlan": testPlan,
            "steps": testPlan.steps.map(StepContext.init)
        ]
        let rendered = try env.renderTemplate(string: self.template, context: context)
        return rendered
    }
}
