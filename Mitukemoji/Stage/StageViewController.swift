//
//  StageViewController.swift
//  CollectionViewSample2022-06-23
//
//  Created by 村中令 on 2022/06/29.
//

import UIKit

class StageViewController: UIViewController {

    @IBOutlet weak private var coinLabel: UILabel!
    @IBOutlet weak private var level1Label: UILabel!
    @IBOutlet weak private var level2Label: UILabel!
    @IBOutlet weak private var level3Label: UILabel!
    @IBOutlet weak private var level4Label: UILabel!
    @IBOutlet weak private var level5Label: UILabel!
    @IBOutlet weak private var level6Label: UILabel!
    @IBOutlet weak private var level7Label: UILabel!

    @IBOutlet weak private var level1Button: UIButton!
    @IBOutlet weak private var level2Button: UIButton!
    @IBOutlet weak private var level3Button: UIButton!
    @IBOutlet weak private var level4Button: UIButton!
    @IBOutlet weak private var level5Button: UIButton!
    @IBOutlet weak private var level6Button: UIButton!
    @IBOutlet weak private var level7Button: UIButton!

    private var allLevelLabel: [UILabel] {
        return [
            level1Label, level2Label, level3Label, level4Label
            ,level5Label, level6Label, level7Label
        ]
    }

    private var allLevelButton: [UIButton] {
        return [
            level1Button, level2Button, level3Button
            ,level4Button, level5Button, level6Button
            ,level7Button
        ]
    }
    private var levelNums = [1,2,3,4,5,6,7]
    private var dictionaryButtonAndLevelNum: [UIButton: Int] {
        [UIButton: Int](uniqueKeysWithValues: zip(allLevelButton, levelNums))
    }

    private var coin: Int
    private let questions: [Question]
    private var levelNum: Int = 0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        configureButtonIsEnabled()
        configureViewLabel()
    }

    override func viewWillLayoutSubviews() {
        convfigureViewButton()
    }


    required init?(coder: NSCoder,characterType: CharacterType) {
        self.questions = QuestionUsecase.configureQuestions(characterType: characterType)
        self.coin = CoinRepository.load() ?? 0
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @IBAction private func selectedFIMNum(sender: UIButton) {
        allLevelButton.forEach { (button: UIButton) in
            if sender === button {
                levelNum = dictionaryButtonAndLevelNum[sender]!
            }
        }
        performSegue(withIdentifier: "game", sender: sender)
    }
    private func configureViewLabel() {
        coinLabel.text = "×  \(CoinRepository.load() ?? 0) "
        var count = 0
        allLevelLabel.forEach { label in
            label.text = "×  \(questions[count].requiredCoins)"
            count += 1
        }
    }
    private func configureButtonIsEnabled() {
        let coin = CoinRepository.load() ?? 0
        var filterButtons: [UIButton] = []
        if coin < questions[0].requiredCoins {
            filterButtons = allLevelButton
        } else if coin < questions[1].requiredCoins {
            filterButtons = Array(allLevelButton[1...6])
        } else if  coin < questions[2].requiredCoins {
            filterButtons = Array(allLevelButton[2...6])
        } else if  coin < questions[3].requiredCoins {
            filterButtons = Array(allLevelButton[3...6])
        } else if  coin < questions[4].requiredCoins {
            filterButtons = Array(allLevelButton[4...6])
        } else if  coin < questions[5].requiredCoins {
            filterButtons = Array(allLevelButton[5...6])
        } else if  coin < questions[6].requiredCoins {
            filterButtons = [allLevelButton[6]]
        }
        filterButtons.forEach { button in
            button.isEnabled = false
        }
    }
    private func convfigureViewButton() {
        allLevelButton.forEach { button in
            button.layer.borderWidth = 3
            button.layer.borderColor = UIColor.init(named: "string")?.cgColor
            button.layer.cornerRadius = 10
            button.titleLabel?.font = UIFont.systemFont(ofSize: 23, weight: .bold)
            button.setTitleColor(UIColor.init(named: "string"), for: .normal)
            button.setTitleColor(.gray, for: .disabled)
        }
    }
}

private extension StageViewController {
    @IBSegueAction
    func makeGameVC(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> GameViewController? {
        return GameViewController(
            coder: coder, levelNum: levelNum,
            characterType: questions[0].characterType
        )
    }

    @IBAction
    func backToStageViewController(segue: UIStoryboardSegue) {
    }
}
