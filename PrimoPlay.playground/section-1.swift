// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let veg = "red pepper"

switch veg {
    case "prova":
        let vegt="schifio"
    case if veg.hasSuffix("pepper"):
        let vegt = "ciao \(veg)"
    case let x where x.hasSuffix("pepper"):
        let vegt2 = "ciao2 \(veg)"
    default:
        let vegt = "def"
}