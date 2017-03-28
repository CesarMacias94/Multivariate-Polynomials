%%Predicati is_
is_monomial(m(C, TD, VPs)) :-
	integer(C),
	integer(TD),
	TD >= 0,
	is_list(VPs).

is_varpower(v(Power, VarSymbol)) :-
	integer(Power),
	Power >= 0,
	atom(VarSymbol).

is_polynomial(poly(Monomials)) :-
	is_list(Monomials),
	foreach(member(M, Monomials), is_monomial(M)).

%%Parsa i monomi
as_monomial(0 * _, m(0, 0, [])) :-
	!.

as_monomial(Parte2 * Parte1, m(Coefficiente, Grado, V)) :-
	varsPowers(Parte2, Lista_VarsPower2),
	get_inf(Parte1, B, E),
	sort(2,@=<,[v(E, B) | Lista_VarsPower2],X),
	coefficiente(Parte2, Coefficiente),
	Coefficiente \= 0,
	simply_var(X, Vps),
	remove_vps(Vps, V),
	grado(Parte2, Gt2),
	grado(Parte1, Gt1),
	Grado is Gt2 + Gt1,
	!.

as_monomial(Parte2 * _, m(0, 0, [])) :-
	coefficiente(Parte2, Coefficiente),
	Coefficiente = 0,
	!.

%%Casi Base as_monomial
as_monomial(Let1 * Let2, m(C, 0,[])) :-
	integer(Let1),
	integer(Let2),
	C is Let1 * Let2,
	!.

as_monomial(Let1 ^ Let2, m(C, 0,[])) :-
	integer(Let1),
	integer(Let2),
	C is Let1 ^ Let2,
	!.

as_monomial(- Let1, m(C, 2,[v(1, Let1)])) :-
	atom(Let1),
	coefficiente(Let1, Coefficiente),
	C is Coefficiente * (-1),
	!.

as_monomial(- Let1 * Let2, m(C, 2,[v(1, Let1), v(1, Let2)])) :-
	atom(Let1),
	atom(Let2),
	coefficiente(Let1, Coefficiente),
	C is Coefficiente * (-1),
	!.

as_monomial(Let1 * Let2, m(Coefficiente, 2,[v(1, Let1), v(1, Let2)])) :-
	atom(Let1),
	atom(Let2),
	coefficiente(Let1, Coefficiente),
	!.

as_monomial(VarSymbol ^ Power, m(1, Power, [V])) :-
	V = v(Power, VarSymbol),
	is_varpower(V),
	Power \=0,
	!.

as_monomial(- VarSymbol ^ Power, m(-1, Power, [V])) :-
	V = v(Power, VarSymbol),
	is_varpower(V),
	Power \=0,
	!.

as_monomial(- VarSymbol ^ Power, m(-1, 0, [])) :-
	atom(VarSymbol),
	Power = 0,
	!.

as_monomial(VarSymbol ^ Power, m(1, 0, [])) :-
	atom(VarSymbol),
	Power = 0,
	!.

as_monomial(UnaLettera, m(1, 1, [v(1, UnaLettera)])) :-
	atom(UnaLettera),
	!.

as_monomial(-Coefficiente, m(C, 0, [])) :-
	number(Coefficiente),
	C is Coefficiente * (-1),
	!.

as_monomial(Coefficiente, m(Coefficiente, 0, [])) :-
	number(Coefficiente),
	!.

%%Somma le variabili uguali
simply_var([v(P1, X), v(P2, X) | Rest], Vps) :-
	P is P1+P2,
	!,
	simply_var([v(P, X) | Rest], Vps).

simply_var([X | Tail], [X | Out]):-
        simply_var(Tail, Out),
	!.

simply_var([], []).

%%get_info estrae base e esponente usato per accodare le variabili
get_inf(Base, Base, 1) :-
	atom(Base),
	!.

get_inf(B ^ E, B, E) :-
	!.

%%rimuove le variabili con esponente 0
remove_vps([v(0, _) | Y], Z) :-
	remove_vps(Y, Z),
	!.

remove_vps([v(E, P) | Y], Z) :-
	E \= 0,
	remove_vps(Y, K),
	append([v(E, P)], K, Z),
	!.

remove_vps([], []) :-
	!.

%%Genera la lista delle variabili
varsPowers(Parte2 * Parte1, X) :-
	not(number(Parte1)),
	!,
	get_inf(Parte1, Ba, Ex),
	!,
	varsPowers(Parte2, Vp),
	sort(2, @=<, [v(Ex, Ba) | Vp], X),
	!.

%%Casi Base varsPowers
varsPowers(UnaLettera, [v(1, UnaLettera)]) :-
	atom(UnaLettera),
	!.

varsPowers(- UnaLettera, [v(1, UnaLettera)]) :-
	atom(UnaLettera),
	!.

varsPowers(C1 * C2, []) :-
	number(C1),
	number(C2),
	!.

varsPowers(- C1 * C2, []) :-
	number(C1),
	number(C2),
	!.

varsPowers(Coefficiente, []) :-
	number(Coefficiente),
	!.

varsPowers(- Coefficiente, []) :-
	number(Coefficiente),
	!.

varsPowers(Coefficiente * Lettera, [v(1, Lettera)]) :-
	number(Coefficiente),
	atom(Lettera),
	!.

varsPowers(- Coefficiente * Lettera, [v(1, Lettera)]) :-
	number(Coefficiente),
	atom(Lettera),
	!.

varsPowers(Coefficiente * Lettera_pot, ListaPotenze) :-
	number(Coefficiente),
	varsPowers(Lettera_pot, ListaPotenze),
	!.

varsPowers(- Coefficiente * Lettera_pot, ListaPotenze) :-
	number(Coefficiente),
	varsPowers(Lettera_pot, ListaPotenze),
	!.

varsPowers(Lettera^Numero, [v(Numero, Lettera)]) :-
	!.

varsPowers(- Lettera^Numero, [v(Numero, Lettera)]) :-
	!.

%%Calcola il grado dei monomi
grado(X*Y, GradoTot) :-
	grado(X, Grado),
	grado(Y, Number),
	GradoTot is Grado + Number,
	!.

%%Casi base grado
grado(_^Y, Y) :-
	Y >= 0,
	!.

grado(- _^Y, Y) :-
	Y >= 0,
	!.

grado(X, 0) :-
	number(X),
	!.

grado(- X, 0) :-
	number(X),
	!.

grado(X, 1) :-
	atom(X),
	!.

grado(- X, 1) :-
	atom(X),
	!.

%%Calcola il coefficiente
coefficiente(Monomio * Rest, Coefficiente) :-
	not(number(Rest)),
	coefficiente(Monomio, Coefficiente),
	!.

%%Casi base coefficente
coefficiente(C1 * C2, C) :-
	number(C1),
	number(C2),
	C is C1 * C2,
	!.

coefficiente(- C1 * C2, Coef) :-
	number(C1),
	number(C2),
	C is C1 * C2,
	Coef is C * (-1),
	!.

coefficiente(_^_, 1) :-
	!.

coefficiente(- _^_, -1) :-
	!.

coefficiente(Monomio, 1) :-
	atom(Monomio),
	!.

coefficiente(- Monomio, -1) :-
	atom(Monomio),
	!.

coefficiente(Monomio, Monomio) :-
	number(Monomio),
	!.

coefficiente(- Monomio, M) :-
	number(Monomio),
	M is Monomio * (-1),
	!.

%%Parsa i polinonomi
as_polynomial(Parte2 + Parte1, poly(M)) :-
	as_monomial(Parte1, X),
	!,
	as_polynomial(Parte2, poly(Y)),
	monomials(poly([X | Y]), Monomials),
        monomials(poly(Monomials), M),
	!.

as_polynomial(Parte2 - Parte1, poly(M)) :-
	coefficiente(Parte1, C),
	set_coeff(C, Parte1, X),
	!,
	as_polynomial(Parte2, poly(Y)),
	monomials(poly([X | Y]), Monomials),
	monomials(poly(Monomials), M),
	!.

%%Casi base as_polynomials
as_polynomial(0, poly([])) :-
	!.

as_polynomial(Monomial, poly([X])) :-
	as_monomial(Monomial, X),
	!.

as_polynomial([], []) :-
	!.

%%Trasforma in negativi i coefficenti dei monomi preceduti da '-'
set_coeff(C, M, m(Z, TD, Vps)) :-
	grado(M, TD),
	varsPowers(M, Vps),
	Z is C * (-1),
	!.

%%Estrae la lista gia' ordinata dei polinomi, usato per l'accodamento
monomials(Expression, C) :-
	not(is_polynomial(Expression)),
	as_polynomial(Expression, Poly),
	monomials(Poly, C),
	!.

monomials(m(C, TD, Vps), M) :-
	monomials(poly([m(C, TD, Vps)]), M),
	!.

monomials(poly(M), Res) :-
	is_polynomial(poly(M)),
	sort(2,@=<, M, X),
	ord(X, Y),
	simply_pol(poly(Y), poly(J)),
	remove(J, K),
	same_pol(K, Res),
	!.

%%ordina i monomi di grado uguale
same_pol([X, Y | Tail], [X | Res]) :-
	td(X, TD1),
	td(Y, TD2),
	TD1 \= TD2,
	append([Y], Tail, Z),
	same_pol(Z, Res),
	!.

same_pol([X, Y | Tail], [X | Res]) :-
	vps(X, Vp1),
	vps(Y, Vp2),
	length(Vp1, L1),
	length(Vp2, L2),
	L1 > L2,
	td(X, TD),
	td(Y, TD),
	append([Y], Tail, Z),
	same_pol(Z, Res),
	!.

same_pol([X, Y | Tail], [Head | Res]) :-
	vps(X, Vp1),
	vps(Y, Vp2),
	length(Vp1, L1),
	length(Vp2, L2),
	L1 = L2,
	td(X, TD),
	td(Y, TD),
	append([X], [Y], List),
	sort(3,@=<, List, [Head | Rest]),
	append([Rest, Tail], Z),
	same_pol(Z, Res),
	!.

same_pol([X, Y | Tail], [Y | Res]) :-
	vps(X, Vp1),
	vps(Y, Vp2),
	length(Vp1, L1),
	length(Vp2, L2),
	L1 < L2,
	td(X, TD),
	td(Y, TD),
	append([X], Tail, Z),
	same_pol(Z, Res),
	!.

same_pol([X], [X]) :-
	is_monomial(X),
	!.

same_pol([], []) :-
	!.

%%ordina le var dei monomi, non ordinati come quelli di polytimes
ord([X | Tail], [Z | Y]):-
	vps(X, Vp),
	td(X, TD),
	coeff(X, C),
	sort(2,@=<,Vp,V),
	Z = m(C, TD, V),
	ord(Tail, Y),
	!.
ord([X], [Z]) :-
	vps(X, Vp),
	td(X, TD),
	coeff(X, C),
	sort(2,@=<,Vp,V),
	Z = m(C, TD, V),
	!.

ord([], []) :-
	!.

%%rimuovi i monomi con coefficiente 0
remove([X | Y], Z) :-
	coeff(X, C),
	C = 0,
	remove(Y, Z),
	!.

remove([X | Y], Z) :-
	coeff(X, C),
	C \= 0,
	remove(Y, K),
	append([X], K, Z),
	!.

remove([], []) :-
	!.

%%Restituisce la lista dei coefficienti di un polinomio
coefficients(Expression, C) :-
	not(is_polynomial(Expression)),
	as_polynomial(Expression, Poly),
	coefficients(Poly, C),
	!.

coefficients(m(C, TD, Vps), Coef) :-
	coefficients(poly([m(C, TD, Vps)]), Coef),
	!.

coefficients(poly([M | Mz]), [C | Cs]) :-
	is_polynomial(poly([M|Mz])),
	!,
	M = m(C, _, _),
	coefficients(poly(Mz), Cs),
	!.

%%Casi base coefficients
coefficients(poly(M), [C]) :-
	is_monomial(M),
	M = m(C, _, _),
	!.

coefficients(poly([]), []) :-
	!.

coefficients(0, 0) :-
	!.

%%Restituisce la lista delle variabili di un polinomio
variables(Expression, Variables) :-
	not(is_polynomial(Expression)),
	as_polynomial(Expression, Poly),
	variables(Poly, Variables),
	!.

variables(m(C, TD, Vps), Variables) :-
	variables(poly([m(C, TD, Vps)]), Variables),
	!.

variables(poly([M | Mz]), Variables) :-
	is_polynomial(poly([M|Mz])),
	!,
	M = m(_, _, Vp),
	extract(Vp, V),
	variables(poly(Mz), Vps),
	append(V, Vps, Var),
	list_to_set(Var, Var1),
	sort(Var1, Variables),
	!.

%%Casi base variables
variables(poly(M), [V]) :-
	is_monomial(M),
	M = m(_, _, Vp),
	extract(Vp, V),
	!.

variables(poly([]), []) :-
	!.

variables(0, []) :-
	!.

%%Restituisce la lista delle variabili di un monomio
extract([Vp | Vps], [V | Vs]) :-
	is_varpower(Vp),
	Vp \= [],
	Vp = v(_, V),
	extract(Vps, Vs),
	!.

%%Casi base extract
extract(Vp, V) :-
	is_varpower(Vp),
	Vp = v(_, V),
	!.

extract([], []) :-
	!.

%%Uguale a poly polyval,
%%Pero' ha in piu' le variabili del polinomio necessarie a find
polyval2(poly([M | Mz]),V, L, Vt) :-
	is_monomial(M),
	M = m(_, _, Vp),
	find(Vp, V, L, F1),
	polymon(M, F1, Vt1),
	polyval2(poly(Mz), V, L, Vt2),
	Vt is Vt1 + Vt2,
	!.

polyval2(poly([]), _, _, 0) :-
	!.

%%Calcola la funzione in quel punto
%%L contiene i valori delle variabili nell' ordine restituito da variables
polyval(Expression, L, Vtot) :-
	not(is_polynomial(Expression)),
	as_polynomial(Expression, poly(Poly)),
	remove(Poly, P),
	polyval(poly(P), L, Vtot),
	!.

polyval(m(C, TD, Vps), L, V) :-
	polyval(poly([m(C, TD, Vps)]), L, V),
	!.

polyval(poly(Mon), L, Vtot) :-
	variables(poly(Mon), V),
	length(L, L1),
	length(V, L2),
	L1 = L2,
	polyval2(poly(Mon), V, L, Vtot),
	!.

%%Casi base polyval
polyval(poly([M]), Lv, Pm) :-
	is_monomial(M),
	is_list(Lv),
	polymon(M, Lv, Pm),
	!.

polyval(poly([]), _, 0) :-
	!.

polyval([], [], []) :-
	!.

polyval(0, _, 0) :-
	!.

%%find trova le variabili effettivamente presenti nel monomio
find([v(_, X) | Vpz], [V | Vz], [_ | Lz], F) :-
	V \= X,
	find([v(_, X)], Vz, Lz, F1),
	find(Vpz, Vz, Lz, F2),
	append(F1, F2, F),
	!.

find([v(_, X) | Vpz], [V | Vz], [L | Lz], [L | F2]) :-
	V = X,
	find(Vpz, Vz, Lz, F2),
	!.

%%Casi Base find
find([v(_, X)], [V], L, [L]) :-
	atom(V),
	V = X,
	!.

find([v(_, X)], [V], _, []) :-
	atom(V),
	V \= X,
	!.

find([], _, _, []) :-
	!.

%%Calcola il valore di un monomio
polymon(m(C, _, [V | Vs]), [L | Lv], V1 * V2) :-
	polymon(m(C, _, [V]), L, V1),
	polymon(m(1, _, Vs), Lv, V2),
	!.

%%Casi base polymon
polymon(m(C, X, [v(X, _)]), L, C * V) :-
	V is L ^ X,
	!.

polymon(m(C, 0, []), [], [C]) :-
	number(C),
	!.

polymon([], [], []) :-
	!.

%%Estraggo la lista di monomi, per poterla stampare
pprint_polynomial(Expression) :-
	not(is_polynomial(Expression)),
	as_polynomial(Expression, Poly),
	pprint_polynomial(Poly),
	!.

pprint_polynomial(m(C, TD, Vps)) :-
	pprint_polynomial(poly([m(C, TD, Vps)])),
	!.

pprint_polynomial(poly(M)) :-
	foreach(member(Mon, M), is_monomial(Mon)),
	print_polynomial(M),
	nl,
	!.

%%Caso base print_polynomial
print_polynomial([]) :-
	nl,
	!.

%%Stampo la lista dei monomi
print_polynomial(ListaMonomi) :-
	arg(1, ListaMonomi, Monomio),
	is_monomial(Monomio),
	print_monomial(Monomio),
	arg(2, ListaMonomi, M),
	print_polynomial(M),
	!.

%%Ho dovuto spezzare i due casi
%%Perche' l'interprete non stampa i segni, gli attacca agli altri elementi

%%Caso con coefficiente positivo
print_monomial(m(Coefficiente, _, Vps)) :-
	Coefficiente > 0,
	!,
	write(' + '),
	write(Coefficiente),
	print_variables(Vps),
	!.

%%Caso con coefficiente negativo
print_monomial(m(Coefficiente, _, Vps)) :-
	Coefficiente < 0,
	CoefficienteP is -Coefficiente,
	!,
	write(' - '),
	write(CoefficienteP),
	print_variables(Vps),
	!.

%%Stampa la lista delle variabili aggiungendo un '*' tra una e l'altra
print_variables([Variabile | ListaVariabili]) :-
	is_varpower(Variabile),
	write(' * '),
	print_variables(Variabile),
	print_variables(ListaVariabili),
	!.

%%Casi Base print_variables
print_variables(v(Power, VarSymbol)) :-
	Power > 1,
	write(VarSymbol^Power),
	!.

print_variables(v(1, VarSymbol)) :-
	write(VarSymbol),
	!.

print_variables([]) :-
	!.

%%Restituisce il grado massimo del polinomio
maxdegree(Expression, TD) :-
	not(is_polynomial(Expression)),
	as_polynomial(Expression, Poly),
	maxdegree(Poly, TD),
	!.

maxdegree(m(_, TD, _), TD) :-
	!.

maxdegree(poly([M | Mz]), TD) :-
	is_polynomial(poly([M|Mz])),
	Mz \= [],
	maxdegree(poly(Mz), TD),
	!.

maxdegree(poly([M | m(C, TD, Vps)]), TD) :-
	is_polynomial(poly([M|m(C, TD, Vps)])),
	!.

%%Casi base maxdegree
maxdegree(poly([m(C, TD, Vps)]), TD) :-
	is_monomial(m(C, TD, Vps)),
	!.

maxdegree(poly([]), 0) :-
	!.

maxdegree(0, 0) :-
	!.

%%Restituisce il grado minimo del polinomio
mindegree(Expression, TD) :-
	not(is_polynomial(Expression)),
	as_polynomial(Expression, Poly),
	mindegree(Poly, TD),
	!.

mindegree(m(_, TD, _), TD) :-
	!.

mindegree(poly([m(C, TD, Vps) | Mz]), TD) :-
	is_polynomial(poly([m(C, TD, Vps)|Mz])),
	!.

%%Casi base mindegree
mindegree(poly([m(C, TD, Vps)]), TD) :-
	is_monomial(m(C, TD, Vps)),
	!.

mindegree(poly([]), 0) :-
	!.

mindegree(0, 0) :-
	!.

%%Restituisce la differenza tra due polinomi
polyminus(Expression1, Expression2, X) :-
	not(is_polynomial(Expression1)),
	not(is_polynomial(Expression2)),
	as_polynomial(Expression1, Poly1),
	as_polynomial(Expression2, Poly2),
	polyminus(Poly1, Poly2, X),
	!.

polyminus(poly(P1), poly(P2), poly(Z)) :-
	P1 \= [],
	polyminus(poly([]), poly(P2), poly(P3)),
	append(P1, P3, P),
	monomials(poly(P), Po),
	simply_pol(poly(Po), poly(Z)),
	!.

polyminus(m(C, TD, Vps), poly(Y), poly(Z)) :-
	polyminus(poly([m(C, TD, Vps)]), poly(Y), poly(Z)),
	!.

polyminus(poly(X), m(C, TD, Vps), poly(Z)) :-
	polyminus(poly(X), poly([m(C, TD, Vps)]), poly(Z)),
	!.

polyminus(m(C1, TD1, Vp1), m(C2, TD2, Vp2), poly(X)) :-
	polyminus(poly([m(C1, TD1, Vp1)]), poly([m(C2, TD2, Vp2)]), poly(X)),
	!.

%%Casi base polyminus
polyminus(poly(X), poly(X), poly([])) :-
	is_polynomial(poly(X)),
	!.

polyminus(poly([]), poly([m(C, TD, Vps) | Xs]), poly(P)) :-
	is_polynomial(poly([m(C, TD, Vps)|Xs])),
	C1 is C * (-1),
	polyminus(poly([]), poly(Xs), poly(P2)),
	append([m(C1, TD, Vps)], P2, P),
	!.

polyminus(poly(X), poly([]), poly(X)) :-
	is_polynomial(poly(X)),
	!.

polyminus(poly([]), poly([]), poly([])) :-
	!.

%%simply_pol effettua sottrazione e addizione dei polinomi semplificandoli
simply_pol(poly([X, Y | Xs]), poly(P)) :-
	X = m(C1, TD, Vps),
	Y = m(C2, TD, Vps),
	C is C1 + C2,
        C \= 0,
	simply_pol(poly([m(C, TD, Vps)|Xs]), poly(P)),
	!.

simply_pol(poly([X, Y | Tail]), poly(P)) :-
	X = m(C1, TD, Vps),
	Y = m(C2, TD, Vps),
	C is C1 + C2,
	C = 0,
	simply_pol(poly(Tail), poly(P)),
	!.

simply_pol(poly([X, Y | Xs]), poly([m(C1, TD1, Vps1)|P])) :-
	X = m(C1, TD1, Vps1),
	Y = m(C2, TD2, Vps2),
	Vps1 \= Vps2,
	simply_pol(poly([m(C2, TD2, Vps2) | Xs]), poly(P)),
	!.

%%Casi base simply_pol
simply_pol(poly([X]), poly([Z])) :-
	is_monomial(X),
	coeff(X, C),
	vps(X, Vps),
	simply_var(Vps, Vp),
	td(X, TD),
	C \= 0,
	Z = m(C, TD, Vp),
	!.

simply_pol(poly([X]), poly([])) :-
	is_monomial(X),
	coeff(X, C),
	C = 0,
	!.

simply_pol(poly([]), poly([])) :-
	!.

simply_pol(poly([m(C1, TD, Vps1) | Tail]), poly([m(C, TD, Vps1)])) :-
	Tail = [m(C2, TD, Vps2)],
	Vps1 = Vps2,
	C is C1 + C2,
	C \= 0,
	!.

simply_pol(poly([m(C1, TD, Vps1) | Tail]), poly([])) :-
	Tail = [m(C2, TD, Vps2)],
	Vps1 = Vps2,
	C is C1 + C2,
	C = 0,
	!.

simply_pol(poly([X | Y]), poly([X | Y])) :-
	is_monomial(X),
	is_monomial(Y),
	vps(X, Vps1),
	vps(Y, Vps2),
	Vps1 \= Vps2,
	!.

%%estrae vps dai monomi
vps(m(_, _, Vps), Vps) :-
	!.

vps([], []) :-
	!.

%%estrae il coefficiente dai monomi
coeff(m(C, _, _), C) :-
	!.

coeff([], []) :-
	!.

%%estrae il TD dai monomi
td(m(_, TD, _), TD) :-
	!.

td([], []) :-
	!.


%%Restituisce la somma tra due polinomi
polyplus(Expression1, Expression2, X) :-
	not(is_polynomial(Expression1)),
	not(is_polynomial(Expression2)),
	as_polynomial(Expression1, Poly1),
	as_polynomial(Expression2, Poly2),
	polyplus(Poly1, Poly2, X),
	!.

polyplus(poly(P1), poly(P2), poly(Z)) :-
	P1 \= [],
	append(P1, P2, P),
	monomials(poly(P), Po),
	simply_pol(poly(Po), poly(Z)),
	!.

polyplus(m(C, TD, Vps), poly(Y), poly(Z)) :-
	polyplus(poly([m(C, TD, Vps)]), poly(Y), poly(Z)),
	!.

polyplus(poly(X), m(C, TD, Vps), poly(Z)) :-
	polyplus(poly(X), poly([m(C, TD, Vps)]), poly(Z)),
	!.

polyplus(m(C1, TD1, Vp1), m(C2, TD2, Vp2), poly(Z)) :-
	polyplus(poly([m(C1, TD1, Vp1)]), poly([m(C2, TD2, Vp2)]), poly(Z)),
	!.

%%Casi base polyplus
polyplus(poly([]), poly(X), poly(X)) :-
	is_polynomial(poly(X)),
	!.

polyplus(poly(X), poly([]), poly(X)) :-
	is_polynomial(poly(X)),
	!.

polyplus(poly([]), poly([]), poly([])) :-
	!.

%%Moltiplicazione tra due polinomi
polytimes(Expression1, Expression2, X) :-
	not(is_polynomial(Expression1)),
	not(is_polynomial(Expression2)),
	as_polynomial(Expression1, Poly1),
	as_polynomial(Expression2, Poly2),
	polytimes(Poly1, Poly2, X),
	!.

polytimes(poly(P1), poly(P2), poly(Res)) :-
	moltiply(P1, P2, X),
	monomials(poly(X), Res),
	!.

% Moltiplicazione tra due polinomi con 2+ monomi
moltiply([Monomio1 | Polinomio1], Polinomio2, Res) :-
	moltiply(Polinomio1, Polinomio2, Res1),
	moltiply(Monomio1, Polinomio2, Res2),
	append(Res2, Res1, Res),
	!.

% Moltiplicazione tra monomio e polinomi
%% Ho dovuto creare questo caso in piu' perche' altrimenti con l'altro
%% predicato mi creava liste di liste
moltiply(Monomio2, [Monomio1 | Polinomio], [Monomio|Res]) :-
	moltiply(Monomio2, Polinomio, Res),
	Monomio1 = m(Coeff1, Grado1, Vps1),
	Monomio2 = m(Coeff2, Grado2, Vps2),
	Coeff is Coeff1 * Coeff2,
	Grado is Grado1 + Grado2,
	append(Vps1, Vps2, Vps),
	simply_var(Vps, V),
	Monomio = m(Coeff, Grado, V),
	!.

%% Moltiplicazione tra monomi
moltiply(Monomio1, Monomio2, Res) :-
	Monomio1 = [m(Coeff1, Grado1, Vps1)],
	Monomio2 = [m(Coeff2, Grado2, Vps2)],
	Coeff is Coeff1 * Coeff2,
	Grado is Grado1 + Grado2,
	append(Vps1, Vps2, Vps),
	simply_var(Vps, V),
	Res = m(Coeff, Grado, V),
	!.

%% Moltiplicazione tra polinomio e monomio
moltiply([Monomio1 | Polinomio], Monomio2, [Monomio,Res]) :-
	moltiply(Polinomio, Monomio2, Res),
	Monomio1 = m(Coeff1, Grado1, Vps1),
	Monomio2 = [m(Coeff2, Grado2, Vps2)],
	Coeff is Coeff1 * Coeff2,
	Grado is Grado1 + Grado2,
	append(Vps1, Vps2, Vps),
	simply_var(Vps, V),
	Monomio = m(Coeff, Grado, V),
	!.

%% Moltiplicazione tra monomio e polinomio
moltiply(Monomio2, [Monomio1 | Polinomio], [Monomio,Res]) :-
	moltiply(Monomio2, Polinomio, Res),
	Monomio1 = m(Coeff1, Grado1, Vps1),
	Monomio2 = [m(Coeff2, Grado2, Vps2)],
	Coeff is Coeff1 * Coeff2,
	Grado is Grado1 + Grado2,
	append(Vps1, Vps2, Vps),
	simply_var(Vps, V),
	Monomio = m(Coeff, Grado, V),
	!.

% caso base moltiplicazione
moltiply( _, _, []).
