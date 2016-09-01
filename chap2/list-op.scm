; p 82 -91
( define nil '() )

( define ( list-ref items n )
	 ( cond
	   	( ( = n 0 )	( car items ) )
		( else ( list-ref (  cdr items ) ( - n 1 ) ) )
		) )


;( define squares ( list 1 4 9 16 25 ) )
;( display ( list-ref squares 2 ) )


;( define ( length items )
;	 ( cond
;	   	( ( null? items ) 0 )
;		( else 		  ( + 1 ( length ( cdr items ) ) ) )
;		))

( define ( length items )
	 ( define ( iter items len )
		  ( cond
		    	(( null? items ) 	len )
			( else ( iter ( cdr items ) ( + 1 len ) ) ) ) )
	( iter items 0 ) )

( define squares ( list 1 4 9 16 25 ) )
;( display ( length squares ) )

( define ( append list1 list2 )
	 	( cond 
		  	(( null? list1 )	list2 )
			( else ( cons ( car list1 ) ( append ( cdr list1 ) list2 ) ) )
			))

;( define odds ( list 1 3 5 7 ) )
;( display ( append squares odds ) )

( define ( list-pair list1 )
	 ( cond
	   	(( null? ( cdr list1 ) )	list1 )
		( else ( list-pair ( cdr list1 ) ) )
		))

;( display ( list-pair ( list 23 72 149 34 ) ))

;( define ( reverse list1 )
;	 ( cond
;	   	(( null? list1 ) 	'() )
;		( else	( append ( reverse ( cdr list1 ) ) ( cons ( car list1 ) '() ) ) )
;		))

( define ( reverse list1 )
	 ( define ( iter list1 result )
		  ( cond
		    	( ( null? list1 ) 	result )
			( else ( iter ( cdr list1 ) ( cons ( car list1 ) result ) ) )
			) )
	 ( iter list1 '() ) )

;( display ( reverse ( list 1 2 3 4 5 ) ) )

;( define ( scale-list items factor )
;	 ( if ( null? items )
;	      nil
;	      ( cons ( * factor ( car items ) ) ( scale-list ( cdr items ) factor ) ) )
;	 )


( define ( map proc items )
	 ( cond
	   	(( null? items ) '() )
		( else ( cons ( proc ( car items ) ) ( map proc ( cdr items ) ) ) ) )
	 )

( define ( scale-list items factor )
	 ( map ( lambda ( x ) ( * x factor ) ) items ) )

;( display ( scale-list ( list 1 2 3 4 5 ) 10 ) )

;( display ( map ( lambda ( x ) ( * x x ) ) ( list 1 2 3 4 5 ) ) )
;( display ( map + ( list 1 2 3 ) ( list 40 50 60 ) ( list 700 800 900 ) ) ) ; default map, more general


( define ( for-each proc items )
	 ( cond
	   	(( null? items )	"done" )
		( else
		  	( proc ( car items ) )
			( for-each proc ( cdr items ) ) ) )
	)

( for-each display ( list 1 2 3 4 5 ) )


