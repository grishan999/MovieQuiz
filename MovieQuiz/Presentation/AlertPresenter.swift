//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by mac on 01.11.2024.
//
import UIKit

final class AlertPresenter {
    func showAlert(on viewController: UIViewController, with model: AlertModel) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: model.title,
                                          message: model.message,
                                          preferredStyle: .alert)
            alert.view.accessibilityIdentifier = "Alert"
            
            let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
                model.completion?()
            }
            action.accessibilityIdentifier = "ReplayButton"
            
            alert.addAction(action)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}

