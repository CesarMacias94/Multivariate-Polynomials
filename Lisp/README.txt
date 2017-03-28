is-monomial:
	prende in ingresso un'espressione e ritorna T se essa è una lista che rappresenta un monomio nella forma M(Coefficient, TotalDegree, VarsPowers), altrimenti NIL.
is-varpower:
	prende in ingresso un'espressione e ritorna T se essa è una lista nella forma (V numero_maggiore_0 simbolo), altrimenti NIL.
is-polynomial:
	prende in ingresso un'espressione e ritorna T se essa è una lista che rappresenta un polinomio nella forma POLY(Monomials), dove Monomials è una lista di monomi.
poly-monomials:
	prende in ingresso la rappresentazione di un polinomio e restituisce la lista contente i monomi.
monomial-vars-and-powers:
	prende in ingresso un monomio e restituisce la lista contente la variabili con le relative potenze.
monomial-total-degree:
	prende in ingresso un monomio e ne restituisce il grado massimo.
varpower-power:
	prende in ingresso un'espressione che rappresenta una variabile con la relativa potenza e restituisce il valore di quest'ultima.
varpower-symbol:
	prende in ingresso un'espressione che rappresenta una variabile con la relativa potenza e restituisce il simbolo di quest'ultima.
as-vps:
	prende in ingresso un'espressione composta o da un solo simbolo o da (expt variabile potenza) e la trasforma nella rappresentazione di una variabile con la relativa potenza.
	Nel caso di un solo simbolo viene genetato (V 1 variabile), nel caso di (expt variabile potenza) si otterrà (V potenza variabile).
varpowers:
	prende in ingresso un'espressione che rappresenta un monomio e restituisce le Vps contenute in tale monomio.
vars-of:
	prende in ingresso un'espressione che rappresenta un monomio e restituisce la lista ordinata delle variabili contenute in tale monomio.
vars-of-list:
	prende in ingresso la lista delle variabili con la relativa potenza sotto forma di Vps e restituisce la lista ordinata delle variabili che compaiono nella lista in input.
monomial-degree:
	prende in ingresso un'espressione che rappresenta un monomio (parsato o meno) e restituisce il grado totale.
	Caso limite: (monomial-degree nil) -> 0.
sum:
	prende in ingresso una lista di numeri e ne restituisce la somma.
monomial-coefficient:
	prende in ingresso un'espressione che rappresenta un monomio (parsato o meno) e restituisce il coefficiente.
	Caso limite: (monomial-degree NIL) -> 0, come scritto sul forum.
as-monomial:
	prende in ingresso un'espressione e ne restituisce la rappresentazione sotto forma di monomio.
	Caso limite: (as-monomial 0) -> (M 0 0 NIL)
remove-zeros:
	prende in ingresso una lista che contiene le variabili con le relative potenze sotto forma di Vps e restituisce una lista in cui sono state rimosse le variabili con potenza 0.
simply-mon:
	prende in ingresso un'espressione che rappresenta un monomio e, se quest'ultimo ha come coefficiente 0, viene rimosso.
	Si noti che la rappresentazione dello 0 come monomio è (M 0 0 NIL), mentre come polinomio (POLY NIL).
simply-vps:
	prende in ingresso una lista che contiene le variabili con le relative potenze sotto forma di Vps e restituisce una lista in cui le variabili simili vengono sommate tra di loro.
coefficients:
	prende in ingresso un'espressione che rappresenta un polinomio (parsato o meno) e restituisce la lista contente i coefficienti dei monomi contenuti nel suddetto polinomio.
	Si noti che (coefficients '(poly NIL)) restituisce (0).
variables:
	prende in ingresso un'espressione che rappresenta un polinomio (parsato o meno) e restituisce la lista contente le variabili che compaiono nel polinomio senza ripetizioni.
	Caso limite: (variables NIL) -> NIL
		(variables '(POLY NIL)) -> NIL
as-polynomial:
	prende in ingresso un'espressione e ne restituisce la rappresentazione sotto forma di polinomio.
	Caso limite: (as-polynomial NIL) -> NIL
maxdegree:
	prende in ingresso un'espressione che rappresenta un polinomio (parsato o meno) e restituisce il grado del monomio con grado totale massimo.
	Caso limite: (maxdegree 'POLY NIL) -> NIL
mindegree:
	prende in ingresso un'espressione che rappresenta un polinomio (parsato o meno) e restituisce il grado del monomio con grado totale minimo.
	Caso limite: (maxdegree 'POLY NIL) -> NIL
pprint-polynomial:
	prende in ingresso un'espressione che rappresenta un polinomio (parsato o meno) e ne stampa la rappresentazione in forma canonica.
pprint-monomial:
	prende in ingresso un'espressione che rappresenta un monomio (parsato o meno) e ne stampa la rappresentazione in forma canonica.
pprint-coeff:
	prende in ingresso un'espressione che rappresenta un monomio e ritorna 3 valori divesi a seconda del coefficient di tale monomio.
	Se il coefficient è maggiore di 1, ritorna (+ valore_coefficiente), se è uguale a 1 avrò solamente +, negli altri casi ritorna il valore del coefficiente del monomio.
pprint-vps:
	prende in ingresso la rappresentazione di una variabile con la propria potenza sotto forma di Vps e la stampa nel formato variabile ^ potenza.
flatten:
	Data una lista rimuove le parentesi innestate, come la flatten vista a lezione.
monomials:
	prende in ingresso un'espressione che rappresenta un polinomio (parsato o meno) e ne restituisce la lista ordinata dei monomi.
remove-0-pol:
	prende in ingresso una lista di monomi semplifica i singoli monomi e poi somma i monomi uguali tra loro.
flat-pol:
	prende in ingrsso una lista di monomi ed elimina tutti i monomi con coefficente 0.
same-pol:
	prende in ingresso una lista di monomi e si occupa di ordinare i monomi di grado uguale.
polyplus:
	prende in ingresso due espressioni che rappresentano due polinomi (parsati o meno) e ne restituisce la somma.
polyminus:
	prende in ingresso due espressioni che rappresentano due polinomi (parsati o meno) e ne restituisce la differenza.	
coeff-neg:
	prende in ingresso un'espressione che rappresenta un monomio e restituisce il monomio opposto.
simply:
	prende in ingresso una lista di mononomi parsati e restituisce la lista contente tali monomi sommando tra di loro quelli simili.
del:
	prende in ingresso una lista ed un'espressione e restituisce la lista in ingresso rimuovendo tutte le occorrenze dell'espressione.
polyval:
	prende in ingresso un'espressione che rappresenta un polinomio (parsato o meno) e una lista di valori numerici restituendo il valore del polinomio sostituendo alle variabili restituite da variables i valori passati in input.
calculate:
	calcola ricorsivamente il valore di ogni monomio con la lista varval data in input a polyval.
pow-val:
	prende in ingresso la lista di Vps e restituisce la lista in cui, nella i-esima posizione c'è il valore della potenza della i-esima variabile.
valore-potenze:
	prende in ingresso due liste di valori numerici in cui in potenze ho il risultato della funzione 'potenze', mentre in valori ho la lista di valori data in input a polyval.
	Tale funzione restituisce una lista in cui, in ogni posizione i, ho il valore da sostituire alla i-esima variabile nella lista restituita da variables.
potenze:
	prende in ingresso due liste contenti dei simboli di variabile in cui vps sono le variabili contenute nel polinomio, mentre variabili sono le variabili contenute nel monomio di cui voglio calcolare il valore.
	Tale funzione restituisce una lista in cui, in ogni posizione i, ho la posizione della i-esima variabile contenuta in vps che compare in variabili.
	Se una variabile di vps non compare in variabili, avrò come valore (length variabili) + 1.
mul:
	prende in ingresso due liste di valori numerici, calcola la potenza (valori ^ variabili) e moltiplica questo risultato ricorsivamente, fornendo il risultato del calcolo delle vps con i valori specificati in polyval.
index-of:
	presi in ingresso una lista ed un'espressione, restituisce la posizione dell'ultima occorrenza dell'espressione nella lista.
element-at:
	presi in ingresso una lista ed un valore numerico, restituisce l'espressione contenuta nella lista nella posizione specificata.
polytimes:
	prende in ingresso due espressioni che rappresentano due polinomi (parsati o meno) e ne restituisce il prodotto.
	Il suo compito principale è gestire i casi limite delegando poi il calcolo effettivo a multiply.
multiply:
	prende in ingresso due espressioni che rappresentano due polinomi parsati e ne restituisce il prodotto calcolando ricorsivamente il prodotto tra il secondo polinomio ed un monomio appartenente al primo polinomio.
poly*mon:
	prende in ingresso due espressioni che rappresentano rispettivamente un polinomio ed un monomio entrambi parsati e ne restituisce il prodotto.
mon*mon:
	prende in ingresso due espressioni che rappresentano due monomi parsati e ne restituisce il prodotto.