//
//  GameViewController.swift
//  FindNumber
//
//  Created by Константин on 06.01.2023.
//

import UIKit

class GameViewController: UIViewController {

// MARK: - PROPERTIES
    
    lazy var game = Game(countItems: buttons.count) { [weak self] (status, time) in
        guard let self = self else { return } // эта строка разворачивает опциональный self, опционал появился из-за слабой ссылки
        self.timerLabel.text = time.secondsToString()
        self.updateInfoGame(with: status)
    } // Экземпляр класса Game создается только один раз, при повторной игре не создается
    
    @IBOutlet weak var nextDigit: UILabel!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var bestResultLabel: UILabel!
    
 // MARK: - LIFE SYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupScreen()
    }
    
    override func viewWillDisappear(_ animated: Bool) { // При уходе с экрана игры останавливаем таймер. Если этого не сделать, он продолжит считать.
        super.viewWillDisappear(animated)
        game.stopGame()
    }
    
    @IBAction func pressButton(_ sender: UIButton) { // Обрабатывает нажатие на кнопку с номером
        guard let buttonIndex = buttons.firstIndex(of: sender) else { return }
        game.check(index: buttonIndex)
        updateUI()
        //sender.isHidden = true
        //sender.layer.opacity = 0
    }
    
    private func setupScreen() { // Устанавливает первоначальную сцену игры. Вызывается один раз
        for index in game.items.indices {
            buttons[index].setTitle(game.items[index].title, for: .normal)
            buttons[index].layer.opacity = 1
        }
        nextDigit.text = game.nextItem?.title // Устанавливаю число для поиска
    }
    
    private func updateUI() { // Обновляет содержимое сцены во время игры
        for index in game.items.indices {
            if game.items[index].isFound {
                buttons[index].layer.opacity = 0
            } // Скрываем кнопку, если она найдена правильно
            else if game.items[index].isEror { // Если ошибочно нажали на неверную кнопку, она вспыхнет красным на 0.3 секунды
                UIView.animate(withDuration: 0.3, animations: { [weak self] in self?.buttons[index].backgroundColor = .red }, completion: { [weak self] (_) in self?.buttons[index].backgroundColor = .white
                    self?.game.items[index].isEror = false
                })
            }
        }
        nextDigit.text = game.nextItem?.title
        updateInfoGame(with: game.status)
    }
    
    private func updateInfoGame(with status: StatusGame) { // Проверяет статус игры и выводит сообщение
        switch status {
        case .start:
            statusLabel.text = "Игра началась!"
            statusLabel.textColor = .black
            newGameButton.isHidden = true
        case .win:
            statusLabel.text = "Вы выиграли!!!"
            statusLabel.textColor = .blue
            newGameButton.isHidden = false
            bestResultLabel.text = "Лучший результат: \(game.bestResult) с."
            if game.isNewRecord {  // Если установлен новый рекорд, то выводим alert
                showAlert()
            } else {
                showAlertActionSheet()
            }
        case .lose:
            statusLabel.text = "Увы, вы проиграли!"
            statusLabel.textColor = .red
            newGameButton.isHidden = false
            showAlertActionSheet()
        }
    }
    
    @IBAction func newGame(_ sender: UIButton) { // Обрабатывает нажатие кнопки Новая игра. Вызывается метод newGame, сама кнопка исчезает и обновляется содержимое сцены
        game.newGame()
        sender.isHidden = true
        setupScreen()
    }
    
    private func showAlert() {  // Показываем, когда пользователь выиграл и установил рекорд
        let alert = UIAlertController(title: "Поздравляем!", message: "Вы установили новый рекорд!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func showAlertActionSheet() { // Показываем, если пользователь проиграл, либо результат игры хуже рекорда
        let alert = UIAlertController(title: "Что Вы хотите сделать?", message: nil, preferredStyle: .actionSheet)
        
        let newGameAction = UIAlertAction(title: "Начать новую игру", style: .default){ [weak self] (_) in
            self?.game.newGame()
            self?.setupScreen()
        }

        let showRecord = UIAlertAction(title: "Посмотреть рекорд", style: .default){ [weak self] (_) in
            self?.performSegue(withIdentifier: "recordVC", sender: nil) // Выполнить переход в модальный вью контроллер
        }
        
        let menuAction = UIAlertAction(title: "Перейти в меню", style: .destructive) { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true) // Закрыть текущий экран
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(newGameAction)
        alert.addAction(showRecord)
        alert.addAction(menuAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
}
