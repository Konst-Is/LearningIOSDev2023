//
//  Game.swift
//  FindNumber
//
//  Created by Константин on 07.01.2023.
//

import Foundation

enum StatusGame { // Три статуса игры
    case start, win, lose
}

class Game {
    
    struct Item { // Структура "Карточка". Три свойства: название, отгадана/не отгадана и ошибочно нажата/или нет
        var title: String
        var isFound = false
        var isEror = false
    }
    
// MARK: - PROPERTIES
    var items: [Item] = [] // Массив карточек
    var nextItem: Item? // Число, карточку с которым нужно найти и нажать
    var isNewRecord = false
    var status: StatusGame = .start { // Обзервер отслеживает статус. Если игра окончена, вызывает stopGame(). Если пользователь выиграл, то идет проверка на рекорд.
        didSet {
            if status != .start {
                if status == .win {
                    let newRecord = timeForGame - secondsGame  // Результат игры
                    let record = UserDefaults.standard.integer(forKey: KeyUserDefaults.recordGame) // Вытаскиваем рекорд, записанный в UserDefaults. Метод вернет 0, если значения по ключу нет.
                    if record == 0 || newRecord < record { // Если результат лучше старого рекорда или предыдущего рекорда нет, то запишем его в UserDefaults.
                        UserDefaults.standard.setValue(newRecord, forKey: KeyUserDefaults.recordGame)
                        isNewRecord = true
                    }
                }
                stopGame()
            }
        }
    }
    var bestResult: Int  // Это я добавил
    
    private var countItems: Int  // Число карточек, можно менять
    private let data = Array(1...99) // Массив, из которого выбираются числа для карточек
    private var secondsGame: Int { // Оставшееся время игы, уменьшается каждую секунду
        didSet { // Обозреватель отслеживает момент, когда время игры закончится и изменяет статус, и каждую секунду он вызывает updateTimer, который обновляет информацию на экране
            if secondsGame == 0 {
                status = .lose
            }
            updateTimer(status, secondsGame)
        }
    }
    private var timer: Timer?
    private var updateTimer: ((StatusGame, Int) -> ()) // Клоужер, вызываться он будет в обзервере secondsGame
    private let timeForGame: Int // Исходное время игры, устанавливается при инициализации
// MARK: -
    init(countItems: Int, updateTimer: @escaping (_ status: StatusGame, _ seconds: Int) -> ()) {
        self.countItems = countItems
        self.timeForGame = Settings.shared.currentSettings.timeForGame // Берем время из настроек
        self.secondsGame = self.timeForGame
        self.bestResult = self.timeForGame // Это мой код
        self.updateTimer = updateTimer
        setupGame()
    }
// MARK: - METHODS
    private func setupGame() {   // Установка игры: сбрасываем рекорд, очищаем предыдущий массив карточек и создаем новый, генерируем число для поиска, обновляем начальное время игры и статус, отражаем их на экране, запускаем таймер
        isNewRecord = false
        var digits = data.shuffled()
        items.removeAll()
        while items.count < countItems {
            let item = Item(title: String(digits.removeFirst()))
            items.append(item)
        }
        nextItem = items.shuffled().first
        updateTimer(status, secondsGame)
            if Settings.shared.currentSettings.timerState { // Если таймер вкючен, то создадим его
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
            self?.secondsGame -= 1
               })
            }
    }
    
    func check(index: Int) { // Обрабатывает все ситуации в ходе игры
        guard status == .start else { return } // Если игра окончена, то проверять ничего не будет
        if items[index].title == nextItem?.title {
            items[index].isFound = true // Если правильно нажали кнопку, свойство кнопки isFound изменится и сгенерируется новое число для поиска
            nextItem = items.shuffled().first(where: { (item) -> Bool in
                item.isFound == false
            }) // выбираем новое число только из тех, что не найдены
        } else {
            items[index].isEror = true // Если нажали неверную кнопку, то изменится свойство кнопки isEror и она станет красной на время
        }
        if nextItem == nil { // Если все числа угаданы, изменяется статус игры и обзервер запустит stopGame()
            status = .win
        }
    }
    
    func stopGame () { // Останавливает таймер, правильно было бы назвать эту функцию stopTimer()
        bestResult = (timeForGame - secondsGame < bestResult) ? (timeForGame - secondsGame) : bestResult // Мой код
        timer?.invalidate()
    }
    
    func newGame() { // Вызывается только при продолжении уже загруженной игры. Изменяет статус игры на старт, устанавливает начальное время для таймера, вызывает функцию с установками игры
        status = .start
        self.secondsGame = self.timeForGame
        setupGame()
    }
    
}

extension Int { // Для конвертиции числа в секундах в формат мин:сек
    func secondsToString() -> String {
        let minutes = self / 60
        let seconds = self % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
}
