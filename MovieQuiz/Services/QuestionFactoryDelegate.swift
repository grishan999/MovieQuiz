//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by mac on 31.10.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer ()
    func didFailToLoadData (with error: Error)
}
