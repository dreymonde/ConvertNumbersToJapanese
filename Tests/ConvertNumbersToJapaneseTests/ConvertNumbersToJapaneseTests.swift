import XCTest
@testable import ConvertNumbersToJapanese

final class ConvertNumbersToJapaneseTests: XCTestCase {
    
    private let formatter: NumberFormatter = {
        $0.numberStyle = .spellOut
        $0.locale = Locale(identifier: "ja_JP")
        return $0
    }(NumberFormatter())
    
    private func uikitKanji(_ number: Int) -> String {
        formatter.string(from: number as NSNumber)!
    }
    
    func testKanji() throws {
        for number in 0...10000 {
            let kanji = ConvertNumbersToJapanese.convert(number, script: .kanji)
            if number != 0 {
                XCTAssertEqual(kanji!, uikitKanji(number), number.description)
            }
            print(number, kanji!)
        }
    }
    
    func testHiragana() throws {
        for number in 0...10000 {
            let kanji = ConvertNumbersToJapanese.convert(number, script: .hiragana)
            print(number, kanji!)
        }
    }
    
    func testRomaji() throws {
        for number in 0...10000 {
            let kanji = ConvertNumbersToJapanese.convert(number, script: .romaji)
            print(number, kanji!)
        }
    }
    
    func testLimits() throws {
        let underlimit = ConvertNumbersToJapanese.convert(1000000000 - 1, script: .kanji)
        print(underlimit as Any)
        XCTAssertNotNil(underlimit)
        let overlimit = ConvertNumbersToJapanese.convert(1000000000, script: .kanji)
        XCTAssertNil(overlimit)
    }
}
