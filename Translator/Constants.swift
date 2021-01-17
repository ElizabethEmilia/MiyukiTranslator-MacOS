//
//  Constants.swift
//  Translator
//
//  Created by Zhixun Liu on 2021/1/2.
//

import Foundation

func constant__get_languages() -> [String] {
    let lang = ["Chinese", "English", "Cantonese", "Classical Chinese", "Japanese", "Korean", "French", "Spanish", "Thai", "Arabic", "Russian", "Portuguese", "German", "Italian", "Greek", "Dutch", "Polish", "Bulgarian", "Estonian", "Danish", "Finnish", "Czech", "Romanian", "Slovenian", "Swedish", "Hungary", "Traditional Chinese"]
    return lang.map{ NSLocalizedString($0, comment: "") }
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

func ui_template__dictionary_result(htmlString: String, backColor: String, fontColor: String) -> String {
    return """
        <html>
        <head>
            <meta charset="utf-8"/>
            <style>div.m { -webkit-user-select: text !important; cursor:text; border-radius: 9px; background: rgba\(backColor); padding: 10px; font-family: Times, 'Times New Roman', 'SongTi SC'; font-size: 15px;  word-wrap:break-word;  line-height:20px; }
                hr { border: none; border-top: 1px solid #88888830; }
        </style>
        </head>
        <body style="font-family: Times, 'Times New Roman', 'SongTi SC'; color: #ff6699; font-size: 15px; -webkit-user-select: none; cursor: default; padding: 8px;">
            <textarea name="ot" id="ot" style="display: none;">\(htmlString)</textarea>
            <script>
                var parser = new DOMParser();
                var doc = parser.parseFromString(document.querySelector("#ot").innerHTML.replace(/\\&gt;/g, ">").replace(/\\&lt;/g, "<"),"text/html");
                var word = doc.querySelector(".k").innerHTML;
                var pron = doc.querySelector(".p").innerHTML;
                var meaning = doc.querySelector("#e").innerHTML.split("<br>").map((e) => e.replace(/^\\w+\\./, r => "<span style='width: 40px; display: inline-block; color: #888'><em>" + r + "</em></span>"));
                var sentenses = doc.querySelector("#s").innerHTML.split("<br>")
                                    .map(e => e.replace(/\\<i\\>(\\d+)\\<\\/i\\>\\.\\s/g, ""))
                                    .filter(e => e != "");
                console.log(sentenses)
                sentenses = Array(parseInt(sentenses.length / 2)).fill(0)
                                    .map((_,i) => ({'en': sentenses[i*2], 'cn': sentenses[i*2+1]}));
            </script>
            
            <div class="m" style="color: \(fontColor); padding: 20px 10px 20px 10px">
                <span style="color: ff6699; font-size: 25px; font-weight: bold; margin-right: 15px;">
                    <script>document.write(word);</script>
                </span>
                <span style="color: #888; display: inline-block"><script>document.write(pron);</script></span><br>
                <p></p>
                    <script> document.write(meaning.map((e, i)=>`<span> ${e}</span><br>`).join('')); </script>
                    <hr>
                    <script>
                        document.write(sentenses.map((e, i)=>`
                            <span><span>${e.en}</span>\n
                            <span style="color: #888">${e.cn}</span></span><br/>`
                        ).join(''));
                    </script>
            </div>
            <br/>
            <script>document.body.setAttribute('oncontextmenu', 'event.preventDefault();');</script>
        </body>
    </html>
"""
}

let KEY_APP_ID = "AppID"
let KEY_APP_KEY = "AppKey"
let KEY_TRANSLATE_INTO = "translateInto"
let KEY_WHEN_MEET_CHINESE_CHARACTER = "whenMeetChineseCharacter"
let KEY_TOP_MOST = "topMost"
let KEY_SHOW_ON_EVERY_DESKTOP = "everyDesktop"
let KEY_LOOKUP_DICT = "lookupDict"

