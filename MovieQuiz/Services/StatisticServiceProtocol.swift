//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by mac on 04.11.2024.
//
import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get set }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
