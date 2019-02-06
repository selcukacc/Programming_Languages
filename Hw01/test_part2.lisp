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
; It pushes first element of the list1 to end of the list2 recursively.
(defun merge-helper (list1 list2)
	(push (car list2) (cdr (last list1)))
	(setf list2 (cdr list2)) ;; modifies the list2
	(if (not (null list2)) ;; base case of function
		(merge-helper list1 list2)
		(return-from merge-helper list1)
	)
)

; It takes two lists as inputs and merges the lists.
(defun merge-list(list1 list2)
	;; It controls whether the parameters are list.
	(if (and (listp list1) (listp list2)) 
		(progn
			(return-from merge-list (merge-helper list1 list2))
		)
		(progn
			(if (listp list1) ;; If list2 is not a list, returns list1.
				(return-from merge-list list1))
			(if (listp list2) ;; If list1 is not a list, returns list2.
				(return-from merge-list list2))
			;; If both of them is not a list, returns nil.
			(return-from merge-list nil) 
		)
	)
)


;; MAIN FUNCTION
(defun main ()
  (with-open-file (stream #p"input_part2.csv")
    (loop :for line := (read-csv-line stream) :while line :collect
      (format t "~a~%"
      ;; CALL YOUR (MAIN) FUNCTION HERE
      	(merge-list (read-from-string (nth 0 line)) (read-from-string (nth 1 line)))


      )
    )
  )
)

;; CALL MAIN FUNCTION
(main)
