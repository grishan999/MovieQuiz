//
//  GameResult.swift
//  MovieQuiz
//
//  Created by mac on 04.11.2024.
//
import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBestScore(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
