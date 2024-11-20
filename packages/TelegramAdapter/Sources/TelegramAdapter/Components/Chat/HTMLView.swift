import SwiftSoup
import SwiftUI

struct HTMLRenderer: View {
    let html: String
    @State private var parsedElements: [HTMLElement] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            if parsedElements.isEmpty {
                Text(html)
                    .font(.body)
            } else {
                ForEach(parsedElements, id: \.id) { element in
                    ElementView(element: element)
                }
            }
        }
        .onChange(of: html) { _, _ in
            parseHTML()
        }
        .onAppear {
            parseHTML()
        }
    }

    private func parseHTML() {
        do {
            let document = try SwiftSoup.parse(html)
            let body = document.body()

            if let body = body {
                parsedElements = splitByNewlines(processNode(body))
            } else {
                parsedElements = [
                    HTMLElement(
                        tag: "text",
                        text: html,
                        children: [],
                        attributes: [:],
                        id: UUID(),
                        isBlock: false
                    )
                ]
            }
        } catch {
            print("Error parsing HTML: \(error)")
            parsedElements = [
                HTMLElement(
                    tag: "text",
                    text: html,
                    children: [],
                    attributes: [:],
                    id: UUID(),
                    isBlock: false
                )
            ]
        }
    }

    private func splitByNewlines(_ elements: [HTMLElement]) -> [HTMLElement] {
        var result: [HTMLElement] = []
        var currentLineElements: [HTMLElement] = []

        func addCurrentLine() {
            if !currentLineElements.isEmpty {
                result.append(
                    HTMLElement(
                        tag: "line",
                        text: "",
                        children: currentLineElements,
                        attributes: [:],
                        id: UUID(),
                        isBlock: true
                    ))
                currentLineElements = []
            }
        }

        for element in elements {
            if element.isBlock {
                addCurrentLine()
                result.append(element)
                continue
            }

            if element.tag == "text" {
                let parts = element.text.components(separatedBy: "\n")
                for (index, part) in parts.enumerated() {
                    if !part.isEmpty {
                        currentLineElements.append(
                            HTMLElement(
                                tag: "text",
                                text: part,
                                children: [],
                                attributes: [:],
                                id: UUID(),
                                isBlock: false
                            ))
                    }
                    if index < parts.count - 1 {
                        addCurrentLine()
                    }
                }
            } else {
                currentLineElements.append(element)
            }
        }

        addCurrentLine()
        return result
    }

    private func processNode(_ node: Node) -> [HTMLElement] {
        var elements: [HTMLElement] = []

        if let element = node as? Element {
            var attributes: [String: String] = [:]
            if let attrs = element.getAttributes() {
                for attr in attrs.asList() {
                    attributes[attr.getKey()] = attr.getValue()
                }
            }

            let blockElements = Set(["div", "p", "h1", "h2", "h3", "h4", "h5", "h6", "hr", "br"])
            let isBlock = blockElements.contains(element.tagName().lowercased())

            var children: [HTMLElement] = []
            for child in node.getChildNodes() {
                children.append(contentsOf: processNode(child))
            }

            if element.tagName() != "body" {
                elements.append(
                    HTMLElement(
                        tag: element.tagName(),
                        text: element.ownText(),
                        children: children,
                        attributes: attributes,
                        id: UUID(),
                        isBlock: isBlock
                    ))
            } else {
                elements.append(contentsOf: children)
            }
        } else if let textNode = node as? TextNode {
            let text = textNode.getWholeText()
            if !text.isEmpty {
                elements.append(
                    HTMLElement(
                        tag: "text",
                        text: text,
                        children: [],
                        attributes: [:],
                        id: UUID(),
                        isBlock: false
                    ))
            }
        }

        return elements
    }
}

struct ElementView: View {
    let element: HTMLElement

    var body: some View {
        Group {
            if element.isBlock {
                blockContent
            } else {
                inlineContent
            }
        }
    }

    @ViewBuilder
    private var inlineContent: some View {
        switch element.tag.lowercased() {
        case "text":
            Text(element.text)
                .font(.body)
        case "strong", "b":
            ForEach(element.children, id: \.id) { child in
                ElementView(element: child)
            }
            .fontWeight(.bold)
        case "em", "i":
            ForEach(element.children, id: \.id) { child in
                ElementView(element: child)
            }
            .italic()
        case "code":
            Text(element.text)
                .foregroundStyle(Color.blue)
                .onHover { isHovered in
                    #if os(macOS)
                        if isHovered {
                            NSCursor.pointingHand.set()
                        } else {
                            NSCursor.pop()
                        }
                    #endif
                }
                .onTapGesture {
                    #if os(macOS)
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(element.text, forType: .string)
                    #endif
                }
        case "a":
            Link(
                element.text,
                destination: URL(string: element.attributes["href"] ?? "") ?? URL(
                    string: "about:blank")!
            )
            .foregroundColor(.blue)
        case "line", "span":
            HStack(spacing: 0) {
                ForEach(element.children, id: \.id) { child in
                    ElementView(element: child)
                }
            }
        default:
            if !element.children.isEmpty {
                HStack(spacing: 0) {
                    ForEach(element.children, id: \.id) { child in
                        ElementView(element: child)
                    }
                }
            } else {
                Text(element.text)
            }
        }
    }

    @ViewBuilder
    private var blockContent: some View {
        switch element.tag.lowercased() {
        case "line":
            HStack(spacing: 0) {
                ForEach(element.children, id: \.id) { child in
                    ElementView(element: child)
                }
            }
        case "h1":
            Text(element.text)
                .font(.largeTitle)
                .fontWeight(.bold)
        case "h2":
            Text(element.text)
                .font(.title)
                .fontWeight(.semibold)
        case "h3":
            Text(element.text)
                .font(.title2)
                .fontWeight(.medium)
        case "p":
            Text(element.text)
                .font(.body)
        case "hr":
            Divider()
        case "br":
            Spacer()
                .frame(height: 8)
        default:
            VStack(alignment: .leading, spacing: 4) {
                ForEach(element.children, id: \.id) { child in
                    ElementView(element: child)
                }
            }
        }
    }
}

struct HTMLElement: Identifiable {
    let tag: String
    let text: String
    let children: [HTMLElement]
    let attributes: [String: String]
    let id: UUID
    let isBlock: Bool
}
