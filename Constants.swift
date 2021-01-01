//
//  Constants.swift
//  Translator
//
//  Created by Zhixun Liu on 2021/1/2.
//

import Foundation

func constant__get_languages() -> [String] {
    return ["Chinese", "English", "Cantonese", "Classical Chinese", "Japanese", "Korean", "French", "Spanish", "Thai", "Arabic", "Russian", "Portuguese", "German", "Italian", "Greek", "Dutch", "Polish", "Bulgarian", "Estonian", "Danish", "Finnish", "Czech", "Romanian", "Slovenian", "Swedish", "Hungary", "Traditional Chinese"]
}

func constant__get_language_codes() -> [String] {
    return ["zh", "en", "yue", "wyw", "jp", "kor", "fra", "spa", "th", "ara", "ru", "pt", "de", "it", "el", "nl", "pl", "bul", "est", "dan", "fin", "cs", "rom", "slo", "swe", "hu", "cht", "vie"]
}

func getCurrentLanguageCode() -> String {
    return constant__get_language_codes()[UserDefaults.standard.integer(forKey: "translateInto")]
}
