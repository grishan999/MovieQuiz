//
//  AlertModels.swift
//  MovieQuiz
//
//  Created by mac on 01.11.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}
