(load "csv-parser.lisp")
(in-package :csv-parser)

;; (read-from-string STRING)
;; This function converts the input STRING to a lisp object.
;; In this code, I use this function to convert lists (in string format) from csv file to real lists.

;; (nth INDEX LIST)
;; This function allows us to access value at INDEX of LIST.
;; Example: (nth 0 '(a b c)) => a

;; !!! VERY VERY VERY IMPORTANT NOTE !!!
;; FOR EACH ARGUMENT IN CSV FILE
;; USE THE CODE (read-from-string (nth ARGUMENT-INDEX line))
;; Example: (mypart1-funct (read-from-string (nth 0 line)) (read-from-string (nth 1 line)))

;; DEFINE YOUR FUNCTION(S) HERE
; It creates a list which has the given number at the given index.
(defun create-list (list number index)
	(if (= index 0) ; Base case; when index is zero, it puts the number.
		(progn
			;; If created list is empty, pushes the number front of the list.		
			(if (null list1) 
				(push number list1)
				(push number (cdr (last list1)))
			)
			(setf list1 (append list1 list)) ; merges created list and modified list
			(return-from create-list list1)
		)
	)
	(if (null list1) 
		(push (car list) list1)
		(push (car list) (cdr (last list1)))
	)
	
	(create-list (cdr list) number (- index 1))
)

(defun insert-n (list number index)
	(setf list1 nil) ;; result list
	(create-list list number index) ;; helper function
	(return-from insert-n list1)
)


;; MAIN FUNCTION
(defun main ()
  (with-open-file (stream #p"input_part3.csv")
    (loop :for line := (read-csv-line stream) :while line :collect
      (format t "~a~%"
      ;; CALL YOUR (MAIN) FUNCTION HERE
      	(insert-n (read-from-string (nth 0 line)) 
      				 (read-from-string (nth 1 line)) 
      				 (read-from-string (nth 2 line)))
      )
    )
  )
)

;; CALL MAIN FUNCTION
(main)
