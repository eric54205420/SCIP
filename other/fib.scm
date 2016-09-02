( define ( fib n )
	 ( cond
	   (( = n 0 ) 0 )
	   (( = n 1 ) 1 )
	   ( else
	     	( + ( fib ( - n 1 ) ) ( fib ( - n 2 ) ) ) ) ) )

( define ( fib2 n )
	 ( define ( iter n result1 result2 )
		  ( cond
		    (( = n 0 ) 0 )
			(( = n 1 ) result1 )
			( else
			  ( iter ( - n 1 ) ( + result1 result2 )  result1 ) ) ) )
	 ( iter n 1 0 ) )

;( display ( fib 6 ) )
;( display ( fib2 6 ) )
