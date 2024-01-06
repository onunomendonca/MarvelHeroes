//
//  GError.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 04/01/2022.
//

import Foundation

enum GError:String, Error {

    case invalidCharacter = "This Character doesn't exist"
    case cantGetCharacters = "Cannot get more characters."
    case invalidURL = "The provided URL is not valid."
    case unableToComplete = "Could not complete your request."
    case invalidData = "The data received is not valid."
    case invalidResponse = "The responde is invalid."
    case noData = "No data was received."
}
