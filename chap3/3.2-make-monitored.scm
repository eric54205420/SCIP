;; to write a fn named "make-monitored" that can trace the fn
;; and return the no. of the fn been called
;;
;; sub-procedures
;; 
;; "how-many-calls?" => return the counter
;;
;; "reset-counter!"  => reset the counter
;; ===============================================================
;; ie.
;;
;; > ( define a ( make-monitored sqrt ))
;;
;; > ( a 100 ) 
;;
;; > 10
;;
;; > ( a 'how-many-calls? )
;;
;; > 2
;;================================================================

( define make-monitored
	 ( lambda ( fn-name )
		  ( let (( counter 0 ))
			( define how-many-calls?
				 ( lambda ()
					  counter ))

			( define reset-counter!
				 ( lambda ()
					  ( set! counter 0 )))

			( define dispatch
				 ( lambda ( mf )
					  ( cond
					    (( eq? mf 'how-many-calls? )	( how-many-calls? ))
					    (( eq? mf 'reset-counter!  )	( reset-counter!  ))
					    ( else				( begin
										  	( display ( fn-name mf ) )
											( newline )
											( set! counter ( + counter 1 )))))))
		dispatch )))
