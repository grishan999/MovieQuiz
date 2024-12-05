//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by mac on 30.10.2024.
//
import Foundation

protocol QuestionFactoryProtocol {
    func resetQuestions()
    func requestNextQuestion()
    func loadData()
}

