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
/* i tipi opzionali sostanzialmente rappresentano i tipi "nullable" di c#, cioè elementi base a cui si aggiugne il tipo null (nil) che normalmente non ci sarebbe */
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

/* Per gli optional abbiamo i segnatori ? e !. Il ? definisce la variabile come nullable e ti ritorno l'oggetto opzionale (some o none), se si usa ! si definisce
sempre opzionale ma facendo unwrapping forzato al contenuto. Se non si usa nessuno dei due si definisce la variabile non Nullabel*/
//var base = "2"
//base = nil //errore

//var baseSpecifica : String = "2"
//baseSpecifica = nil //errore

var baseOptGenerica : String? = "2"
baseOptGenerica = nil //corretto e opzionale completo

var baseOptUnwrappaing : String! = "2"
baseOptUnwrappaing = nil //corretto ma solo il valore inserito, senza l'oggetto opzionale
//baseOptUnwrappaing! //errata questa chiamata perchè in questo momento la variabile è definita "nil" e non si può usare il ! perchè nil non è un valore


