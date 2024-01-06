//
//  CustomImageView.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 22/11/2021.
//

import UIKit
import OSLog

var imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageview: UIImageView {

    private var task: URLSessionDataTask!
    private let spinner = UIActivityIndicatorView(style: .large)
    
    func loadImage(from url: URL) {
        //So that the reusable cell doesn't get the previous image.
        image = nil

        addSpiner()

        // Making sure that the task is not nil (since it's unwrapped)
        if let task = task {
            task.cancel()
        }

        if let imageFromCache = imageCache.object(forKey: url.absoluteURL as AnyObject) as? UIImage {
            self.image = imageFromCache
            removeSpinner()
            return
        }

        task = URLSession.shared.dataTask(with: url) { (data, response, error) in

            guard let data = data, let newImage = UIImage(data: data) else {
            os_log("Couldn't load image from url.")
                return
            }
            imageCache.setObject(newImage, forKey: url.absoluteURL as AnyObject)

            DispatchQueue.main.async {
                self.image = newImage
                self.removeSpinner()
            }
        }
        task.resume()
    }

    private func addSpiner() {
        addSubview(spinner)
        spinner.pin(to: self)
        spinner.startAnimating()
    }

    private func removeSpinner() {
        spinner.removeFromSuperview()
    }

}
