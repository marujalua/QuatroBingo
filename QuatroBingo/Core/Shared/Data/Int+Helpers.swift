//
//  Int+Helpers.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 31/05/25.
//
extension Int {
    func isPerfectSquare() -> (Int, Bool) {
        if self < 0 {
            return (self, false) // Negative numbers cannot have a real perfect square root
        }

        let sqrtValue = Double(self).squareRoot()
        return (Int(sqrtValue), sqrtValue == sqrtValue.rounded())
    }
}
