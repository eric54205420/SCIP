; p90-94

; ( ( 1 2 ) 3 4 )
( cons ( list 1 2 ) ( list 3 4 ) )

( define x ( cons ( list 1 2 ) ( list 3 4 ) ) )
;( display ( length x ) )
;( newline )

( define ( left-branch x ) ( car x ) )
( define ( right-branch x ) ( cdr x ) )
( define ( treenode? x ) ( not ( pair? x ) ) )

( define ( count-leaves x )
	 ( cond 
	   	(( null? x ) 0 )
		(( not ( pair? x ) ) 1 )
		( else ( + 
			   ( count-leaves ( car x ) )
			   ( count-leaves ( cdr x ) ) ) ) )
	 )

;( display ( count-leaves x ) )
;( newline )
;( list x x )
;( display ( length ( list x x ) ) )
;( newline )
;( display ( count-leaves ( list x x ) ) )


( define ( reverse items )
	 ( define ( iter items result )
		  ( if ( null? items )
		       result
		       ( iter ( cdr items ) ( cons ( car items ) result ) ) ) )
	 ( iter items '() ) )

( define x ( list ( list 1 2 ) ( list 3 4 ) ) ) 
;( display ( reverse ( list 1 2 3 4 5 ) ) )
;( reverse x )  
;( map reverse x )
;( map reverse ( reverse x ) )
;( reverse ( map reverse x ) )

( define ( deep-reverse tree )
	 ( cond
	   	(( null? tree ) '() )		; empty tree
		(( not ( pair? tree ) )		; leaves
			tree ) 
		( else
		  	( reverse ( list ( deep-reverse ( car tree ) )
					 ( deep-reverse ( cadr tree ) ) ) ) ) )
	 )

( display ( deep-reverse x ) )

( define ( tree-map proc tree )
	 ( cond
	   	(( null? tree ) 	'() )
		(( treenode? tree )	( proc tree ))
		( else 
		  	 ( tree-map proc ( left-branch tree ) )
			 ( tree-map proc ( right-branch tree ) ) ) )
	 )

( define ( fringe tree )
	 ( cond
	   	(( null? tree ) 	'())
		(( not ( pair? tree ) )	( list tree ) )
		( else
		  	( append ( fringe ( car tree ) )
				 ( fringe ( cadr tree ) ) ) ) ) )

( define ( reverse-flatten-iter tree )
	 ( define ( iter tree result )
		  ( if ( null? tree )
		       result
		       ( iter ( cdr tree ) ( append ( if ( not ( pair? ( car tree ) ) )
						      ( list ( car tree ) )
						       (  reverse-flatten-iter ( car tree ) ) ) result ) ) ) )
	 ( iter tree '() ) )


( define x ( list ( list 1 2 ) ( list 3 4 ) ) )
;( newline )
;( display ( list x x ) )
;( newline )
;( display ( reverse-flatten-iter ( list x x ) ) )
;( newline )

( define ( scale-tree tree factor )
	 ( cond
	   	(( null? tree ) '() )
		(( not ( pair? tree ) ) ( * tree factor ) )
		( else ( cons ( scale-tree ( car tree ) factor )
			      ( scale-tree ( cdr tree ) factor ) ) ) )
	 )

( define ( scale-tree2 tree factor )
	 ( map ( lambda ( sub-tree ) 
			( if ( pair? sub-tree )
			     ( scale-tree sub-tree factor )
			     ( * sub-tree factor ) ) )
	       tree ) )


( display ( scale-tree ( list x x ) 10 ) )
( newline )
( display ( scale-tree2  ( list x x ) 10 ) )
( newline )
( display ( reverse ( map reverse ( list x x ) ) ) )









