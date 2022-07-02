//
//  ViewController.swift
//  CollectionViewSample2022-06-23
//
//  Created by 村中令 on 2022/06/23.
//
// 参考URL: https://qiita.com/sgr-ksmt/items/56b11a61a545147c3aa3

import UIKit
import GoogleMobileAds

class GameViewController: UIViewController {
    @IBOutlet private weak var coinNumLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var correctValueLabel: UILabel!

    private var columnsNum: Int
    private var levelNum: Int
    private var totalCoin: Int
    private var oneGameGetCoin: Int = 0
    private var randomValues: [String] = []
    private var correctRandomValue: String = ""
    private var characterType: CharacterType
    private var missCount: Int = 0
    private var gameFinishType: GameFinishType?
    // MARK: - タイマー関係のプロパティ
    private let time: Float = 5.0
    private var cnt: Float = 0
    private var count: Float { time - cnt }
    private var GameTimer: Timer?

    // MARK: - 広告関係のプロパティ
    @IBOutlet weak private var bannerView: GADBannerView!
    private var interstitial: GADInterstitialAd?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureAdBannar()
        configureInterstitialAd()
        missCount = 0
        oneGameGetCoin = 0
        cnt = 0
        configureRandomValueAndCorrectRandomValueAndCollectionViewReload(characterType: characterType)
        configureViewCoinLabel()
        navigationController?.setNavigationBarHidden(true, animated: true)
        GameTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(countDown(timer: )),
            userInfo: nil,
            repeats: true
        )
    }

    private func configureRandomValueAndCorrectRandomValueAndCollectionViewReload(characterType: CharacterType) {
        // powは２乗をおこなう処理
        let columnsNumPow = Int(pow(Double(columnsNum), 2))
        randomValues = Array(CsvConversion.convertFacilityInformationFromCsv(
            characterType: characterType
        ).shuffled()[0...columnsNumPow - 1])
        correctRandomValue = randomValues.randomElement()!
        correctValueLabel.text = correctRandomValue
        collectionView.reloadData()
    }

    required init?(coder: NSCoder, levelNum: Int, characterType: CharacterType) {
        self.levelNum = levelNum
        self.columnsNum = levelNum + 1
        self.totalCoin = CoinRepository.load() ?? 0
        self.characterType = characterType
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureAdBannar() {
        // GADBannerViewのプロパティを設定
        bannerView.adUnitID = "\(GoogleAdID.bannerID)"
        bannerView.rootViewController = self
        // 広告読み込み
        bannerView.load(GADRequest())
    }
    // MARK: - Timer関係
    @objc func countDown(timer: Timer) {
        // countを１減らすために、cntにpuls
        cnt += 1
        // タイマーを止める
        if count < 0 {
            GameTimer?.invalidate()
            CoinRepository.save(coinNum: totalCoin)
            gameFinishType = .timeOut
            showGoogleIntitialAdOnceInThreeTimesAndPerformSegue()
        }
    }
    // MARK: - 広告関係のメソッド
    private func configureInterstitialAd() {
        // インタースティシャル広告
        let request = GADRequest()
        GADInterstitialAd.load(
            withAdUnitID: GoogleAdID.interstitialID,
            request: request,
            completionHandler: { [self] ad, error in
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                interstitial = ad
                interstitial?.fullScreenContentDelegate = self
            }
        )
    }
    //　Google広告を３回に表示するメソッド
    func showGoogleIntitialAdOnceInThreeTimesAndPerformSegue() {
        // 広告を３回に、１回表示する処理
        let adNum = GADRepository.processAfterAddGADNumPulsOneAndSaveGADNum()
        if adNum % 3 == 0 {
            if interstitial != nil {
                interstitial?.present(fromRootViewController: self)
                performSegue(withIdentifier: "result", sender: nil)
            } else {
                performSegue(withIdentifier: "result", sender: nil)
            }
        } else {
            performSegue(withIdentifier: "result", sender: nil)
        }
    }
    // MARK: - View関係　アニメーションなど
    private func configureViewCoinLabel() {
        coinNumLabel.text = "×  \(CoinRepository.load() ?? 0)"
    }

    private func configureViewCorrectAnswerImageView() {
        let imageView = UIImageView.init(image: UIImage(systemName: "circle"))
        imageView.tintColor = .red
        imageView.backgroundColor = UIColor(named: "background")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.bottomAnchor.constraint(equalTo: bannerView.topAnchor, constant: -10.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        UIView.animate(withDuration: 2.0) {
                imageView.alpha = 0.01
        } completion: { _ in
            imageView.removeFromSuperview()
        }
    }
    private func configureViewIncorrectAnswerImageView() {
        let imageView = UIImageView.init(image: UIImage(systemName: "xmark"))
        imageView.tintColor = UIColor(named: "string")
        imageView.backgroundColor = UIColor(named: "background")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.bottomAnchor.constraint(equalTo: bannerView.topAnchor, constant: -10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        UIView.animate(withDuration: 2.0) {
                imageView.alpha = 0.01
        } completion: { _ in
            imageView.removeFromSuperview()
        }
    }
}
extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        randomValues.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell =
        collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        ) as! CollectionViewCell
        cell.configure(text: randomValues[indexPath.row])

        return cell
    }
}

private extension GameViewController {
    @IBSegueAction
    func makeResultVC(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> ResultViewController? {
        return ResultViewController(
            coder: coder, gameFinishType: gameFinishType!, oneGameGetCoin: oneGameGetCoin
        )
    }

    @IBAction
    func backToGameViewController(segue: UIStoryboardSegue) {
    }
}

extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let isCorrectValue = randomValues[indexPath.row] == correctRandomValue
        if isCorrectValue {
            // 正解したときの処理
            switch characterType {
            case .hiragana:
                totalCoin += 1 * (levelNum + 1)
                oneGameGetCoin += 1 * (levelNum + 1)
            case .katakana:
                totalCoin += 2 * (levelNum + 1)
                oneGameGetCoin += 2 * (levelNum + 1)
            case .emoji:
                totalCoin += 3 * (levelNum + 1)
                oneGameGetCoin += 3 * (levelNum + 1)
            case .kanzi:
                totalCoin += 5 * (levelNum + 1)
                oneGameGetCoin += 5 * (levelNum + 1)
            }
            CoinRepository.save(coinNum: totalCoin)
            configureRandomValueAndCorrectRandomValueAndCollectionViewReload(characterType: characterType)
            configureViewCoinLabel()
            configureViewCorrectAnswerImageView()
        } else {
            //　不正解だったときの処理
            configureViewIncorrectAnswerImageView()
            missCount += 1
            if missCount == 5 {
                GameTimer?.invalidate()
                CoinRepository.save(coinNum: totalCoin)
                gameFinishType = .missBySelection
                showGoogleIntitialAdOnceInThreeTimesAndPerformSegue()
            }
        }
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    // UICollectionViewの外周余白
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    // Cellのサイズ
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let cellSize: CGFloat = self.collectionView.bounds.width / CGFloat(columnsNum) - 2
        return CGSize(width: cellSize, height: cellSize)
    }
    // 行の最小余白
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 2
    }
    // 列の最小余白
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
}

extension GameViewController: GADFullScreenContentDelegate {
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
//        performSegue(withIdentifier: "result", sender: nil)
    }
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        performSegue(withIdentifier: "result", sender: nil)
    }
}
