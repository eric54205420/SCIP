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
