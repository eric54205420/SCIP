( define user-initial-environment ( scheme-report-environment 5 ) )
( use-modules ( ice-9 r5s5 ))

( define ( atom? x )
	( and ( not ( pair? x ) ) ( not ( null? x ) ) )
	)

; ( define assq
;	( lambda ( x ls )
;		( cond
;			(( null? ls ) #f )
;			(( eq? ( caar ls x ) ( car ls ))
;			( else ( assq x ( cdr ls ) ) )
;		)))
;
; 	"ls=> ( ( x 1 ) ( y 2 ) ( z 3 ) ( a 4 ) ( b 5 ) ( c 6 ))
;	( assq 'x ls ) => ( x 1 )

( define ( make-empty-dictionary ) '() )

( define ( compound? exp ) 	( pair? exp ))
( define ( constant? exp )	( number? exp ))
( define ( variable? exp )	( atom? exp ))

( define ( variable-name pattern ) ( cadr pattern ))

( define ( loopup var dictionary )
	( let (( v ( assq var dictionary ) ))
		( if ( not v ) 
			var
			( cadr v ) 
		)))

( define ( arbitrary-constant? pattern )
	( if ( pair? pattern ) ( eq? ( car pattern ) '?c ) false ))
( define ( arbitrary-expression? pattern )
	( if ( pair? pattern ) ( eq? ( car pattern ) '? ) false ))
( define ( arbitrary-variable? pattern )
	( if ( pair? pattern ) ( eq? ( car pattern ) '?v ) false ))

( define ( extend-dictionary pat dat dictionary )
	( let (( vname ( variable-name pat ) ))
		( let (( v ( assq vname dictionary ) ))
			( cond
				( ( not v ) ( cons ( list vname dictionary ) ))
				( ( eq? ( cadr v ) dat ) dictionary )
				( else 'failed )
			))))

( define ( match pattern expression dictionary )
	( cond
		( ( eq? dictionary 'failed ) 'failed )
		(( and ( null? pattern ) ( null? expression ) )	dictionary )
		( ( atom? pattern )
			( if ( atom? expression )
				 ( if ( eq? pattern expression ) 
					dictionary
					'failed )
			'failed ))
		
		(( arbitrary-constant? pattern )
			( if ( constant? expression ) 
				( extend-dictionary pattern expression dictionary )
				'failed ))
		(( arbitrary-constant? pattern )
			( if ( constant? expression ) 
				( extend-dictionary pattern expression dictionary )
				'failed ))
		(( arbitrary-variable? pattern )
			( if ( variable? expression ) 
				( extend-dictionary pattern expression dictionary )
				'failed ))
		( ( arbitrary-expression? pattern )
				( extend-dictionary pattern expression dictionary ))
				( atom? expression ) 'failed )
	
		( else
			( match ( cdr pattern )
			             ( cdr expression )
			             ( match ( car pattern )
				        ( car expression )
				        dictionary )))
	))
	
	; Skeletons & Evaluations

(define (skeleton-evaluation? skeleton)
  (if (pair? skeleton) (eq? (car skeleton) ':) false))

(define (evaluation-expression evaluation) (cadr evaluation))

(define (instantiate skeleton dictionary)
  (cond ((null? skeleton) '())
        ((atom? skeleton) skeleton)
        ((skeleton-evaluation? skeleton)
         (evaluate (evaluation-expression skeleton)
                   dictionary))
        (else (cons (instantiate (car skeleton) dictionary)
                    (instantiate (cdr skeleton) dictionary)))))

; Evaluate (dangerous magic)

(define (evaluate form dictionary)
  (if (atom? form)
      (lookup form dictionary)
      (apply (eval (lookup (car form) dictionary)
                   user-initial-environment)
             (map (lambda (v) (lookup v dictionary))
                     (cdr form)))))

; Rules

(define (pattern  rule) (car  rule))
(define (skeleton rule) (cadr rule))

; Simplifier

(define (simplifier the-rules)
  (define (simplify-exp exp)
    (try-rules (if (compound? exp)
                   (simplify-parts exp)
                   exp)))
  (define (simplify-parts exp)
    (if (null? exp)
        '()
        (cons (simplify-exp   (car exp))
              (simplify-parts (cdr exp)))))
  (define (try-rules exp)
    (define (scan rules)
      (if (null? rules)
          exp
          (let ((dictionary (match (pattern (car rules))
                                   exp
                                   (make-empty-dictionary))))
            (if (eq? dictionary 'failed)
                (scan (cdr rules))
                (simplify-exp (instantiate (skeleton (car rules))
                                           dictionary))))))
    (scan the-rules))
  simplify-exp)

; another way to write simplify-exp
(define (simplify-exp exp)
  (try-rules
    (if (compound? exp)
      (map simplify-exp exp)
      exp)))

'(+ (* (? x) (? y)) (? y))

'(+ (* 3 x) x)

(match '(+ (* (? x) (? y)) (? y)) '(+ (* 3 x) x) (make-empty-dictionary))

(evaluate '(+ x x) '((y x) (x 3)))

; Symbolic Differentiation

(define deriv-rules
  '(
    ( (dd (?c c) (? v))              0                                 )
    ( (dd (?v v) (? v))              1                                 )
    ( (dd (?v u) (? v))              0                                 )
    ( (dd (+ (? x1) (? x2)) (? v))   (+ (dd (: x1) (: v))
                                        (dd (: x2) (: v)))             )
    ( (dd (* (? x1) (? x2)) (? v))   (+ (* (: x1) (dd (: x2) (: v)))
                                        (* (dd (: x1) (: v)) (: x2)))  )
    ( (dd (** (? x) (?c n)) (? v))   (* (* (: n) (+ (: x) (: (- n 1))))
                                        (dd (: x) (: v)))              )
    ))

(define dsimp (simplifier deriv-rules))

(dsimp '(dd (+ x y) x))

;; Algebraic simplification

(define algebra-rules
  '(
    ( ((? op) (?c c1) (?c c2))                (: (op c1 c2))                )
    ( ((? op) (?  e ) (?c c ))                ((: op) (: c) (: e))          )
    ( (+ 0 (? e))                             (: e)                         )
    ( (* 1 (? e))                             (: e)                         )
    ( (* 0 (? e))                             0                             )
    ( (* (?c c1) (* (?c c2) (? e )))          (* (: (* c1 c2)) (: e))       )
    ( (* (?  e1) (* (?c c ) (? e2)))          (* (: c ) (* (: e1) (: e2)))  )
    ( (* (* (? e1) (? e2)) (? e3))            (* (: e1) (* (: e2) (: e3)))  )
    ( (+ (?c c1) (+ (?c c2) (? e )))          (+ (: (+ c1 c2)) (: e))       )
    ( (+ (?  e1) (+ (?c c ) (? e2)))          (+ (: c ) (+ (: e1) (: e2)))  )
    ( (+ (+ (? e1) (? e2)) (? e3))            (+ (: e1) (+ (: e2) (: e3)))  )
    ( (+ (* (?c c1) (? e)) (* (?c c2) (? e))) (* (: (+ c1 c2)) (: e))       )
    ( (* (? e1) (+ (? e2) (? e3)))            (+ (* (: e1) (: e2))
    ))
    ))
	
; (define dsimp (simplifier deriv-rules))
; (define alsimp (simplifier algebra-rules))
 
; (define (deriv exp)
    ; (alsimp (dsimp exp))
; )

; (equal? (deriv '(dd (+ x y) x))          1)
; (equal? (deriv '(dd (* x y) x))         'y)
; (equal? (deriv '(dd (+ (* x y) x) x))   '(+ 1 y))
