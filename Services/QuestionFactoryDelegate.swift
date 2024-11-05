//
//  QuestionFactoryDelegate 2.swift
//  MovieQuiz
//
//  Created by mac on 31.10.2024.
//


protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
} 