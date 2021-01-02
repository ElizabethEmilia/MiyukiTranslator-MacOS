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
    return ["zh", "en", "yue", "wyw", "jp", "kor", "fra", "spa", "th", "ara", "ru", "pt", "de", "it", "el", "nl", "pl", "bul", "est", "dan", "fin", "cs", "rom", "slo", "swe", "hu", "cht"]
}

func constant__get_national_flags() -> [String] {
    return ["🇨🇳","🇬🇧","🇨🇳","🇨🇳","🇯🇵","🇰🇷","🇫🇷","🇪🇸","🇹🇭","🇦🇪","🇷🇺","🇵🇹","🇩🇪","🇮🇹","🇬🇷","🇳🇱","🇵🇱","🇧🇬","🇪🇪","🇩🇰","🇫🇮","🇨🇿","🇷🇴","🇸🇮","🇨🇭","🇭🇺","🇨🇳"]
}

func getCurrentLanguageCode() -> String {
    return constant__get_language_codes()[UserDefaults.standard.integer(forKey: "translateInto")]
}

func ui_template__main_page() -> String {
    return """
<html>
<body style="font-family: Times, 'Times New Roman', 'SongTi SC'; background: rgba(255, 255, 255, 0); color: #ff6699; text-align: center; -webkit-user-select: none; cursor: default !important;">
<div style="font-size: 18px; position: absolute; height:80%; width: 100%; top: 0; left: 0; display: flex; justify-content: center; align-items: center; -webkit-user-select: none;">
    <p>MIYUKI TRANSLATOR</p>
</div>
<p style="font-size: 12px; color: #888; position: absolute; bottom: 10%; left: 0; width: 100%; -webkit-user-select: none;">BY MIYUKI, IN DECEMBER, 2020</p>
<script>document.body.setAttribute('oncontextmenu', 'event.preventDefault();');</script>
</body>
</html>
"""
}

func ui_template_display_result(backColor: String, fontColor: String, originalText: String, resultText: String) -> String {
    return """
    <html>
    <head>
        <meta charset="utf-8"/>
        <style>pre { -webkit-user-select: text !important; cursor:text; white-space: pre-wrap;  border-radius: 9px; background: rgba\(backColor); padding: 10px; font-family: Times, 'Times New Roman', 'SongTi SC'; font-size: 15px;  word-wrap:break-word;  line-height:20px; }</style>
    </head>
    <body style="font-family: Times, 'Times New Roman', 'SongTi SC'; color: #ff6699; font-size: 15px; -webkit-user-select: none; cursor: default; padding: 8px;">
        <p style="">TRANSLATED TEXT:</p>
        <pre style="color: \(fontColor)">\(resultText)</pre>
        <br/>
        <p style="">THE ORIGINAL TEXT:</p>
        <pre style="color: \(fontColor)">\(originalText)</pre>
        <script>document.body.setAttribute('oncontextmenu', 'event.preventDefault();');</script>
    </body>
    </html>
    """
}

func ui_template__process_info(backColor: String, fontColor: String, originalText: String, title: String, message: String) -> String {
    return """
    <html>
    <head>
        <meta charset="utf-8"/>
        <style>pre { -webkit-user-select: text !important; cursor:text; white-space: pre-wrap;  border-radius: 9px; background: rgba\(backColor); padding: 10px; font-family: Times, 'Times New Roman', 'SongTi SC'; font-size: 15px; line-height:20px; word-wrap:break-word; }</style>
    </head>
    <body style="font-family: Times, 'Times New Roman', 'SongTi SC'; color: #ff6699; font-size: 15px; -webkit-user-select: none; cursor: default; padding: 8px;">
        <p style="">\(title):</p>
        <pre style="color: \(fontColor)88"><i>\(message)</i></pre>
        <br/>
        <p style="">THE ORIGINAL TEXT:</p>
        <pre style="color: \(fontColor)">\(originalText)</pre>
        <script>document.body.setAttribute('oncontextmenu', 'event.preventDefault();');</script>
    </body>
    </html>
"""
}
