(defun is-monomial (m)
  (and (listp m)
       (eq 'm (first m))
       (let ((mtd (monomial-total-degree m))
             (vps (monomial-vars-and-powers m))
            )
          (and (integerp mtd)
               (>= mtd 0)
               (listp vps)
               (every #'is-varpower vps)))))

(defun is-varpower (vp)
  (and (listp vp)
       (eq 'v (first vp))
       (let ((p (varpower-power vp))
             (v (varpower-symbol vp))
            )
          (and (integerp p)
               (>= p 0)
               (symbolp v)))))

(defun is-polynomial (p)
  (and (listp p)
       (eq 'POLY (first p))
       (let ((ms (poly-monomials p)))
         (and (listp ms)
              (every #'is-monomial ms)))))

;; ritorna la lista dei monomi
(defun poly-monomials (m)
  (if (null m)
      nil
    (second m)))

;; ritorna la lista VPS del monomio
(defun monomial-vars-and-powers (m)
  (if (null m)
      nil
    (fourth m)))

;; ritorna il grado totale del monomio
(defun monomial-total-degree (m)
  (if (null m)
      nil
    (third m)))

;; ritorna il valore della potenza di una Vp
(defun varpower-power (vp)
  (if (null vp)
      nil
    (second vp)))

;; ritorna il simbolo di variabile di una Vp
(defun varpower-symbol (vp)
  (if (null vp)
      nil
    (third vp)))

;; ritorna lista contenente una Vp
(defun as-vps (vps)
  (if (and (listp vps)          
           (eq 'expt (first vps)))
      (let ((p (varpower-power vps))
            (va (varpower-symbol vps))
           )
        (list 'v va p))
    (if (symbolp vps)
        (list 'v 1 vps)
      nil)))

;; restituisce lista delle VPs nel monomio
(defun varpowers (m)
  (if (is-monomial m)
      (fourth m)
    (if (null m)
        nil
      (and (listp m)
           (eq '* (first m))
           (if (and (integerp (second m))
                    (not (= 0 (second m))))
               (mapcar 'as-vps (rest(rest m)))
             (if (and (integerp (second m))
                      (= 0 (second m)))
                 nil
             (mapcar 'as-vps (rest m))))))))

;; effettua dei controlli sul monomio
;; e chiama vars-of-list passandogli la lista delle VPs
;; per calcolarne la lista delle variabili nel monomio
(defun vars-of (m)
  (if (null m)
      nil
    (if (not (is-monomial m))
        (let ((mon (as-monomial m)))
          (vars-of mon))
      (let ((v (varpowers m)))
        (if (null v)
            nil
          (vars-of-list v))))))

;; ritorna lista delle variabili contenute nel monomio
(defun vars-of-list (vps)
  (and (listp vps)
       (every #'is-varpower vps)
       (if (null vps)
           nil
         (let((vp (append (list (varpower-symbol (car vps)))
                          (vars-of-list(cdr vps))))
              )
           (sort (copy-seq vp) #'string-lessp)))))

;; restituisce il grado totale del monomio
(defun monomial-degree (m)
  (if (is-monomial m)
       (third m)
      (if (null m)
           0
        (and (listp m)
             (eq '* (first m))
             (let ((vp (mapcar 'varpower-power (varpowers m))))
               (sum  vp))))))

;; restituisce la somma dei numeri in una lista
(defun sum(l)
  (cond ((null l) 0)
        (T (+ (car l) (sum (cdr l))))))

;; restituisce il coefficiente di un monomio
(defun monomial-coefficient (m)
  (if  (is-monomial m)
      (second m)
      (if (null m)
           0
        (and (listp m)
             (eq '* (first m))
                 (if (integerp (second m))
                     (second m)
                   (if (or (symbolp (second m))
                           (eq 'expt (first (second m))))
                       1))))))

;; restituisce il monomio parsato
(defun as-monomial (m)
  (if (null m)
      nil
    (if (integerp m)
        (list 'm m 0 nil)
      (if (symbolp m)
          (list 'm 1 (varpower-power(as-vps m)) (list (as-vps m)))
        (if (eq 'expt (first m))
            (list 'm 1 (varpower-power(as-vps m)) (list (as-vps m)))
          (if (and (eq '* (first m))
                   (listp m))
              (let ((c (monomial-coefficient m))
                    (td (monomial-degree m))
                    (vp (varpowers m))
                    )
                (simply-mon (list 'm c td (remove-zeros vp))))))))))

;; rimuove da una monomio le VPs con potenza 0
(defun remove-zeros (monomio)
  (cond ((atom monomio)
         monomio
         )
        ((atom (car monomio))
         (cons (car monomio) (remove-zeros (cdr monomio)))
         )
         ((null monomio)
          nil
          )
         ((and (listp (car monomio))
               (listp (first (car monomio)))
               (not (= 0 (second (first (car monomio))))))
          (cons (cons (first (car monomio))
          	(remove-zeros (cdr (car monomio)))) nil)
          )
         ((and (listp (car monomio))
               (is-varpower (car monomio))
               (= 0 (second (car monomio))))
          (remove-zeros (cdr monomio))
          )
         ((and (listp (car monomio))
               (atom (first (car monomio)))
               (not (= 0 (second (car monomio)))))
          (cons (car monomio) (remove-zeros (cdr monomio))))))

;; rimuove monomi con coefficiente 0
(defun simply-mon (m)
  (if (null m)
      nil
    (if (eq '0 (monomial-coefficient m))
        (list 'm 0 0 nil)
      (if(not (null (fourth m)))
          (and(sort (fourth m) #'string-lessp :key #'third)
           (list 'm (second m) (third m) (simply-vps (fourth m))))
        (list 'm (second m) (third m) nil)))))

;; somma tra di loro le VPs simili
(defun simply-vps (vps)
  (if (null vps)
      nil
    (if (eq (length vps) 1)
        vps
        (if (eq (third (first vps)) (third (second vps)))
        (let ((v (+ (second (first vps)) (second (second vps)))))
          (if (not (null (rest (rest vps))))
              (simply-vps (cons (list 'v v (third (first vps)))
              				(rest (rest vps))))
            (list (list 'v v (third (first vps))))
            ))
      (cons (first vps) (simply-vps (rest vps)))))))

;; ritorna la lista dei coefficienti dei monomi
;; contenuti nel polinomio
(defun coefficients (m)
  (if (not (is-polynomial m))
           (let ((pol (as-polynomial m)))
             (coefficients  pol))
      (if (or (null m)
              (null (second m)))
          (list 0)
        (let ((mon (second m)))
          (mapcar 'monomial-coefficient mon)))))

;; restituisce la lista delle variabili che
;; compaiono nel polinomio
;; senza ripetizioni
(defun variables (m)	
  (if (null m)
      nil
    (if (not (is-polynomial m))
        (let ((pol (as-polynomial m)))
          (variables pol))
      (if (or (null m)
              (null (second m)))
          nil
        (let ((mon (mapcar 'vars-of (second m))))
          (remove-duplicates (sort (reduce #'append mon) #'string-lessp)
                             :test #'equal))))))

;; restituisce il polinomio parsato
(defun as-polynomial (expr)
  (cond ((null expr)
         nil)
        ((and (numberp expr)
              (= 0 expr))
         (cons 'POLY (cons nil nil))
         )
        ((numberp expr)
         (list 'POLY (list (as-monomial expr))))
        ((is-monomial expr)
         (cons 'POLY (cons (list expr) nil)))

         ((and (listp expr)
              (eq '* (car expr)))
         (list 'POLY (list (as-monomial expr))
               ))

        ((and (listp expr)
              (eq '+ (car expr)))
         (list 'POLY (monomials (cons 'POLY (cons (as-polynomial (cdr expr))
         					nil)))
               ))
        ((listp expr)
         (let ((monomial (as-monomial (car expr))))
           (cons monomial (as-polynomial (cdr expr)))))))

;; restituisce il grado del monomio avente
;; grado totale massimo
(defun maxdegree (m)
  (if (not (is-polynomial m))
      (let ((pol (as-polynomial m)))
        (maxdegree pol))
    (if(or (null m)
           (null (second m)))
        nil
      (and (listp (second m))
           (let ((td (last (second m))))       
             (monomial-degree (first td)))))))

;; restituisce il grado del monomio avente
;; grado totale minimo
(defun mindegree (m)
  (if (not (is-polynomial m))
      (let ((pol (as-polynomial m)))
        (mindegree pol))
    (if(or (null m)
           (null (second m)))
        nil
      (and (listp (second m))
           (let ((td (first (second m))))
             (monomial-degree td))))))

;; stampa a video la rappresentazione canonica
;; del polinomio
(defun pprint-polynomial (m)
  (if(null m)
      nil
    (if (not (is-polynomial m))
        (let ((pol (as-polynomial m)))
          (pprint-polynomial pol))
      (flatten (mapcar 'pprint-monomial (second m))))))

;; stampa a video la rappresentazione canonica
;; del monomio
(defun pprint-monomial (m)
  (if (not (is-monomial m))
      (let ((mon (as-monomial m)))
        (pprint-monomial mon))
    (if (null m)
        nil
      (list (pprint-coeff m) (mapcar 'pprint-vps (fourth m))))))

;; stampa a video il coefficiente del monomio
(defun pprint-coeff (m)
  (if (> (monomial-coefficient m) 1)
      (list '+ (monomial-coefficient m))
    (if (eq (monomial-coefficient m) 1)
        '+
      (monomial-coefficient m))))

;; stampa a video la rappresentazione di una Vp
(defun pprint-vps (m)
  (if (null m)
      nil
      (if (not (is-varpower m))
          (let ((vps (as-vps m)))
            (pprint-vps vps))
        (if (> (varpower-power m) 1)
            (let((symbol (varpower-symbol m))
                 (power (varpower-power m))
                 )
              (list symbol '^ power)
              )
          (varpower-symbol m)))))

;; rimuove parentesi innestate
(defun flatten (obj)
  (if(null obj)
      obj
    (if (listp obj) 
        (mapcan #'flatten obj) 
      (list obj))))

;; restituisce la lista ordinata dei monomi
(defun monomials (poly)
  (if (not (is-polynomial poly))
      (let ((pol (as-polynomial poly)))
        (monomials pol))
    (if(null poly)
        nil
      (let ((p (sort (copy-seq (car (cdr poly))) #'< :key #'third)))
       (flat-pol (same-pol (remove-0-pol  p)))))))

;; semplifica i monomi e poi somma
;; tra di loro quelli simili
(defun remove-0-pol (p)
  (if (null p)
      p
    (simply (mapcar 'simply-mon p))))

;; elimina monomi con coefficiente 0
(defun flat-pol (pol)
  (if (null pol)
      nil
    (if (and (eq (length pol) 1) 
             (is-monomial (first pol))
             (eq (monomial-coefficient (first pol)) 0))
        nil
      (if (and (eq (length pol) 1) 
               (is-monomial (first pol))
               (not (eq (monomial-total-degree (first pol)) 0)))
          pol
        (if (eq (monomial-coefficient (first pol)) 0)
            (and (del pol (first pol))
                 (flat-pol (rest pol)))
          (cons (first pol) (flat-pol (rest pol))))))))    

;; ordina monomi con grado uguale
(defun same-pol (mon)
  (if (null mon)
      mon
    (if (eq (length mon) 1)
        mon
      (let ((td1 (monomial-total-degree (first mon)))
            (td2 (monomial-total-degree (second mon)))
            (l1 (length (monomial-vars-and-powers (first mon))))
            (l2 (length (monomial-vars-and-powers (second mon))))
            (same (list (first mon) (second mon)))
            (rest-pol (same-pol (rest mon)))
            )
        (if (and (not (eq td1 td2))
                 (> (length mon) 2))
            (cons (first mon) rest-pol)
          (if (and (not (eq td1 td2))
                   (< (length mon) 2))
              (list (first mon) rest-pol)
            (if (and (not (eq td1 td2))
                     (eq (length mon) 2))
                mon
              (if (null (rest (rest mon)))
                  (if (> l1 l2)
                      (list (first mon) (second mon))
                    (if (> l2 l1)
                        (list (second mon) (first mon))
                      (sort (copy-seq same) #'< :key #'third)))              
                (if (> l1 l2)
                    (cons (first mon) (same-pol (append (second mon)
                    					(rest (rest mon)))))
                  (if (> l2 l1)
                      (cons (second mon)
                            (same-pol (append (first mon)
                                              (rest (rest mon)))))
                    (cons (car (sort (copy-seq same) #'< :key #'third))
                          (same-pol (append (cdr same) (rest (rest mon)))))
))))))))))                                                 

;; restituisce la somma tra due polinomi
(defun polyplus (p1 p2) 
  (if (and (not (is-polynomial p1)) (not (is-polynomial p2)))
      (let ((pol1 (as-polynomial p1))
            (pol2 (as-polynomial p2))
           )
        (polyplus pol1 pol2))
    (let ((lmon1 (monomials p1))
          (lmon2 (monomials p2))
         )
      (if (not (null (first (mapcar 'simply-mon (simply (sort (copy-seq
                                                               (append lmon1
                                                                       lmon2))
                                                              #'< :key #'third
                                                              ))))))
          (list 'POLY (monomials (list 'POLY (sort (copy-seq
                                                    (append lmon1
                                                            lmon2))
                                                   #'< :key #'third))))
        (list 'poly nil)))))

;; restituisce la differenza tra due polinomi 
(defun polyminus (p1 p2) 
  (if (and (not (is-polynomial p1)) (not (is-polynomial p2)))
      (let ((pol1 (as-polynomial p1))
            (pol2 (as-polynomial p2))
           )
        (polyminus pol1 pol2))
    (let ((lmon1 (monomials p1))
          (lmon2 (mapcar 'coeff-neg (monomials p2)))
          )
      (if (not (null (first (mapcar 'simply-mon (simply (sort (copy-seq
                                                               (append lmon1
                                                                       lmon2))
                                                              #'< :key #'third
))))))
          (list 'POLY (monomials (list 'POLY (sort (copy-seq
                                                    (append lmon1
                                                            lmon2))
                                                   #'< :key #'third))))
        (list 'poly nil)))))

;; restituisce il monomio opposto a quello in input
(defun coeff-neg (m)
  (if (null m)
      nil
    (let ((c (* (monomial-coefficient m) -1)))
     (list 'm c (monomial-degree m) (varpowers m)))))

;; somma tra di loro i monomi simili
;; restituendo la lista risultante
(defun simply (m)
  (if (null m)
      nil
    (if (eq (length m) 1)
        m
      (if (equal (varpowers (first m)) (varpowers (second m)))
          (let ((l (list 'm 
                             (+ (monomial-coefficient (first m))
                                (monomial-coefficient (second m)))
                             (monomial-degree (first m))
                             (varpowers (first m))))
                     (new-m (del (del m (first m))
                                 (first (del m (first m))))))
               (if (> (length m) 2)
                   (simply (cons l (simply new-m)))
                 (remove nil (list l new-m))))
               
        (if (not (null (rest m)))
        (cons (car (list (first m) (second m))) (simply (rest m))))))))

;; restituisce la lista dalla quale
;; sono state tolte tutte le occorrenze
;; di 'x'
(defun del (l x)
  (cond ((null l) l)
        ((equal (car l) x) (cdr  l))
        (T (cons (car l) (del (cdr l) x)))))

;; calcola il valore del polinomio
;; effettua i controlli base
;; rimanda il calcolo effettivo a 'calculate'
(defun polyval (poly varval)
  (cond ((null poly)
         nil
         )
        ((null varval)
         nil
         )
        ((not (is-polynomial poly))
         (let ((p (as-polynomial poly)))
           (polyval p varval))
         )
        ((and (as-polynomial poly)
              (listp varval)
              (mapcar 'numberp varval))
         (calculate (car(cdr poly)) varval (variables poly))
         )
        (T nil)))

;; calcola il valore dei monomi
;; con i valori dati in input
(defun calculate (monomi varval vps)
  (cond ((null monomi)
         0
         )
        ((is-monomial (car monomi))
         (let ((valori
                (valore-potenze (potenze
                                 (variables (as-polynomial
                                             (car monomi))) 
                                 vps) varval)))
           ( + 
             (* (mul (pow-val (fourth (car monomi))) valori)
                (second (car monomi)))
             (calculate (cdr monomi) varval vps)
         ))
         )
        (T nil)
))

;; restituisce la lista in cui
;; nella i-esima posizione c'è il valore
;; della potenza della i-esima variabile
(defun pow-val (vps)
  (cond ((null vps)
         nil
         )
        ((numberp (second (car vps)))
         (cons (second (car vps)) (pow-val (cdr vps)))
         )
        (T nil)
))

;; restituisce una lista in cui, in ogni posizione i,
;; ho il valore da sostituire alla i-esima variabile
;; nella lista restituita da variables
(defun valore-potenze (potenze valori)
  (cond ((null potenze)
         nil
         )
        ((numberp (car potenze))
         (cons (element-at (car potenze) valori)
               (valore-potenze (cdr potenze) valori))
         )
))

;; restituisce una lista in cui, in ogni posizione i, 
;; ho la posizione della i-esima variabile contenuta
;; in vps che compare in variabili
(defun potenze (vps variabili)
  (cond ((null vps)
         nil
         )
        ((atom (car vps))
         (cons (index-of (car vps) variabili)
               (potenze (cdr vps) variabili))
         )
))

;; restituisce il risultato del calcolo
;; delle vps con i valori specificati in polyval
(defun mul (variabili valori)
  (cond ((null variabili)
         1
         )
        ((and (listp variabili)
              (listp valori))
         (* (expt (car valori) (car variabili))
            (mul (cdr variabili) (cdr valori)))
         )
        (T nil)
))

;; restituisce la posizione dell'ultima
;; occorrenza di 'e' nella lista 'lista'
;; nel caso in cui non ci fosse l'elemento,
;; ritorna (+ (length lista) 1)
(defun index-of (e lista)
  (cond ((null lista)
         1
         )
        ((eq e (car lista))
         1
         )
        (T (+ 1 (index-of e (cdr lista))))))

;; restituisce l'espressione contenuta nella lista
;; nella posizione specificata
(defun element-at (index list)
  (cond ((or (null list)
             (< index 1))
         nil
         )
        ((eq 1 index)
         (car list)
         )
        (T (element-at (- index 1) (cdr list)))))

;; gestisce casi limite della moltiplicazione
;; tra due polinomi rimandando il calcolo
;; effettivo a multiply
(defun polytimes (poly1 poly2)
  (cond ((or (null poly1)
             (null poly2)
             (and (listp poly1)
                  (eq 'NIL (second poly1)))
             (and (listp poly2)
                  (eq 'NIL (second poly2)))
             (and (numberp poly1)
                  (= 0 poly1))
             (and (numberp poly2)
                  (= 0 poly2)))
         (cons 'POLY (cons nil nil))
         )
        ((and (not (is-polynomial poly1))
              (not (is-polynomial poly2)))
         (let ((p1 (as-polynomial poly1))
               (p2 (as-polynomial poly2)))
           (let ((ris (multiply p1 p2)))
             (cond ((null ris)
                    nil
                    )
                   ((listp ris)
                    (list 'POLY (monomials (list 'POLY ris)))
                    )
                   ))
         ))
        ((and (is-polynomial poly1)
              (not (is-polynomial poly2)))
         (let ((p2 (as-polynomial poly2)))
           (let ((ris (multiply poly1 p2)))
             (cond ((null ris)
                    nil
                    )
                   ((listp ris)
                    (list 'POLY (monomials (list 'POLY ris)))
                    )
                   ))
         ))
        ((and (not (is-polynomial poly1))
              (is-polynomial poly2))
         (let ((p1 (as-polynomial poly1)))
           (let ((ris (multiply p1 poly2)))
             (cond ((null ris)
                    nil
                    )
                   ((listp ris)
                    (list 'POLY (monomials (list 'POLY ris)))
                    )
                   ))
         ))
        ((and (is-polynomial poly1)
              (is-polynomial poly2))
         (let ((ris (multiply poly1 poly2)))
           (cond ((null ris)
                  nil
                  )
                 ((listp ris)
                  (list 'POLY (monomials (list 'POLY ris)))
                  )
                 ))
         )
        (T nil)
))

;; restituisce il prodotto tra due polinomi
;; calcolando ricorsivamente il prodotto tra
;; il secondo polinomio ed un monomio
;; appartenente al primo polinomio
;; rimandando il calcolo polinomio * monomio a poly*mon
(defun multiply (poly1 poly2)
  (cond ((or (and (listp poly1)
                  (null (car poly1)))
             (and (listp poly2)
                  (null (car poly2))))
         nil
         )
        ((eq 'POLY (car poly1))
         (multiply (car (cdr poly1)) poly2)
         )
        ((eq 'POLY (car poly2))
         (multiply poly1 (car (cdr poly2)))
         )
        ((is-monomial (car poly1))
         (append (poly*mon poly2 (car poly1))
                 (multiply (cdr poly1) poly2))
         )
        (T nil)
))
 
;; restituisce la lista dei monomi moltiplicati
(defun poly*mon (poly monomial)
  (cond ((null (car poly))
         nil
         )
        ((eq 'POLY (car poly))
         (poly*mon (car (cdr poly)) monomial)
         )
        ((is-monomial (car poly))
         (cons (mon*mon (car poly) monomial)
               (poly*mon (cdr poly) monomial))
         )
        ((is-monomial poly)
         (cons (mon*mon poly monomial) nil)
         )
))

;; moltiplicazione tra due monomi
(defun mon*mon (monomial1 monomial2)
  (cond ((or (null monomial1) (null monomial2))
         nil
         )
        ((and (is-monomial monomial1)
              (is-monomial monomial2))
         (cons 'M (cons (* (second monomial1)
                           (second monomial2))
                        (cons (+ (third monomial1)
                                 (third monomial2))
                              (list (union (fourth monomial1)
                                     (fourth monomial2))))))
         )
))
