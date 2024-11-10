//
//  AlertModels.swift
//  MovieQuiz
//
//  Created by mac on 01.11.2024.
//
struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}
