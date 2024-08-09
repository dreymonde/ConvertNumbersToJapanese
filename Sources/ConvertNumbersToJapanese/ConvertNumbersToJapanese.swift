import Foundation

// translated from
// https://github.com/Greatdane/Convert-Numbers-to-Japanese

public enum ConvertNumbersToJapanese {
    
    public enum Script: String, Hashable {
        /// 一, 二, 三
        case kanji
        
        /// いち, に, さん
        case hiragana
        
        /// ichi, ni, san
        case romaji
        
        var dict: [String: String] {
            switch self {
            case .kanji:
                return kanjiDict
            case .hiragana:
                return hiraganaDict
            case .romaji:
                return romajiDict
            }
        }
    }
    
    public static func convert(_ number: Int, script: Script) -> String? {
        guard let raw = doConvert(convertNum: number.description, requestedDict: script.dict) else {
            return nil
        }
        if script != .romaji {
            return removeSpaces(convertResult: raw)
        } else {
            return raw
        }
    }
}

let romajiDict: [String: String] = [".": "ten", "0": "zero", "1": "ichi", "2": "ni", "3": "san", "4": "yon", "5": "go", "6": "roku", "7": "nana",
                                    "8": "hachi", "9": "kyuu", "10": "juu", "100": "hyaku", "1000": "sen", "10000": "man", "100000000": "oku",
                                    "300": "sanbyaku", "600": "roppyaku", "800": "happyaku", "3000": "sanzen", "8000":"hassen", "01000": "issen"]

let kanjiDict: [String: String] = [".": "点", "0": "零", "1": "一", "2": "二", "3": "三", "4": "四", "5": "五", "6": "六", "7": "七",
                                    "8": "八", "9": "九", "10": "十", "100": "百", "1000": "千", "10000": "万", "100000000": "億",
                                    "300": "三百", "600": "六百", "800": "八百", "3000": "三千", "8000":"八千", "01000": "一千"]

let hiraganaDict: [String: String] = [".": "てん", "0": "ゼロ", "1": "いち", "2": "に", "3": "さん", "4": "よん", "5": "ご", "6": "ろく", "7": "なな",
                                    "8": "はち", "9": "きゅう", "10": "じゅう", "100": "ひゃく", "1000": "せん", "10000": "まん", "100000000": "おく",
                                    "300": "さんびゃく", "600": "ろっぴゃく", "800": "はっぴゃく", "3000": "さんぜん", "8000":"はっせん", "01000": "いっせん" ]

func lenOne(convertNum: String, requestedDict: [String: String]) -> String {
    // Returns single digit conversion, 0-9
    return requestedDict[convertNum] ?? ""
}

func lenTwo(convertNum: String, requestedDict: [String: String]) -> String {
    // Returns the conversion, when number is of length two (10-99)
    if convertNum.first == "0" { //if 0 is first, return lenOne
        return lenOne(convertNum: String(convertNum.last!), requestedDict: requestedDict)
    }
    if convertNum == "10" {
        return requestedDict["10"] ?? "" // Exception, if number is 10, simply return 10
    }
    if convertNum.first == "1" { // When first number is 1, use ten plus second number
        return (requestedDict["10"] ?? "") + " " + lenOne(convertNum: String(convertNum.last!), requestedDict: requestedDict)
    } else if convertNum.last == "0" { // If ending number is zero, give first number plus 10
        return lenOne(convertNum: String(convertNum.first!), requestedDict: requestedDict) + " " + (requestedDict["10"] ?? "")
    } else {
        let numList = convertNum.map { requestedDict[String($0)] ?? "" }
        var outputList = [numList[0], requestedDict["10"] ?? ""]
        if let secondNum = numList.last {
            outputList.append(secondNum)
        }
        return outputList.joined(separator: " ")
    }
}

func lenThree(convertNum: String, requestedDict: [String: String]) -> String {
    // Returns the conversion, when number is of length three (100-999)
    var numList: [String] = []
    switch convertNum.first {
    case "1":
        numList.append(requestedDict["100"] ?? "")
    case "3":
        numList.append(requestedDict["300"] ?? "")
    case "6":
        numList.append(requestedDict["600"] ?? "")
    case "8":
        numList.append(requestedDict["800"] ?? "")
    default:
        numList.append(requestedDict[String(convertNum.first!)] ?? "")
        numList.append(requestedDict["100"] ?? "")
    }
    let lastTwo = String(convertNum.dropFirst())
    if lastTwo != "00" || convertNum.count != 3 {
        if convertNum[convertNum.index(convertNum.startIndex, offsetBy: 1)] == "0" {
            numList.append(requestedDict[String(convertNum.last!)] ?? "")
        } else {
            numList.append(lenTwo(convertNum: lastTwo, requestedDict: requestedDict))
        }
    }
    return numList.joined(separator: " ").trimmingCharacters(in: .whitespaces)
}

func lenFour(convertNum: String, requestedDict: [String: String], standAlone: Bool) -> String {
    // Returns the conversion, when number is of length four (1000-9999)
    var numList: [String] = []
    var convertNumVar = convertNum

    // First, check for zeros (and get deal with them)
    if convertNumVar == "0000" {
        return ""
    }
    while convertNumVar.first == "0" {
        convertNumVar = String(convertNumVar.dropFirst())
    }
    switch convertNumVar.count {
    case 1:
        return lenOne(convertNum: convertNumVar, requestedDict: requestedDict)
    case 2:
        return lenTwo(convertNum: convertNumVar, requestedDict: requestedDict)
    case 3:
        return lenThree(convertNum: convertNumVar, requestedDict: requestedDict)
    default:
        if convertNumVar.first == "1" && standAlone {
            numList.append(requestedDict["1000"] ?? "")
        } else if convertNumVar.first == "1" {
            numList.append(requestedDict["01000"] ?? "")
        } else if convertNumVar.first == "3" {
            numList.append(requestedDict["3000"] ?? "")
        } else if convertNumVar.first == "8" {
            numList.append(requestedDict["8000"] ?? "")
        } else {
            numList.append(requestedDict[String(convertNumVar.first!)] ?? "")
            numList.append(requestedDict["1000"] ?? "")
        }
        
        let lastThree = String(convertNumVar.dropFirst())
        if lastThree != "000" || convertNumVar.count != 4 {
            if convertNumVar[convertNumVar.index(convertNumVar.startIndex, offsetBy: 1)] == "0" {
                numList.append(lenTwo(convertNum: String(convertNumVar.dropFirst(2)), requestedDict: requestedDict))
            } else {
                numList.append(lenThree(convertNum: lastThree, requestedDict: requestedDict))
            }
        }
        return numList.joined(separator: " ").trimmingCharacters(in: .whitespaces)
    }
}

func lenX(convertNum: String, requestedDict: [String: String]) -> String? {
    var numList: [String] = []
    let prefixLen = convertNum.count - 4
    let prefix = String(convertNum.prefix(prefixLen))
    switch prefixLen {
    case 1:
        numList.append(requestedDict[prefix] ?? "")
        numList.append(requestedDict["10000"] ?? "")
    case 2:
        numList.append(lenTwo(convertNum: prefix, requestedDict: requestedDict))
        numList.append(requestedDict["10000"] ?? "")
    case 3:
        numList.append(lenThree(convertNum: prefix, requestedDict: requestedDict))
        numList.append(requestedDict["10000"] ?? "")
    case 4:
        numList.append(lenFour(convertNum: prefix, requestedDict: requestedDict, standAlone: false))
        numList.append(requestedDict["10000"] ?? "")
    case 5:
        numList.append(requestedDict[String(prefix.first!)] ?? "")
        numList.append(requestedDict["100000000"] ?? "")
        let remaining = String(prefix.dropFirst())
        if remaining != "0000" {
            numList.append(lenFour(convertNum: remaining, requestedDict: requestedDict, standAlone: false))
            numList.append(requestedDict["10000"] ?? "")
        }
    default:
        return nil
    }
    numList.append(lenFour(convertNum: String(convertNum.suffix(4)), requestedDict: requestedDict, standAlone: false))
    return numList.joined(separator: " ").trimmingCharacters(in: .whitespaces)
}

func removeSpaces(convertResult: String) -> String {
    return convertResult.replacingOccurrences(of: " ", with: "")
}

func doConvert(convertNum: String, requestedDict: [String: String]) -> String? {
    switch convertNum.count {
    case 1:
        return lenOne(convertNum: convertNum, requestedDict: requestedDict)
    case 2:
        return lenTwo(convertNum: convertNum, requestedDict: requestedDict)
    case 3:
        return lenThree(convertNum: convertNum, requestedDict: requestedDict)
    case 4:
        return lenFour(convertNum: convertNum, requestedDict: requestedDict, standAlone: true)
    default:
        return lenX(convertNum: convertNum, requestedDict: requestedDict)
    }
}
