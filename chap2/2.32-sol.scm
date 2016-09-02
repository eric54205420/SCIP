;;                     s				       	( subset s )	
;; ( 1 2 ) 			=> 	( '() (1) ( 2 ) ( 1 2 ) )
;; ( '() (1) ( 2 ) ( 1 2 ) )		( '(2) '() ) )		union 	( '(1 2 ) '(1) ) )
;; ( subset s )		=>	( subset ( cdr s ) )	append	( map ( 
;;								lambda ( x ) ( cons 
;;									( car s ) 
;;									( subset ( cdr s ) ) ) ) 
;;								( subset ( cdr s ) ) ) 
	

;; list => tree
;; append => set
;; cons => elements pair
						
( define ( subsets s )
	( if ( null? s )
	      ( list s ) 
  	      ( let (( rest ( subsets ( cdr s ) ) ) )
		( append rest ( map ( lambda ( x ) ( cons ( car s ) rest ) ) rest ) ) ) ) )
