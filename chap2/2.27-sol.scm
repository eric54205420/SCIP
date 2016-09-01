;; for binary tree only

( define ( deep-reverse tree )
	 ( cond
	   	(( empty-tree? tree )	'() )
		(( leaf? tree ) 	tree )
		( else 
		  	( reverse ( make-tree ( deep-reverse ( left-branch tree ) )
					      ( deep-reverse ( right-branch tree ) ) ) ) ) )
	 )

( define ( empty-tree? tree ) ( null? tree ) )
( define ( leaf? tree )	( not ( pair? tree ) ) )
( define ( make-tree left-branch right-branch )
	 	( list left-branch right-branch ) )
( define ( left-branch tree ) ( car tree ) )
( define ( right-branch tree ) ( cadr tree ) )

( define x ( list ( list 1 2 ) ( list 3 4 ) ) )
( display ( deep-reverse x ) )

;; better-sol

( define ( tree-reverse tree )
	 ( define ( iter remained-items result )
		  ( if ( null? remained-items )
		       result
		       ( iter ( cdr remained-items )
			      ( cons ( if ( pair? ( car remained-items ) )
					  ( tree-reverse ( car remained-items ) )
					  ( car remained-items ) )
				     result ) ) ) )
	 ( iter tree '() ) )

( display ( tree-reverse ( list ( list 1 2 ) ( list 3 4 ) ( list 5 6 ) ) ) )
