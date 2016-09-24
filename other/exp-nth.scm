; 進制表示

( define ( div a b )
		( cond
			(( = a 0 ) #f )
			(( < b a ) 0 )
			( else
			  ( + 1 ( div a ( - b a ) ) ) ) ) )

;( define ( exp-nth a b )
;	 ( cond
;	   (( = b 0 ) ( display 0 ) )
;	   ( else
;	     ( display ( remainder b a ) )
;	     ( exp-nth a ( div a b ) ) ) ) )

( define ( exp-nth a b )
	 ( define ( exp-nth-iter a b result )
		  ( cond
		    (( = b 0 ) result )
		    ( else
		      ( exp-nth-iter a ( div a b ) ( cons ( remainder b a ) result ) ) ) ) )
	 ( exp-nth-iter a b 0 ) )
