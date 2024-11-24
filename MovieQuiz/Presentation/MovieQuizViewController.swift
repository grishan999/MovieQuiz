import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - аутлеты и экшны
    //аутлеты
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticServiceProtocol?
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter()
        statisticService = StatisticService()
        
        questionFactory = QuestionFactory (moviesLoader: MoviesLoader(), delegate: self)
        
        showLoadingIndicator()
        questionFactory?.loadData()
        
        resetQuiz()
        
    }
    
    
    
    // MARK: - QuestionFactoryDelegate
    
    public func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quizStep: viewModel)
        }
    }
    
    
    // окрас рамки после ответа юзера
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.YPGreen.cgColor : UIColor.YPRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestion()
        }
    }
    
    
    
    
    // Конверт модели в отображение
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    // Показ следующего вопроса или результата
    private func showNextQuestion() {
        if currentQuestionIndex == questionsAmount - 1 {
            let text = correctAnswers == questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            
            let resultViewModel = QuizResultsViewModel(title: "Результаты", text: text, buttonText: "Начать заново")
            showQuizResult(resultViewModel) // Вызываем метод для показа результата
            
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    // Показать состояние вопроса
    private func show(quizStep step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        countLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0
        setButtonsEnabled(true)
    }
    
    // Показать результат квиза
    private func showQuizResult(_ result: QuizResultsViewModel) {
        guard let statisticService = statisticService else { return }
        // обновление статистики
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
    
        let bestGame = statisticService.bestGame
        let totalAccuracy = String(format: "%.2f", statisticService.totalAccuracy)
        let gamesCount = statisticService.gamesCount
        
        let message = """
                Ваш результат: \(correctAnswers)/\(questionsAmount)
                Количество сыгранных квизов: \(gamesCount)
                Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
                Средняя точность: \(totalAccuracy)%
                """
        
        // Модель алерта
        let alertModel = AlertModel (
            title: "Этот раунд окончен!",
            message: message,
            buttonText: "Сыграть еще раз",
            completion: { [weak self] in
                self?.resetQuiz()
            }
        )
        alertPresenter?.showAlert(on: self, with: alertModel)
    }
    
    
    // Показываем индикатор загрузки
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    //Скрываем индикатор загрузки
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    // Алерт при ошибки загрузки
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter?.showAlert(on: self, with: model)
    }
    
    public func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }

   public func didFailToLoadData(with error: Error) {
       showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
       }
    
    
    
    // MARK: -  вспомогательные методы
    // Сброс квиза
    private func resetQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.resetQuestions()
        questionFactory?.requestNextQuestion()
    }
    
    // Функция для выключения кнопок
    private func setButtonsEnabled(_ isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    //MARK: -  Экшены
    
    //батон экшн да
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        setButtonsEnabled(false)
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    
    // батон экшн нет
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        setButtonsEnabled(false)
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }
    
}


/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
