//
//  QuestionUsecase.swift
//  CollectionViewSample2022-06-23
//
//  Created by 村中令 on 2022/06/29.
//

import Foundation

struct QuestionUsecase {
    static func configureQuestions(characterType: CharacterType) -> [Question]{
        switch characterType {
        case .hiragana:
            var level = 1
            let questions: [Question] = [0,60,150,270,420,600,810].map { requiredCoinsDouble in
                let question = Question(characterType: .hiragana, level: level, requiredCoins: Int(requiredCoinsDouble))
                level += 1
                return question
            }
            return questions
        case .katakana:

            var level = 1
            let questions: [Question] = [1050,1170,1350,1590,1890,2250,2670].map { requiredCoinsDouble in
                let question = Question(characterType: .katakana, level: level, requiredCoins: Int(requiredCoinsDouble))
                level += 1
                return question
            }
            return questions
        case .emoji:
            var level = 1
            let questions: [Question] = [3150,3330,3600,3960,4410,4950,5580].map { requiredCoinsDouble in
                let question = Question(characterType: .emoji, level: level, requiredCoins: Int(requiredCoinsDouble))
                level += 1
                return question
            }
            return questions
        case .kanzi:
            var level = 1
            let questions: [Question] = [6300,6600,7050,7650,8400,9300,10350].map { requiredCoinsDouble in
                let question = Question(characterType: .kanzi, level: level, requiredCoins: Int(requiredCoinsDouble))
                level += 1
                return question
            }
            return questions
        }
    }
}
