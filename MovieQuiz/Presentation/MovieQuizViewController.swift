//
//  MovieQuizViewController.swift
//  MovieQuiz
//
//  Created by mac on 28.10.2024.
//
import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {

    // MARK: - UI Elements
    private let indexLabel = UILabel()
    private let questionTitleLabel = UILabel()
    private let imageView = UIImageView()
    private let questionLabel = UILabel()
    private let yesButton = UIButton(type: .system)
    private let noButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - Stacks
    private let topStack = UIStackView()
    private let buttonStack = UIStackView()

    // MARK: - Dependencies
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticServiceProtocol?
    private var presenter: MovieQuizPresenter!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        alertPresenter = AlertPresenter()
        statisticService = StatisticService()
        presenter = MovieQuizPresenter(viewController: self)

        setupUI()
        activityIndicator.hidesWhenStopped = true
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor(named: "YP BackGround")
        
        setupTopStack()
        setupButtonStack()
        setupImageView()
        setupQuestionLabel()
        setupActivityIndicator()

        yesButton.addTarget(self, action: #selector(yesButtonClicked), for: .touchUpInside)
        noButton.addTarget(self, action: #selector(noButtonClicked), for: .touchUpInside)
    }

    private func setupTopStack() {
        questionTitleLabel.text = "Вопрос:"
        questionTitleLabel.font = UIFont(name: "YS Display Medium", size: 20)
        questionTitleLabel.textColor = UIColor(named: "YP White")

        indexLabel.font = UIFont(name: "YS Display Medium", size: 20)
        indexLabel.textColor = UIColor(named: "YP White")
        indexLabel.textAlignment = .right

        topStack.axis = .horizontal
        topStack.distribution = .equalSpacing
        topStack.translatesAutoresizingMaskIntoConstraints = false
        topStack.addArrangedSubview(questionTitleLabel)
        topStack.addArrangedSubview(indexLabel)

        view.addSubview(topStack)

        NSLayoutConstraint.activate([
            topStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            topStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.5)
        ])
    }

    private func setupQuestionLabel() {
        questionLabel.numberOfLines = 2
        questionLabel.textAlignment = .center
        questionLabel.font = UIFont(name: "YS Display Medium", size: 23)
        questionLabel.textColor = UIColor(named: "YP White")
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(questionLabel)

        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            questionLabel.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -20)
        ])
    }

    private func setupButtonStack() {
        yesButton.setTitle("Да", for: .normal)
        yesButton.titleLabel?.font = UIFont(name: "YS Display Medium", size: 20)
        yesButton.setTitleColor(UIColor(named: "YP Black"), for: .normal)
        yesButton.backgroundColor = UIColor(named: "YP White")
        yesButton.layer.cornerRadius = 16

        noButton.setTitle("Нет", for: .normal)
        noButton.titleLabel?.font = UIFont(name: "YS Display Medium", size: 20)
        noButton.setTitleColor(UIColor(named: "YP Black"), for: .normal)
        noButton.backgroundColor = UIColor(named: "YP White")
        noButton.layer.cornerRadius = 16

        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.addArrangedSubview(yesButton)
        buttonStack.addArrangedSubview(noButton)

        view.addSubview(buttonStack)

        NSLayoutConstraint.activate([
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStack.heightAnchor.constraint(equalToConstant: 60),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - MovieQuizViewControllerProtocol Methods
    func show(quizStep step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        indexLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0
        setButtonsEnabled(true)
    }

    func showQuizResult(_ result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title, message: presenter.makeResultsMessage(), preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Alert"
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            self?.presenter.resetQuiz()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }

    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }

    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз") { [weak self] in
            self?.presenter.resetQuiz()
        }
        alertPresenter?.showAlert(on: self, with: model)
    }

    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }

    func setButtonsEnabled(_ isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }

    // MARK: - Actions
    @objc private func yesButtonClicked() {
        setButtonsEnabled(false)
        presenter.yesButtonClicked()
    }

    @objc private func noButtonClicked() {
        setButtonsEnabled(false)
        presenter.noButtonClicked()
    }
}
