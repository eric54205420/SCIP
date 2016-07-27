

; Functional programs
; encode mathematical truths


( define ( fact n )
	 ( cond 
	   	(( = n 1 ) 1 )
		( else ( * n ( fact ( - n 1 ) ) ) )
		))

; for all n belongs to N
;
; n = 1 => n! = 1
; n > 1 => n! = n ( n - 1 )!

; Processes evolved by such programs
; can be understood by substitution:

; ( fact 4 )
; ( * 4 ( fact 3 ) )
; ( * 4 ( * 3 ( fact 2 ) ) )
; ( * 4 ( * 3 ( * 2 ( fact 1 ) ) ) )
; ( * 4 ( * 3 ( * 2 1 ) ) ) )
; ( * 4 ( * 3 2 ) )
; ( * 4 6 )
; 24

; Methods may be distinguished by the
; choice of turths expressed.

( define ( add n m )
	 ( cond
	   (( = n 0 ) m )
	   ( else ( + 1 ( add ( - n 1 ) m ) ) ) 
	   ))

; for n, m belongs to N
; n = 0 => n + m = 0
; n > 0 => n + m = ( ( n - 1 ) + m ) + 1

( define ( add2 n m )
	 ( cond
	   (( = n 0 ) m )
	   ( else  ( add2 ( - n 1 ) ( + m 1 ) ) )
	   ))

; for n, m belons to N
; n = 0 => n + m = m
; n > 0 => n + m = ( n - 1 ) + ( m + 1 )

; illustrate the difference between 
; fn with assign or not

( define COUNT 1 )
( define ( demo x )
	 ( set! COUNT ( + COUNT 1 ) )
	 ( display ( + x COUNT  ) )
	 )

; ( demo 3 ) 	5
; ( demo 3 ) 	6


; bright side of assign operator
;
; *********************************
; * may be hard to understand and *
; * will be clear after 5b        *
; *********************************
;

( define ( fact n )
	 ( define ( iter m i )
		  ( cond 
		    	(( > i n )( display m ) )
			( else ( iter ( * i m ) ( + i 1 )))))
	 ( iter 1 1 ) )
; ( fact 5 )

; imperative implementation 

( define ( fact n )
	 ( let (( i 1 ) ( m 1 ) )
	       ( define ( loop )
			( cond 
				(( > i n ) m )
				( else
				  	( set! m ( * i m ))
					( set! i ( + i 1 ))
					( loop ))))
	       ( loop ) ))

; ( display ( fact 5 ) )

; let is syntax sugar for lambda
;
; ( let (( var1 e1 ) ( var2 e2 )) e3 )
;
; ==>
;
; ( ( lambda ( var1 var2 ) e3 ) e1 e2 ) 

; explain the meaning of "bniding"
;
; ( lambda ( y ) ( ( lambda ( x ) ( * x y ) ) 3 )) 
;
; => "x" "y" is binded but "*" is not.
;
; => is totally equal to the following:
;
; ( lambda ( x ) ( ( lambda ( z ) ( * z y ) ) 3 ) )
; 
; ( lambda ( x ) ( * x y ) ) => y is free variable.

; ractify the functional env to assign env.

( define MAKE-COUNTER
	 ( lambda ( N ) 
		  ( lambda ()
			   ( set! N ( + 1 N ))
			   N )))

( define counter1 ( MAKE-COUNTER 0 ) )
( define counter2 ( MAKE-COUNTER 10 ) )
; counter1 is distinct to counter2
; "sepatated object" 
( counter1 ) 
( counter1 ) 
( counter2 ) 
( counter2 )

;;; Cesaro's method for estimating Pi:
;;; Prob ( gcd ( n1, n2 ) = 1 ) = 6 / ( Pi * Pi )
;;;


( define ( estimate-pi n )
	 ( sqrt ( / 6 ( monte-carlo n cesaro ))))

( define ( cesaro )
	 ( = ( gcd ( rand ) ( rand ) ) 1 ))

( define ( monte-carlo trials experiment )
	 ( define ( iter remaining passed )
		  ( cond (( = remaining 0 ) ( / passed trials ) )
			 (( experiment ) ( iter ( - remaining 1 ) ( + 1 passed ) ))
			 ( else ( iter ( - remaining 1 ) ( passed ))))
		  ( iter trials 0 )))

( define rand
	 ( let (( x random-init ))
	       ( lambda ()
			( set! x ( rand-update x ) )
			x)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;		without assignment	     ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

( define ( estimate-pi n )
	 ( sqrt ( / 6 ( random-gcd-test n ))))

( define ( random-gcd-test trials )
	 ( define ( iter remaining passed x )
		  ( let (( x1 ( rand-update x )))
			( let (( x2 ( rand-update x1 )))
			      ( cond (( = remaining 0 ) ( / passed intrials ))
				     (( = ( gcd x1 x2 ) 1 ) 
				      	( iter ( - 1 remaining ) ( + 1 passed ) x2 ))
				     ( else ( iter ( - 1 remaining ) passed  x2 ))))))
	 ( iter  trials 0 initial-x ))
