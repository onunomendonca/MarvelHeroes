//
//  Image.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 19/11/2021.
//

import Foundation
import UIKit

struct Image: Codable {

    let path: String?
    let imgExtension: String?

    var url: URL? {
        get {
            if let path = self.path,
               let imgExtension = self.imgExtension,
               let url = URL(string: path + "." + imgExtension) {
                return url
            }
            return nil
        }
    }

    var urlAsString: String {
        get {
            if let path = self.path,
               let imgExtension = self.imgExtension {
                return path + "." + imgExtension
            }
            return ""
        }
    }

    enum CodingKeys: String, CodingKey {
        case path
        case imgExtension = "extension"
    }

}
