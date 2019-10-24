//
//  Extensions.swift
//  Feedly
//
//  Created by João Pedro Leite on 22/10/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation
import SwiftUI

extension Image {
    static func downloadImage(from url: URL,
                       completion: @escaping (UIImage) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            guard let data = data else { return }
            guard let uiImg = UIImage(data: data) else { return }
            completion(uiImg)
        }.resume()
    }
}

extension String {

    func stripOutHtml() -> String? {
        do {
            guard let data = self.data(using: .unicode) else {
                return nil
            }
            let attributed = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return attributed.string
        } catch {
            return nil
        }
    }
}

extension Date {
    
    func printAsString() -> String {
        let form = DateFormatter()
        form.dateFormat = "E, d MMM yyyy HH:mm:ss"
        return form.string(from: self)
    }
}

