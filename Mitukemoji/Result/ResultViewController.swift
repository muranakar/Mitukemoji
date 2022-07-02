//
//  ResultViewController.swift
//  CollectionViewSample2022-06-23
//
//  Created by 村中令 on 2022/06/30.
//

import UIKit
import GoogleMobileAds

class ResultViewController: UIViewController {
    @IBOutlet private weak var coinsObtainedInOneGameLabel: UILabel!
    @IBOutlet private weak var totalCoinsLabel: UILabel!
    @IBOutlet private weak var replayButton: UIButton!
    @IBOutlet private weak var initialSceneButton: UIButton!

    // Google広告
    @IBOutlet weak private var bannerView: GADBannerView!

    private var allButton: [UIButton] {
        [
            replayButton,
            initialSceneButton
        ]
    }
    private var totalCoin: Int
    private var oneGameGetCoin: Int
    private var gameFinishType: GameFinishType

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewCoinLabel()
        configureAdBannar()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureViewButton()
    }

    required init?(coder: NSCoder, gameFinishType: GameFinishType, oneGameGetCoin: Int) {
        self.totalCoin = CoinRepository.load() ?? 0
        self.oneGameGetCoin = oneGameGetCoin
        self.gameFinishType = gameFinishType
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction private func shareTwitter(_ sender: Any) {
        shareOnTwitter()
    }
    @IBAction private func shareLine(_ sender: Any) {
        shareOnLine()
    }
    @IBAction private func shareOtherApp(_ sender: Any) {
        shareOnOtherApp()
    }

    private func configureAdBannar() {
        // GADBannerViewのプロパティを設定
        bannerView.adUnitID = "\(GoogleAdID.bannerID)"
        bannerView.rootViewController = self
        // 広告読み込み
        bannerView.load(GADRequest())
    }

    private func shareOnTwitter() {
        // シェアするテキストを作成
        let text = "みつけもじ！同じ文字をみつけよう！"
        // swiftlint:disable:next line_length
        // TODO:: 共有文章記述必要。
        let hashTag = ""
        let completedText = text + "\n" + hashTag

        // 作成したテキストをエンコード
        let encodedText = completedText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        // エンコードしたテキストをURLに繋げ、URLを開いてツイート画面を表示させる
        if let encodedText = encodedText,
           let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") {
            UIApplication.shared.open(url)
        }
    }

    private  func shareOnLine() {
        let urlscheme: String = "https://line.me/R/share?text="
        // swiftlint:disable:next line_length
        let message = "みつけもじ！同じ文字をみつけよう！"

        // line:/msg/text/(メッセージ)
        let urlstring = urlscheme + "/" + message

        // URLエンコード
        guard let  encodedURL =
                urlstring.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
            return
        }

        // URL作成
        guard let url = URL(string: encodedURL) else {
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    //  LINEアプリ表示成功
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // LINEアプリが無い場合
            let alertController = UIAlertController(title: "エラー",
                                                    message: "LINEがインストールされていません",
                                                    preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
            present(alertController, animated: true, completion: nil)
        }
    }

    private func shareOnOtherApp() {
        let url = URL(string: "https://sites.google.com/view/muranakar")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!)
        }
    }

    // MARK: - View関係
    private func configureViewCoinLabel() {
        coinsObtainedInOneGameLabel.text = "×　\(oneGameGetCoin)"
        totalCoinsLabel.text = "×  \(totalCoin)"
    }
    private func configureViewButton() {
        allButton.forEach { button in
            button.layer.borderWidth = 3
            button.layer.borderColor = UIColor.init(named: "string")?.cgColor
            button.layer.cornerRadius = 10
            button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            button.setTitleColor(UIColor.init(named: "string"), for: .normal)
            button.setTitleColor(.gray, for: .disabled)
        }
    }
}
