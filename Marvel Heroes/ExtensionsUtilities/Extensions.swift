//
//  Extensions.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 17/11/2021.
//

import CommonCrypto
import Foundation
import UIKit

extension UIView {
    
    //Pins the view to all superViews' edges.
    func pin(to superView: UIView){
        //view’s autoresizing mask is translated into Auto Layout constraints.
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }

    func pinToSafe(of superView: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.trailingAnchor).isActive = true

    }
}

extension UIViewController {
    func setTitle(_ title: String, withImageView imageView: CustomImageview) {
        let titleLbl = UILabel()
        titleLbl.text = title
        titleLbl.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        imageView.heightAnchor.constraint(equalToConstant: CGFloat(44)).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        let titleView = UIStackView(arrangedSubviews: [imageView, titleLbl])
        titleView.axis = .horizontal
        titleView.spacing = 10.0
        navigationItem.titleView = titleView
    }
}

extension String {
    var md5Value: String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)

        if let d = self.data(using: .utf8) {
            _ = d.withUnsafeBytes { body -> String in
                CC_MD5(body.baseAddress, CC_LONG(d.count), &digest)

                return ""
            }
        }

        return (0 ..< length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
}
