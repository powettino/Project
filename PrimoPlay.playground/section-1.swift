// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let veg = "red pepper"

switch veg {
    case "prova":
        let vegt="schifio"
    case let x where x.hasSuffix("pepper"):
        let vegt2 = "ciao2 \(veg)"
    default:
        let vegt = "def"
}

/*i valori devono essere castati allo stesso tipo altrimenti da errore
Volendo potremmo scriverci una funzione + che fa overload e prende due valori eterogenei*/
var three = 3
var digits = 0.123456
var  pi = Double(three) + digits
var pi2 = three + Int(digits)


