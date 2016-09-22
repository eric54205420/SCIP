
( load "pascal-item.scm" )

( define ( print-row n )
	 ( define ( print-iter n counter )
		  ( cond
		    	(( > counter n ) #t )
			( else
			  	( display ( pascal-item n counter ) )
				( display " " )
				( print-iter n ( + counter 1 ) ) ) ) )

	 ( print-iter n 1 ) )

( define ( print-space n )
 	( define ( print-space-iter n counter )
		( cond 
			(( > counter n ) #f )
			( else
				( display " " )
				( print-space-iter n ( + counter 1 ) ) ) ) )
	( print-space-iter n 1 ) )
	
( define ( print-loop n )
	 ( define ( print-loop-iter n counter )
	 	( cond
	   		(( > counter n ) #t )
			( else
			  	( print-space ( + ( - n counter ) 1 ) )
		  		( print-row counter )
				( newline )
				( print-loop-iter n ( + counter 1 ) ) ) ) )
	 ( print-loop-iter n 1 ) )

; ( print-loop 5 )
