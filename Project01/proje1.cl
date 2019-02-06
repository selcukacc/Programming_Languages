; Name: Islam Goktan Selcuk
; Student Id: 141044071
; Usage: (lexer "filename.txt") --> You need to write this statement the last line.

(setf operators '("+" "-" "/" "*" "(" ")" "**"))

(setf keywords '("and" "or" "not" "equal" "append" "concat" "set"
				 "deffun" "for" "while" "if" "exit"))

(setf digits '(#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9))

(setf binaryValues '("true" "false"))

; It is used for search in list.
(defun is-contain (value list) 
		(if (null list) (return-from is-contain nil))
		(if (equal value (car list))
			(return-from is-contain T) 
			(is-contain value (cdr list))
		)
)

(defun is-integer-helper (string-value) 
	(if (= 0 (length string-value)) 
		(return-from is-integer-helper t)
		
	)
	(if (is-contain (char string-value 0) digits) 
		(is-integer-helper (subseq string-value 1))
		(return-from is-integer-helper nil)		
	)
)

(defun is-integer (string-value)
	(if (> (length string-value) 0) 
		(if (equal (char string-value 0) #\-)
		(setf string-value (subseq string-value 1)))
	)
	
	(if (= 0 (length string-value))
		(return-from is-integer nil)
		(return-from is-integer (is-integer-helper string-value))
	)
)

(defun is-identifier (string-value) 
	(if (is-contain string-value keywords) 
		(return-from is-identifier nil))

	(setf len (- (length string-value) 1))
	(loop for x from 0 to len do
		(if (not (or (and (char>= (char string-value x) #\a) 
					 (char<= (char string-value x) #\z)) 
				     (and (char>= (char string-value x) #\A) 
					 (char<= (char string-value x) #\Z))
				 )
			)
			(return-from is-identifier nil)
		)
	)
	(return-from is-identifier t)
)

(defun str-left-trim (string-value) 
	(setf len (- (length string-value) 1))
	(setf first 0)
	(loop for x from 0 to len do
		(if (or (equal (char string-value x) #\TAB)
				(equal (char string-value x) #\space))
			(setf first (+ 1 first))
			(return-from str-left-trim (subseq string-value first (+ len 1)))
		)
	)
	(return-from str-left-trim (subseq string-value first (+ len 1)))
)

(defun str-right-trim (string-value)
	(setf len (- (length string-value) 1))
	(setf index 0)
	(loop for x from 0 to len do
		(if (and (not (equal (char string-value x) #\TAB))
				(not (equal (char string-value x) #\space)))
			(setf index (+ 1 index))
			(return-from str-right-trim (subseq string-value 0 x))
		)
	)
	(return-from str-right-trim (subseq string-value 0 index))
)

; Deletes tab and space characters.
(defun str-trim (string-value) 
	(setf result (str-left-trim string-value))
	(setf result (str-right-trim result))
	(return-from str-trim result)
)

; It leaves spaces to left and right side of the operators('(' and ')'). 
(defun replace-string (string-value)
	(setf result " ")
	(setf len (- (length string-value) 1))

	(loop for x from 0 to len do
		
		(if (or (equal (subseq string-value x (+ x 1)) ")")
				(equal (subseq string-value x (+ x 1)) "("))
			(progn
				(if (equal (subseq string-value x (+ x 1)) "(")
					(setf result (concatenate 'string result " ( "))
					(setf result (concatenate 'string result " ) "))
				)
			)
			(setf result (concatenate 'string result (subseq string-value x (+ x 1))))
		)
	)
	(return-from replace-string result)
)

; Splits given string according to given delimeter
(defun split-string (string-value delimeter) 
	(setf string-value (replace-string string-value))
	(setf len (- (length string-value) 1)) ; length of string
	(setf result nil) ; result of the function
	(setf first 0)
	(setf last 1)

	(loop for x from 0 to len do
		(if (or (equal (subseq string-value x (+ x 1)) delimeter); 
			(equal (subseq string-value x (+ x 1)) ")")
			(equal (char string-value x) #\TAB))
			(progn
				(setf last x)
				(setf substr (subseq string-value first last))
				(setf first (+ 1 last))
				
				(if (not (equal substr ""))
					(push substr result)))
		) 

		(if (and (> last 0)
			(equal (subseq string-value (- last 1) last) ")"))
			(progn
				(push ")" result)
				(setf last (+ last 1))))
	)
	(setf result (reverse result))
	(return-from split-string result)
)

(defun lexer (filename)
	(setf allTokens nil)
	(setf res nil)
	(let ((in (open filename :if-does-not-exist nil)))
		(when in 
			(loop for line = (read-line in nil)
				while line do 
					(setf line (string-trim " " line)) 
					(setf line (split-string line " "))
					
					(loop for x in line do
						(setf temp nil)
						(setf x (str-trim x))
						(push x temp)
						(cond ( (is-contain x operators)
								(push "operator" temp)
								(push temp res)
							  )
							  ( (is-contain x keywords)
							  	(push "keyword" temp)
								(push temp res)
							  )
							  ( (is-contain x binaryValues)
							  	(push "binary-value" temp)
								(push temp res)
							  )	
							  ( (is-integer x)
							  	(push "integer" temp)
								(push temp res)
							  )
							  ( (equal "" x)
							  	
							  )
							  ( (is-identifier x)
							  	(push "identifier" temp)
								(push temp res)
							  )	
							  (t (push "unknown" temp)
								 (push temp res))						  
						)
					)
					(setf allTokens (append allTokens (reverse res)))
					(setf res nil)
			)
			(close in)
		)
	)
	(return-from lexer allTokens)
)

;(lexer "input.txt")

(print (lexer "input.txt"))