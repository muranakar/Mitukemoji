//
//  StartViewController.swift
//  CollectionViewSample2022-06-23
//
//  Created by 村中令 on 2022/06/29.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var hiraganaButton: UIButton!
    @IBOutlet weak var katakanaButton: UIButton!
    @IBOutlet weak var emojiButton: UIButton!
    @IBOutlet weak var randomButton: UIButton!
    private var allButton: [UIButton] {
        [
            hiraganaButton,
            katakanaButton,
            emojiButton,
            randomButton
        ]
    }

    private var characterType: CharacterType = .hiragana

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureButtonIsEnabled()
        configureViewCoinLabel()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillLayoutSubviews() {
        convfigureViewButton()
    }

    @IBAction func hiraganaAction(_ sender: Any) {
        characterType = .hiragana
        performSegue(withIdentifier: "stage", sender: sender)
    }
    @IBAction func katakanaAction(_ sender: Any) {
        characterType = .katakana
        performSegue(withIdentifier: "stage", sender: sender)
    }
    @IBAction func emojiAction(_ sender: Any) {
        characterType = .emoji
        performSegue(withIdentifier: "stage", sender: sender)
    }
    @IBAction func kanziAction(_ sender: Any) {
        characterType = .kanzi
        performSegue(withIdentifier: "stage", sender: sender)
    }

    private func convfigureViewButton() {
        allButton.forEach { button in
            button.layer.borderWidth = 3
            button.layer.borderColor = UIColor.init(named: "string")?.cgColor
            button.layer.cornerRadius = 10
            button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            button.setTitleColor(UIColor.init(named: "string"), for: .normal)
            button.setTitleColor(.gray, for: .disabled)
        }
    }
    private func configureButtonIsEnabled() {
        let coin = CoinRepository.load() ?? 0
        if coin < 1050 {
            randomButton.isEnabled = false
            emojiButton.isEnabled = false
            katakanaButton.isEnabled = false
        } else if coin < 3150 {
            randomButton.isEnabled = false
            emojiButton.isEnabled = false
        } else if  coin < 6300 {
            randomButton.isEnabled = false
        }
    }
    private func configureViewCoinLabel() {
        coinLabel.text = "×　\(CoinRepository.load() ?? 0)"
    }
}


private extension StartViewController {
    @IBSegueAction
    func makeGameVC(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> StageViewController? {
        return StageViewController(
            coder: coder,
            characterType: characterType
        )
    }

    @IBAction
    func backToStartViewController(segue: UIStoryboardSegue) {
    }
}
