# ConvertNumbersToJapanese

**Convert numbers to Japanese text in multiple writing systems**

Translated from [Greatdane/Convert-Numbers-to-Japanese](https://github.com/Greatdane/Convert-Numbers-to-Japanese)

<a href="https://u24.gov.ua">
  <img src="https://raw.githubusercontent.com/dreymonde/Timers/main/Media/donate.png" height="70">
</a>

---

**ConvertNumbersToJapanese** is a lightweight Swift package that provides an easy way to convert numbers into Japanese text, supporting multiple writing systems including Kanji, Hiragana, and Romaji.

```swift
import ConvertNumbersToJapanese

// Convert to Kanji (漢字)
ConvertNumbersToJapanese.convert(42, script: .kanji)  // Returns: "四十二"

// Convert to Hiragana (ひらがな)
ConvertNumbersToJapanese.convert(42, script: .hiragana)  // Returns: "よんじゅうに"

// Convert to Romaji
ConvertNumbersToJapanese.convert(42, script: .romaji)  // Returns: "yon juu ni"
```

## Features

- [x] Convert numbers to three different writing systems:
  - Kanji (漢字): 一, 二, 三
  - Hiragana (ひらがな): いち, に, さん
  - Romaji: ichi, ni, san
- [x] Support for numbers from 0 to 999,999,999
- [x] Handles special reading cases (e.g., 300 → さんびゃく)
- [x] Clean, type-safe API using enums
- [x] Zero external dependencies

> [!IMPORTANT]
> Help save Ukraine. [Donate via United24](https://u24.gov.ua), the official fundraising platform by the President of Ukraine

<a href="https://u24.gov.ua">
  <img src="https://raw.githubusercontent.com/dreymonde/Timers/main/Media/united24.jpg" width="75%" height="75%">
</a>

## Installation

### Swift Package Manager
1. Click File → Swift Packages → Add Package Dependency
2. Enter the repository URL
3. Import `ConvertNumbersToJapanese` in your source files

## Usage Guide

### Basic Usage

```swift
import ConvertNumbersToJapanese

// Basic number conversion
let number = 123

// Convert to different scripts
let kanji = ConvertNumbersToJapanese.convert(number, script: .kanji)     // 百二十三
let hiragana = ConvertNumbersToJapanese.convert(number, script: .hiragana) // ひゃくにじゅうさん
let romaji = ConvertNumbersToJapanese.convert(number, script: .romaji)    // hyaku ni juu san
```

### Supported Number Ranges

The converter supports numbers from 0 to 999,999,999:

```swift
// Zero
ConvertNumbersToJapanese.convert(0, script: .kanji) // 零

// Large numbers
ConvertNumbersToJapanese.convert(10000, script: .kanji) // 一万
ConvertNumbersToJapanese.convert(100000000, script: .kanji) // 一億
```

## Implementation Details

- For Romaji output, words are space-separated for readability
- Kanji and Hiragana outputs are concatenated without spaces, following Japanese writing conventions
- Returns `nil` for numbers outside the supported range or invalid inputs

> [!NOTE]
> This package is designed to handle standard Japanese number readings. For specialized contexts (e.g., traditional readings, formal counting), you may need to modify the conversion dictionaries.

## Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.
