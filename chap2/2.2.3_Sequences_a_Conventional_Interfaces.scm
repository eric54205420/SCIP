;; p94- 102

( define tester ( list ( list 1 2 ) ( list 3 4 ) ( list ( list 5 6 ) 7 ) ) )
( define nil '() )
( define square ( lambda ( x ) ( * x x ) ) )
( define iden ( lambda ( x ) #t ) )

( define ( fib n )
	 ( cond
	   (( = n 0 ) 0 )
	   (( = n 1 ) 1 )
	   ( else ( + ( fib ( - n 1 ) ) ( fib ( - n 2 ) ) ) ) ) )
	   
( define ( prime? n )
	( define ( iter n count )
		( cond
		( ( or( eq? n 1 )( eq? n 0 )) #f )
		( ( or( eq? n 2 )( eq? n 3 )) #t )
		( ( or( even? n )( zero? ( remainder n count ))) #f )
		( ( > count ( sqrt n ) ) #t )
		( else ( iter n ( + count 2 )))))
	( iter n 3 )
)

( define ( sum-odd-squares tree )
	 ( cond
	   (( null? tree ) 0 )
	   (( not ( pair? tree ) ) ( if ( odd? tree ) ( square tree ) 0 ) )
	   ( else ( + ( sum-odd-squares ( car tree ) )
		      ( sum-odd-squares ( cdr tree ) ) ) ) )
	 )

;( display ( sum-odd-squares tester ) )

( define ( even-fibs n )
	 ( define ( next k )
		  ( if ( > k n )
		       nil
		       ( let (( f ( fib k ) ) )
			     ( if ( even? f )
				  ( cons f ( next ( + k 1 ) ) )
				  ( next ( + k 1 ) ) ) ) ) )
	 ( next 0 ) )

;( newline )
;( display ( even-fibs 20 ) )
;( newline )
;( display ( map square ( list 1 2 3 4 5 ) ) )

;
; operation for list

( define ( filter predicate sequence )
	 ( cond 
	   (( null? sequence ) nil )
	   (( predicate ( car sequence ) )
	    	( cons ( car sequence )
		       ( filter predicate ( cdr sequence ) ) ) )
	   ( else ( filter predicate ( cdr sequence ) ) ) ) )

;( newline )
;( display ( filter ( lambda ( x ) ( = 0 ( remainder x 2 ) ) )
;		   ( list 1 2 3 4 5 6 7 8 9 10 ) ) )

( define ( accumulate op initial sequence )
	 ( if ( null? sequence )
	      initial
	      ( op ( car sequence )
		   ( accumulate op initial ( cdr sequence ) ) ) ) )
;( newline )
;( display ( accumulate + 0 ( list 1 2 3 4 5 ) ) )
;( newline )
;( display ( accumulate * 1 ( list 1 2 3 4 5 ) ) )
;( newline )
;( display ( accumulate cons '() ( list 1 2 3 4 5 ) ) )

( define ( enumerate-interval low high )
	 ( if ( > low high )
	      '()
	      ( cons low ( enumerate-interval ( + low 1 ) high ) ) ) )

;( display ( enumerate-interval 1 100 ) )

;
; operation for tree

( define ( enumerate-tree tree )
	 ( cond
	   (( null? tree ) nil )
	   (( not ( pair? tree ) ) ( list tree ) )
	   ( else ( append ( enumerate-tree ( car tree ) )
			   ( enumerate-tree ( cdr tree ) ) ) ) ) )
;( newline )
;( display ( enumerate-tree ( list 1 ( list 2 ( list 3 4 ) ) 5 ) ) )

; refactorial sum-odd-squares

( define ( sum-odd-squares tree )
	 ( accumulate +
		      0
		      ( map square
			    ( filter odd?
				     ( enumerate-tree tree ) ) ) ) )
;( newline )
;( display ( sum-odd-squares tester ) )


( define ( even-fibs n )
	 ( accumulate cons
		      nil
		      ;( filter even?
		      ( filter iden
			       ( map fib
				     ( enumerate-interval 0 n ) ) ) ) )
;( newline )
;( display ( even-fibs 10 ) )


( define ( list-fib-squares n )
	 ( accumulate cons
		      nil
		      ( map square 
			    ( map fib
				  ( enumerate-interval 0 n )))))
;( newline )
;( display ( list-fib-squares 10 ) )

( define ( product-of-squares-of-odd-elements sequence )
	 ( accumulate *
		      1
		      ( map square
			    ( filter odd? sequence ))))
;( newline )
;( display ( product-of-squares-of-odd-elements ( list 1 2 3 4 5 ) ) )

;;; *** nested mapping ***

;;; generating triple sequence i, j, i + j  ( i, j, i+j )


( accumulate append
	nil
	( map ( lambda ( i )
		( map ( lambda ( j ) ( list i j ) )
			( enumerate-interval 1 (  - i 1 ) ) ) )
		( enumerate-interval 1 10 ) ) )

( define ( flatmap proc seq )
	( accumulate append nil ( map proc seq ) ) )

( define ( prime-sum? pair )
	( prime? ( + ( car pair ) ( cadr pair ) ) ) )

( define ( make-pair-sum pair )
	( list ( car pair ) ( cadr pair ) ( + ( car pair ) ( cadr pair ) ) ) )

;;

( define ( prime-sum-pairs n )
	( map make-pair-sum
		( filter pair-sum?
			( flatmap
				( lambda ( i )
					( map ( lambda ( j ) ( list i j ) )
						( enumerate-interval 1 ( - i 1 ) ) ) )
					( enumerate-interval 1 n ) ) ) ) )



;; permutation

( define ( permutations s )
	 ( if ( null? s )
	      ( list nil )
	      ( flatmap ( lambda ( x )
				 ( map ( lambda ( p ) ( cons x p ) )
				       ( permutations ( remove x s ) ) ) )
			s ) ) )

( define ( remove item sequence )
	 ( filter ( lambda ( x ) ( not ( = x item ) ) )
		  sequence ) )

;( display permutations '( 1 2 3 ) )
