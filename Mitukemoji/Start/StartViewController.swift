//
//  StartViewController.swift
//  CollectionViewSample2022-06-23
//
//  Created by 村中令 on 2022/06/29.
//

import UIKit
import GoogleMobileAds

class StartViewController: UIViewController {
    @IBOutlet weak private var coinLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var hiraganaButton: UIButton!
    @IBOutlet weak private var katakanaButton: UIButton!
    @IBOutlet weak private var emojiButton: UIButton!
    @IBOutlet weak private var randomButton: UIButton!
    @IBOutlet weak private var bannerView: GADBannerView!
    // 追加したUIViewを接続
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
        configureAdBannar()
        configureButtonIsEnabled()
        configureViewCoinLabel()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureViewButton()
        configureViewDescriptionLabel()
    }

    @IBAction private func hiraganaAction(_ sender: Any) {
        characterType = .hiragana
        performSegue(withIdentifier: "stage", sender: sender)
    }
    @IBAction private func katakanaAction(_ sender: Any) {
        characterType = .katakana
        performSegue(withIdentifier: "stage", sender: sender)
    }
    @IBAction private func emojiAction(_ sender: Any) {
        characterType = .emoji
        performSegue(withIdentifier: "stage", sender: sender)
    }
    @IBAction private func kanziAction(_ sender: Any) {
        characterType = .kanzi
        performSegue(withIdentifier: "stage", sender: sender)
    }

    private func configureAdBannar() {
        // GADBannerViewのプロパティを設定
        bannerView.adUnitID = "\(GoogleAdID.bannerID)"
        bannerView.rootViewController = self
        // 広告読み込み
        bannerView.load(GADRequest())
    }

    private func configureViewDescriptionLabel() {
        descriptionLabel.layer.cornerRadius = 20
        descriptionLabel.layer.borderWidth = 2
        descriptionLabel.layer.borderColor = UIColor(named: "stackViewBackground")?.cgColor
        descriptionLabel.layer.backgroundColor = UIColor(named: "stackViewBackground")?.cgColor
    }

    private func configureViewButton() {
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
