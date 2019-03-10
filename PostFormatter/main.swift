//
//  main.swift
//  PostFormatter
//
//  Created by LuLouie on 2019/3/9.
//

import Foundation


extension String {
    func filterBar() -> String {
        return replacingOccurrences(of: "-", with: " ")
            .replacingOccurrences(of: "Objective C", with: "Objective-C")
            .replacingOccurrences(of: ".md", with: "", options: .caseInsensitive, range: index(endIndex, offsetBy: -3)..<endIndex)
    }
    
    func isFormatted() -> Bool {
        return starts(with: "---")
    }
}

func header(fromTitle title: String) -> String {
    return """
---
layout: post
title: \(title)
---

"""
}

let fileManager = FileManager.default
let rootPath = fileManager.currentDirectoryPath
let enumerator = fileManager.enumerator(atPath: rootPath)

/*
 1 是否已处理
 2 修饰文件名
 3 处理
 4 保存
 */

while let fileName = enumerator?.nextObject() as? String  {
    let path = rootPath + "/" + fileName
    guard let content = try? String(contentsOfFile: path) else {
        continue
    }
    if content.isFormatted() {
        continue
    }
    
    let filteredName = fileName.filterBar()
    let formattedContent = header(fromTitle: filteredName) + content
    try? formattedContent.write(toFile: path, atomically: true, encoding: .utf8)
}

