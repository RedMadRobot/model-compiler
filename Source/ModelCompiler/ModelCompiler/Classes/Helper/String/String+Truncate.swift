//
//  String+Truncate.swift
//  ModelCompiler
//
//  Created by Egor Taflanidi on 30.03.16.
//  Copyright © 2016 RedMadRobot LLC. All rights reserved.
//

import Foundation

// MARK: - Обрезка строк
public extension String {
    
    /**
     Удаляет символы вплоть до слова **word**.
     По умолчанию слово **word** остаётся в строке.
     
     - parameter word: слово, до которого нужно удалить символы;
     - parameter includeWord: нужно ли удалять само слово **word**?
     
     - returns: Возвращает строку, обрезанную вплоть до слова **word**. Если слова в
     строке нет -- возвращается сама строка.
     */
    public func truncateAllBeforeWord(_ word: String, deleteWord: Bool = false) -> String {
        guard let wordRange: Range<String.Index> = range(of: word)
        else {
            return self
        }
        
        return deleteWord ? substring(from: wordRange.upperBound) : substring(from: wordRange.lowerBound)
    }
    
    /**
     Удалить символы после слова **word**.
     По умолчанию символы удаляются вместе со словом **word**.
     
     - parameter word: слово, после которого нужно удалить символы;
     - parameter includeWord: нужно ли удалять само слово **word**?
     
     - returns: Возвращает строку, обрезанную после слова **word**. Если слова в строке нет
     -- возвращает саму строку.
     */
    public func truncateFromWord(_ word: String, deleteWord: Bool = true) -> String {
        guard let wordRange: Range<String.Index> = range(of: word)
        else {
            return self
        }
        
        return deleteWord ? substring(to: wordRange.lowerBound) : substring(to: wordRange.upperBound)
    }
    
    /**
     Последнее слово из строки.
     Последнее слово -- это всё, что идёт после последнего пробела или последнего переноса каретки.
     
     - returns: Возвращает последнее слово из строки.
     */
    public func lastWord() -> String {
        if contains(" ") {
            return truncateAllBeforeWord(" ", deleteWord: true).lastWord()
        }
        
        if contains("\n") {
            return truncateAllBeforeWord("\n", deleteWord: true).lastWord()
        }
        
        return self
    }
    
    /**
     Первое слово из строки.
     Первое слово -- это всё, что идёт до первого пробела или первого переноса каретки.
     
     - returns: Возвращает первое слово из строки.
     */
    public func firstWord(
        sentenceDividers: [String] = ["\n", " ", ".", ",", ";", ":"]
    ) -> String {
        for divider in sentenceDividers {
            if contains(divider) {
                return truncateFromWord(divider).firstWord(sentenceDividers: sentenceDividers)
            }
        }
        
        return self
    }
    
    public func enumerateWords(_ enumerator: @escaping (_ word: String) -> ()) {
        self.enumerateLines { (line: String, stop: inout Bool) in
            var mutableLine: String = line.trimmingCharacters(in: CharacterSet.whitespaces)
            
            while mutableLine.contains("  ") {
                mutableLine = mutableLine.replacingOccurrences(of: "  ", with: " ")
            }
            
            while !mutableLine.isEmpty {
                enumerator(mutableLine.firstWord())
                if mutableLine.contains(" ") {
                    mutableLine = mutableLine.truncateAllBeforeWord(" ", deleteWord: true)
                } else {
                    break
                }
            }
            
            enumerator("\n")
        }
    }
    
    /**
     Обрезать пробелы и переносы в начале строки.
     
     - returns: Возвращает строку без пробелов и переносов в начале.
     */
    public func truncateLeadingWhitespace() -> String {
        if hasPrefix(" ") {
            return substring(from: characters.index(startIndex, offsetBy: 1)).truncateLeadingWhitespace()
        }
        
        if hasPrefix("\n") {
            return substring(from: characters.index(startIndex, offsetBy: 1)).truncateLeadingWhitespace()
        }
        
        return self
    }
    
    public func truncateToWordFromBehind(_ word: String, deleteWord: Bool = true) -> String {
        let drow: String = String(word.characters.reversed())
        let fles: String = String(self.characters.reversed())
        
        let cut: String = fles.truncateAllBeforeWord(drow, deleteWord: deleteWord)
        return String(cut.characters.reversed())
    }
    
    public func truncateUntilWord(_ word: String) -> String {
        let drow: String = String(word.characters.reversed())
        let fles: String = String(self.characters.reversed())
        
        let cut: String = fles.truncateFromWord(drow, deleteWord: false)
        return String(cut.characters.reversed())
    }
    
}
