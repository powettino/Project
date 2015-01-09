// Playground - noun: a place where people can play

import UIKit

//Si possono definire dei valori di inizializzazione delle strutture e delle classi
struct Prova{
    var interna : Int
    init(){
        interna = 2
    }
}
var p = Prova();
//si possono anche definire inizializzatori un po più particolari come se fossero costruttori diversi ( anche per le struct che normalmente non viene fatto)
struct ProvaMista
{
    var uff : Int
    //Gli optional vengono sempre inizializzati anche se non esplicitamente, nel caso il valore è NIL
    var fuffa : Double?
    init(prendeIlSuoHash wow: Double){
        uff = wow.hashValue
    }
    init(faCosavuole wow: Double){
        uff = 0
    }
    //Per definire un inizializzatore privato
    init(_ k :Double){
        uff = -3
    }
}
//Si possono usare anche inizializzatori apparentemente con la stessa firma tanto poi il nome viene recuperato con anche il descrittore
var converso = ProvaMista(prendeIlSuoHash: 2.0)
var converso2 = ProvaMista(faCosavuole: 999)
var conversoPrivato = ProvaMista(6)

