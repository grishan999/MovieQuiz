//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by mac on 28.10.2024.
//

import Foundation

public class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    private var currentQuestionIndex = 0
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func setup(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    func resetQuestions() {
        currentQuestionIndex = 0
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else {
                return }
            
            
            do {
                let imageData = try Data(contentsOf: movie.imageURL)
                
                let rating = Float(movie.rating) ?? 0
                let text = "Рейтинг этого фильма больше чем 7?"
                let correctAnswer = rating > 7
                
                let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didReceiveNextQuestion(question: question)
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
}

//let questions: [QuizQuestion] = [
//       QuizQuestion (
//           image: "The Godfather",
//           text: "Рейтинг этого фильма больше чем 6?",
//           correctAnswer: true
//       ),
//       QuizQuestion (
//           image: "The Dark Knight",
//           text: "Рейтинг этого фильма больше чем 6?",
//           correctAnswer: true
//       ),
//       QuizQuestion (
//           image: "Kill Bill",
//           text: "Рейтинг этого фильма больше чем 6?",
//           correctAnswer: true
//       ),
//       QuizQuestion (
//           image: "The Avengers",
//           text: "Рейтинг этого фильма больше чем 6?",
//           correctAnswer: true
//       ),
//       QuizQuestion (
//           image: "Deadpool",
//           text: "Рейтинг этого фильма больше чем 6?",
//           correctAnswer: true
//       ),
//       QuizQuestion (
//           image: "The Green Knight",
//           text: "Рейтинг этого фильма больше чем 6?",
//           correctAnswer: true
//       ),
//       QuizQuestion (
//           image: "Old",
//           text: "Рейтинг этого фильма больше чем 6?",
//           correctAnswer: false
//       ),
//       QuizQuestion (
//           image: "The Ice Age Adventures of Buck Wild",
//           text: "Рейтинг этого фильма больше чем 6?",
//           correctAnswer: false
//       ),
//       QuizQuestion (
//           image: "Tesla",
//           text: "Рейтинг этого фильма больше чем 6?",
//           correctAnswer: false
//       ),
//       QuizQuestion (
//           image: "Vivarium",
//           text: "Рейтинг этого фильма больше чем 6?",
//           correctAnswer: false
//       )
//   ]
