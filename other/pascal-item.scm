( define ( pascal-item row col )
	 ( cond
	   	( ( or ( = row col ) ( = col 1 ) ) 1 )
		( else
		  	( + 
			  	( pascal-item ( - row 1 ) ( - col 1 ) )
				( pascal-item ( - row 1 ) col ) ) ) ) )
