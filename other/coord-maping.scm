;; see also
;; sicp-pict/prmpnt.scm
;; sicp-pict/hutils.scm
;; sicp-pict/hend.scm

;http://eprints.soton.ac.uk/257577/1/funcgeo2.pdf
;http://users.ecs.soton.ac.uk/ph/funcgeo.pdf

;; racket only

(require (lib "racket/draw"))
(require racket/class)

(define target (make-bitmap 100 100))
(define dc (new bitmap-dc% [bitmap target]))

;; Vectors

(define (make-vect x y)
  (cons x y))

(define (xcor-vect vect)
  (car vect))

(define (ycor-vect vect)
  (cdr vect))

(define (add-vect a b)
  (make-vect (+ (xcor-vect a) (xcor-vect b))
             (+ (ycor-vect a) (ycor-vect b))))

(define (sub-vect a b)
  (make-vect (- (xcor-vect a) (xcor-vect b))
             (- (ycor-vect a) (ycor-vect b))))

(define (scale-vect s a)
  (make-vect (* (xcor-vect a) s)
             (* (ycor-vect a) s)))

;; Frames

(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))

(define (origin-frame frame)
  (car frame))

(define (edge1-frame frame)
  (cadr frame))

(define (edge2-frame frame)
  (caddr frame))

;; Coords mapping

(define (frame-coord-map frame)
  (lambda (v)
    (add-vect 
     (origin-frame frame)
     (add-vect (scale-vect (xcor-vect v)
                           (edge1-frame frame))
               (scale-vect (ycor-vect v)
                           (edge2-frame frame))))))

;; Segments

(define (make-segment v1 v2)
  (cons v1 v2))

(define (start-segment v1)
  (car v1))

(define (end-segment v2)
  (cdr v2))

;; Painters

(define (my-draw-line v1 v2)
  (send dc draw-line
        (xcor-vect v1) (ycor-vect v1)
        (xcor-vect v2) (ycor-vect v2)))

(define (segments->painter segment-list)
  (lambda (frame)
    (for-each
     (lambda (segment)
       (my-draw-line
        ((frame-coord-map frame) (start-segment segment))
        ((frame-coord-map frame) (end-segment segment))))
     segment-list)))

;; Painting
;; a.

(define a-painter (segments->painter 
                   (list (make-segment 
                          (make-vect 0 0) 
                          (make-vect 5 0))
                         (make-segment 
                          (make-vect 0 0) 
                          (make-vect 0 5))
                         (make-segment
                          (make-vect 0 5)
                          (make-vect 5 0))
                         (make-segment
                          (make-vect 0 0)
                          (make-vect 5 5)))))

(send dc clear)
(a-painter (make-frame (make-vect 0 0) (make-vect 0 99) (make-vect 99 0)))
(send target save-file "d:\\ex2-49-a.png" 'png)

(send dc clear)
( a-painter ( make-frame ( make-vect 0 0 ) ( make-vect 30 0 ) ( make-vect  0 30) ) )
(send target save-file "d:\\ex2-49-a2.png" 'png)

(define (transform-painter painter origin corner1 corner2)
  (lambda (frame)
    (let ((m (frame-coord-map frame)))
      (let ((new-origin (m origin)))
        (painter
         (make-frame new-origin
                     (sub-vect (m corner1) new-origin)
(sub-vect (m corner2) new-origin)))))))

(define a-painter (segments->painter 
                   (list (make-segment 
                          (make-vect 0 0) 
                          (make-vect 50 0))
                         (make-segment 
                          (make-vect 0 0) 
                          (make-vect 0 50))
                         (make-segment
                          (make-vect 0 50)
                          (make-vect 50 0))
                         (make-segment
                          (make-vect 0 0)
                          (make-vect 50 50)))))

( define frame1
	( make-frame 
		( make-vect 0 0 )
		( make-vect 0 10 )
		( make-vect 10 0 ) ) )
( define frame2
	( make-frame 
		( make-vect 50 50 )
		( make-vect 10 5 )
		( make-vect 5 10 ) ) )
( define frame3
	( make-frame
		( make-vect 10 0 )
		( make-vect 10 10 )
		( make-vect 0 0 ) ) ) 

(send dc clear)
;(( transform-painter a-painter ( make-vect 0 0 ) ( make-vect 10 0 ) ( make-vect 0 10 ) ) frame1 )
;(( transform-painter a-painter ( make-vect 0 0 ) ( make-vect 10 0 ) ( make-vect 0 10 ) ) frame2 )
(( transform-painter a-painter ( make-vect 0 0 ) ( make-vect 10 0 ) ( make-vect 0 10 ) ) frame3 )
(send target save-file "d:\\ex2-49-a3.png" 'png)
