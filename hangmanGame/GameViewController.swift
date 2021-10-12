//
//  ViewController.swift
//  hangmanGame
//
//  Created by Léa Dukaez on 12/10/2021.
//

import UIKit

class GameViewController: UIViewController {
    
    var hangmanImage: UIImageView!
    var guessWord: UILabel!
    var buttonsView: UIView!
    var buttonsContainer: [UIButton] = []
    
    var currentWord = ""
    var currentHint = ""
    var guessWordProgression: String = "?????" {
        didSet {
            guessWord.text = guessWordProgression
        }
    }
    
    var allWords = [String]()
    var remainingWords = [String]()
    var hints = [String]()
    var usedButtonsLetters = [UIButton]()
    var numberOfErr = 0 {
        didSet {
            hangmanImage.image = UIImage(named: "hangman-\(numberOfErr)")
        }
    }
    
    var selectedTheme: String?
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        hangmanImage = UIImageView()
        hangmanImage.translatesAutoresizingMaskIntoConstraints = false
        hangmanImage.image = UIImage(named: "hangman-\(numberOfErr)")
        view.addSubview(hangmanImage)
        
        guessWord = UILabel()
        guessWord.translatesAutoresizingMaskIntoConstraints = false
        guessWord.text = "?????"
        guessWord.font = UIFont.systemFont(ofSize: 30)
        view.addSubview(guessWord)
        
        buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.backgroundColor = UIColor(red: 0.60, green: 0.50, blue: 0.98, alpha: 0.50)
        buttonsView.layer.cornerRadius = 20
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            hangmanImage.heightAnchor.constraint(equalToConstant: 200),
            hangmanImage.widthAnchor.constraint(equalToConstant: 200),
            hangmanImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            hangmanImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guessWord.topAnchor.constraint(equalTo: hangmanImage.bottomAnchor),
            guessWord.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.heightAnchor.constraint(equalToConstant: 180),
            buttonsView.widthAnchor.constraint(equalToConstant: 308),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: guessWord.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        let width = 44
        let height = 44

        for row in 0..<4 {
            for col in 0..<7 {
                if (row == 3 &&  col == 0) || (row == 3 &&  col == 6) {
                    continue
                }
                let button = UIButton(type: .system)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 28)
                button.setTitle("H", for: .normal)
                
                let frame = CGRect(x: col*width, y: row*height, width: width, height: height)
                button.frame = frame
                buttonsView.addSubview(button)
                buttonsContainer.append(button)
                button.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedTheme
        navigationItem.backBarButtonItem?.title = "Thèmes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "lightbulb"), style: .plain, target: self, action: #selector(showHint))
        
        for (index, char) in "abcdefghijklmnopqrstuvwxyz".enumerated() {
            buttonsContainer[index].setTitle("\(char.uppercased())", for: .normal)
        }
        performSelector(inBackground: #selector(fetchWords), with: nil)
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else {return}
            
        if !(currentWord.contains(buttonTitle)) {
            // do not contains letter => hidde tapped letter and change hangman drawing
            numberOfErr += 1
            if numberOfErr == 9 {
                showLostMessage()
            } else {
                usedButtonsLetters.append(sender)
                sender.isEnabled = false
            }
            
        } else {
            // contains letter => hidde tapped letter and change guessWordProgression
            var newWord = ""
            
            for (index, letter) in currentWord.enumerated() {
                if String(letter) == buttonTitle {
                    newWord += String(buttonTitle)
                } else {
                    newWord += String(guessWordProgression[guessWordProgression.index(guessWordProgression.startIndex, offsetBy: index)])
                }
            }

            guessWordProgression = newWord
            sender.isEnabled = false
            
            if guessWordProgression == currentWord {
                showWonMessage()
            }
        }
    }
    
    @objc func fetchWords() {
        
        if let url = Bundle.main.url(forResource: selectedTheme, withExtension: "txt") {
            if let wordsData = try? String(contentsOf: url) {
                let lines = wordsData.components(separatedBy: "\n")
                for line in lines{
                    let lineWordHint = line.components(separatedBy: ": ")
                    allWords.append(lineWordHint[0])
                    hints.append(lineWordHint[1])
                }
    
                currentWord = allWords.randomElement()!
                if let index = allWords.firstIndex(of: currentWord) {
                    currentHint = hints[index]
                }
                remainingWords = allWords.filter { $0 != currentWord }
                
                performSelector(onMainThread: #selector(startGame), with: nil, waitUntilDone: false)
            }
        }
    }
    
    @objc func showHint() {
        let hintAlert = UIAlertController(title: "Indice", message: currentHint, preferredStyle: .alert)
        hintAlert.addAction(UIAlertAction(title: "Retour", style: .default, handler: nil))
        present(hintAlert, animated: true)
    }
    
    func showWonMessage() {
        let title = "Gagné"
        let message = "vous avez fait \(numberOfErr + 1) erreurs"
        
        alert(title: title, message: message)
    }
    
    func showLostMessage() {
        let title = "Perdu"
        let message = "le mot était \(currentWord)"
        
        alert(title: title, message: message)
    }
    
    func alert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Nouveau Mot", style: .default, handler: { [weak self] _ in
            self?.startGame()
        }))
        present(ac, animated: true)
    }
    
    @objc func startGame() {
        
        if remainingWords.isEmpty {
            currentWord = allWords.randomElement()!
            if let index = allWords.firstIndex(of: currentWord) {
                currentHint = hints[index]
            }
            remainingWords = allWords.filter { $0 != currentWord }
        } else {
            currentWord = remainingWords.randomElement()!
            if let index = allWords.firstIndex(of: currentWord) {
                currentHint = hints[index]
            }
            remainingWords = remainingWords.filter { $0 != currentWord }
        }
        
        guessWordProgression = String(repeating: "?", count: currentWord.count)
        usedButtonsLetters = [UIButton]()
        for button in buttonsContainer {
            button.isEnabled = true
        }
        numberOfErr = 0

    }
}

