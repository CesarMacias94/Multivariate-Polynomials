is_monomial:
	prende in ingresso un'espressione e ritorna TRUE se essa è una lista che rappresenta un monomio nella forma M(Coefficient, TotalDegree, VarsPowers), altrimenti FALSE.

is_varpower:
	prende in ingresso un'espressione e ritorna TRUE se essa è una lista nella forma V(numero_maggiore_0, simbolo), altrimenti FALSE.

is_polynomial:
	prende in ingresso un'espressione e ritorna TRUE se essa è una lista che rappresenta un polinomio nella forma POLY(Monomials), dove Monomials è una lista di monomi.

as_monomial:
	prende in ingresso un'espressione e ne restituisce la rappresentazione sotto forma di monomio.

simply_var:
	prende in ingresso una lista di variabili con le relative potenze sotto formadi Vps e somma quelle simili.

get_inf:
	prende in ingresso una variabile con la relativa potenza (se essa è uguale a 1 la si può omettere) e restituisce separatamente variabile e relativa potenza.

remove_vps:
	prende in ingresso una lista di variabili con le relative potenze sotto forma di Vps e ne rimuove quelle con potenza uguale a 0.

varsPowers:
	prende in ingresso un'espressione che rappresenta un monomio da parsare e ne restituisce la lista delle variabili (Vps).

grado:
	prende in ingresso un'espressione che rappresenta un monomio da parsare e ne restituisce il grado totale.
	
coefficiente:
	prende in ingresso un'espressione che rappresenta un monomio da parsare e ne restituisce il coefficiente.

as_polynomial:
	prende in ingresso un'espressione e ne restituisce la rappresentazione sotto forma di polinomio.
	Caso limite: as_polynomial([], R) -> R = [].
	Caso limite: as_polynomial(2, R) -> R = poly([m(2, 0, [])]).

set_coeff:
	prende in ingresso un coefficiente ed il relativo monomio restituendo l'opposto di quest'ultimo.
	Si noti che tale predicato viene utilizzato nel parsing dei polinomi quando viene trovata una differenza tra due monomi.

monomials:
	prende in ingresso un'espressione che rappresenta un polinomio (parsato o meno) e ne restituisce la lista ordinata delle variabili.

same_pol:
	prende in ingresso una lista di monomi parsati ed effettua l'ordinamento nel caso in cui ci fossero 2+ monomi simili
	
ord:
	prende in ingresso la lista delle variabili di un monomio e ne effettua l'ordinamento.

remove:
	prende in ingresso la lista di monomi, ne rimuove quelli con coefficiente 0 e la restituisce.

coefficients:
	prende in ingresso un'espressione che rappresenta un polinomio (parsato o meno) e restituisce la lista contente i coefficienti dei monomi contenuti nel suddetto polinomio.
	Si noti che coefficients(poly([]), R) -> R = [].

variables:
	prende in ingresso un'espressione che rappresenta un polinomio (parsato o meno) e restituisce la lista contente le variabili che compaiono nel polinomio senza ripetizioni.
	Caso limite: variables(0, R) -> R = [].
	Caso limite: variables(poly([]), R) -> R = [].
	
extract:
	prende in ingresso una lista di variabili con le relative potenze sotto forma di Vps e restituisce la lista contente le variabili.

polyval2:
	svolge la stessa funzione di polyval, riceve in input anche la lista delle variabili del polinomio necessarie per il predicato find.

polyval:
	prende in ingresso un'espressione che rappresenta un polinomio (parsato o meno) e una lista di valori numerici restituendo il valore del polinomio sostituendo alle variabili restituite da variables i valori passati in input.

find:
	prende in ingresso la lista delle Vps del monomio che considero, la lista delle Vps dell'intero polinomio e la lista VariableValues contente i valori da attribuire alle variabili.
	Tale predicato ha lo scopo di restituire la lista delle varibili effettivamente presenti nel monomio che considero.

polymon:
	prende in ingresso un monomio parsato e la lista dei valori da attribuire alle variabili e ne calcola il valore.

pprint_polynomial:
	prende in ingresso un'espressione che rappresenta un polinomio (parsato o meno) e ne stampa la rappresentazione in forma canonica.

print_monomial:
	prende in ingresso un'espressione che rappresenta un monomio parsato e ne stampa la rappresentazione in forma canonica.

pprint_variables:
	prende in ingresso la rappresentazione di una variabile con la propria potenza sotto forma di Vps e la stampa nel formato variabile ^ potenza.

maxdegree:
	prende in ingresso un'espressione che rappresenta un polinomio (parsato o meno) e restituisce il grado del monomio con grado totale massimo.

mindegree:
	prende in ingresso un'espressione che rappresenta un polinomio (parsato o meno) e restituisce il grado del monomio con grado totale minimo.

polyminus:
	prende in ingresso due espressioni che rappresentano due polinomi (parsati o meno) e ne restituisce la differenza.

simply_pol:
	prende in ingresso un'espressione che rappresenta un polinomio parsato e ne effettua la sottrazioe/addizione semplificandolo.

vps:
	prende in ingresso un'espressione che rappresenta un monomio parsato e ne restituisce la lista Vps.
	
coeff:
	prende in ingresso un'espressione che rappresenta un monomio parsato e ne restituisce il coefficiente.
	
td:
	prende in ingresso un'espressione che rappresenta un monomio parsato e ne restituisce il grado totale.

polyplus:
	prende in ingresso due espressioni che rappresentano due polinomi (parsati o meno) e ne restituisce la somma.

polytimes:
	prende in ingresso due espressioni che rappresentano due polinomi (parsati o meno) e ne restituisce il prodotto.
	Il suo compito principale è gestire i casi limite delegando poi il calcolo effettivo a moltiply.
	
moltiply:
	prende in ingresso due espressioni che rappresentano due polinomi parsati e ne restituisce il prodotto.