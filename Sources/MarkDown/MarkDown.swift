//
//  MarkDown.swift
//  MarkDown
//
//  Created by Bernardo Breder on 29/01/17.
//
//

import Foundation

#if SWIFT_PACKAGE
    import Regex
#endif

public class MarkDown {
    
    let array: [MarkDownNode]
    
    let linkRegex = Regex("\\[(.*)\\]\\((.*)\\)", groupCount: 2)
    
    public init(string: String) {
        let lines: [String] = string.components(separatedBy: "\n")
//            .map({ (l: String) -> String in l.trimmingCharacters(in: .whitespaces) })
//            .filter({ (l: String) -> Bool in l.characters.count > 0 })
        var array: [MarkDownNode] = []
        var i = 0; while i < lines.count {
            var line = lines[i]
            if line.hasPrefix("######") {
                let text = line.substring(from: line.index(line.startIndex, offsetBy: 6)).trimmingCharacters(in: .whitespaces)
                array.append(MarkDownH6(text: text))
            } else if line.hasPrefix("#####") {
                let text = line.substring(from: line.index(line.startIndex, offsetBy: 5)).trimmingCharacters(in: .whitespaces)
                array.append(MarkDownH5(text: text))
            } else if line.hasPrefix("####") {
                let text = line.substring(from: line.index(line.startIndex, offsetBy: 4)).trimmingCharacters(in: .whitespaces)
                array.append(MarkDownH4(text: text))
            } else if line.hasPrefix("###") {
                let text = line.substring(from: line.index(line.startIndex, offsetBy: 3)).trimmingCharacters(in: .whitespaces)
                array.append(MarkDownH3(text: text))
            } else if line.hasPrefix("##") {
                let text = line.substring(from: line.index(line.startIndex, offsetBy: 2)).trimmingCharacters(in: .whitespaces)
                array.append(MarkDownH2(text: text))
            } else if line.hasPrefix("#") {
                let text = line.substring(from: line.index(line.startIndex, offsetBy: 1)).trimmingCharacters(in: .whitespaces)
                array.append(MarkDownH1(text: text))
            } else if line.hasPrefix(">") {
                let text = line.substring(from: line.index(line.startIndex, offsetBy: 1)).trimmingCharacters(in: .whitespaces)
                array.append(MarkDownBlockquote(text: text))
            } else if line.hasPrefix("1.") {
                let text = line.substring(from: line.index(line.startIndex, offsetBy: 2)).trimmingCharacters(in: .whitespaces)
                array.append(MarkDownOrderedList(text: text))
            } else if line.hasPrefix("* [ ]") {
                let text = line.substring(from: line.index(line.startIndex, offsetBy: 5)).trimmingCharacters(in: .whitespaces)
                array.append(MarkDownTaskList(text: text, flag: false))
            } else if line.hasPrefix("* [x]") {
                let text = line.substring(from: line.index(line.startIndex, offsetBy: 5)).trimmingCharacters(in: .whitespaces)
                array.append(MarkDownTaskList(text: text, flag: true))
            } else if line.hasPrefix("*") {
                let text = line.substring(from: line.index(line.startIndex, offsetBy: 1)).trimmingCharacters(in: .whitespaces)
                array.append(MarkDownUnorderedList(text: text))
            } else if line.hasPrefix("```") {
                var string = ""; i += 1;
                if i < lines.count {
                    line = lines[i]
                    while !line.hasPrefix("```") {
                        string += line + "\n"
                        i += 1
                        guard i < lines.count else { break }
                        line = lines[i]
                    }
                    array.append(MarkDownCode(text: string.trimmingCharacters(in: .newlines)))
                }
            } else if !line.isEmpty {
                array.append(MarkDownParagraph(text: line.trimmingCharacters(in: .whitespaces)))
            }
            i += 1
        }
        self.array = array
    }
    
    public func htmlText(string: String) -> String {
        guard let _ = string.characters.index(of: "[") else { return string }
        var text = string
        while let matches = linkRegex.matches(text), let range = text.range(of: matches[0]) {
            text.replaceSubrange(range, with: "<a href=\"\(matches[1])\">\(matches[2])</a>")
        }
        return text
    }
    
    public func swiftText(string: String) -> String {
        return string.replacingOccurrences(of: "\n", with: "\\n").replacingOccurrences(of: "\"", with: "\\\"")
    }
    
    public func html() -> [String] {
        return array.map({ n in n.html(markdown: self) })
    }
    
    public func swift() -> [String] {
        return array.map({ n in n.swift(markdown: self) })
    }
    
}

public protocol MarkDownNode {
    
    var type: MarkDownNodeType { get }
    
    func html(markdown: MarkDown) -> String
    
    func swift(markdown: MarkDown) -> String
    
}

public enum MarkDownNodeType {
    case h1
    case h2
    case h3
    case h4
    case h5
    case h6
    case paragraph
    case blockquote
    case ordered
    case unordered
    case task
    case code
}

public struct MarkDownH1: MarkDownNode {
    
    public let text: String
    
    public let type: MarkDownNodeType = .h1
    
    public func html(markdown: MarkDown) -> String { return "<h1>\(markdown.htmlText(string: text))</h1>" }
    
    public func swift(markdown: MarkDown) -> String { return "writePageHeader(title: \"\(markdown.swiftText(string: markdown.htmlText(string: text)))\")" }
    
}

public struct MarkDownH2: MarkDownNode {
    
    public let text: String
    
    public let type: MarkDownNodeType = .h2
    
    public func html(markdown: MarkDown) -> String { return "<h2>\(markdown.htmlText(string: text))</h2>" }
    
    public func swift(markdown: MarkDown) -> String { return "writeHeader(title: \"\(markdown.swiftText(string: markdown.htmlText(string: text)))\", level: 2)" }
    
}

public struct MarkDownH3: MarkDownNode {
    
    public let text: String
    
    public let type: MarkDownNodeType = .h3
    
    public func html(markdown: MarkDown) -> String { return "<h3>\(markdown.htmlText(string: text))</h3>" }
    
    public func swift(markdown: MarkDown) -> String { return "writeHeader(title: \"\(markdown.swiftText(string: markdown.htmlText(string: text)))\", level: 3)" }
    
}

public struct MarkDownH4: MarkDownNode {
    
    public let text: String
    
    public let type: MarkDownNodeType = .h4
    
    public func html(markdown: MarkDown) -> String { return "<h4>\(markdown.htmlText(string: text))</h4>" }
    
    public func swift(markdown: MarkDown) -> String { return "writeHeader(title: \"\(markdown.swiftText(string: markdown.htmlText(string: text)))\", level: 4)" }
    
}

public struct MarkDownH5: MarkDownNode {
    
    public let text: String
    
    public let type: MarkDownNodeType = .h5
    
    public func html(markdown: MarkDown) -> String { return "<h5>\(markdown.htmlText(string: text))</h5>" }
    
    public func swift(markdown: MarkDown) -> String { return "writeHeader(title: \"\(markdown.swiftText(string: markdown.htmlText(string: text)))\", level: 5)" }
    
}

public struct MarkDownH6: MarkDownNode {
    
    public let text: String
    
    public let type: MarkDownNodeType = .h6
    
    public func html(markdown: MarkDown) -> String { return "<h6>\(markdown.htmlText(string: text))</h6>" }
    
    public func swift(markdown: MarkDown) -> String { return "writeHeader(title: \"\(markdown.swiftText(string: markdown.htmlText(string: text)))\", level: 6)" }
    
}

public struct MarkDownParagraph: MarkDownNode {
    
    public let text: String
    
    public let type: MarkDownNodeType = .paragraph
    
    public func html(markdown: MarkDown) -> String { return "<p>\(markdown.htmlText(string: text))</p>" }
    
    public func swift(markdown: MarkDown) -> String { return "writeParagraph(text: \"\(markdown.swiftText(string: markdown.htmlText(string: text)))\")" }
    
}

public struct MarkDownBlockquote: MarkDownNode {
    
    public let text: String
    
    public let type: MarkDownNodeType = .blockquote
    
    public func html(markdown: MarkDown) -> String { return "<blockquote>\(markdown.htmlText(string: text))</blockquote>" }
    
    public func swift(markdown: MarkDown) -> String { return "writeParagraphBlockquote(text: \"\(markdown.swiftText(string: markdown.htmlText(string: text)))\")" }
    
}

public struct MarkDownOrderedList: MarkDownNode {
    
    public let text: String
    
    public let type: MarkDownNodeType = .ordered
    
    public func html(markdown: MarkDown) -> String { return "<oli>\(markdown.htmlText(string: text))</oli>" }
    
    public func swift(markdown: MarkDown) -> String { return "writeParagraph(text: \"\(markdown.swiftText(string: markdown.htmlText(string: text)))\")" }
    
}

public struct MarkDownUnorderedList: MarkDownNode {
    
    public let text: String
    
    public let type: MarkDownNodeType = .unordered
    
    public func html(markdown: MarkDown) -> String { return "<uli>\(markdown.htmlText(string: text))</uli>" }
    
    public func swift(markdown: MarkDown) -> String { return "writeParagraph(text: \"\(markdown.swiftText(string: markdown.htmlText(string: text)))\")" }
    
}

public struct MarkDownTaskList: MarkDownNode {
    
    public let text: String
    
    public let flag: Bool
    
    public let type: MarkDownNodeType = .task
    
    public func html(markdown: MarkDown) -> String { return "<task value=\"\(flag)\">\(markdown.htmlText(string: text))</task>" }
    
    public func swift(markdown: MarkDown) -> String { return "writeParagraph(text: \"\(markdown.swiftText(string: markdown.htmlText(string: text)))\")" }
    
}

public struct MarkDownCode: MarkDownNode {
    
    public let text: String
    
    public let type: MarkDownNodeType = .code
    
    public func html(markdown: MarkDown) -> String { return "<pre>\(text)</pre>" }
    
    public func swift(markdown: MarkDown) -> String {
        return "writeCode(text: \"\(markdown.swiftText(string: markdown.htmlText(string: text)))\")"
    }
    
}

