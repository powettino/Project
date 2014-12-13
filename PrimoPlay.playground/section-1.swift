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


/* Si possono assegnare tuple a oggetti che definiscono la struttura interna cosi da poter definire nuove variabili direttamente dai singoli elementi */
var miatupla = (10,20)
var (primo, secondo) = miatupla

/* Si possono anche definire tuple in cui si identifica solo uno dei campi interni, si possono assegnare nomi ai singoli elementi della tupla */
var tuplamista = (codice: 404, desc: "errore", nulla:500)
var (coderr, _ , _ ) = tuplamista
var err = tuplamista.1
var var2 = coderr

/* il toint fa il casta  optional che poi si può controllare se è diverso da nil. Questa pratica èp sconsigliata, in realta si dovrebbe fare qualcosa con il let e il costrutto*/
let miacostante = "1"
var mionumeroOpt = miacostante.toInt()
var mionumeroInt = mionumeroOpt!
if mionumeroOpt != nil{
    var secondonumero = mionumeroOpt!
}
/*versione con il costrutto */
let mia2 = "12"
let mionumOpt = mia2.toInt()
if let f = mionumOpt {
    f
}