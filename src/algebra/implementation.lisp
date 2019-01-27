(in-package #:cl-autograd.algebra)


(defmethod operatorp ((algebra standard-algebra) name)
  (and (symbolp name)
       (~>> algebra operators (gethash name) not null)))


(defmethod register-operator (algebra (name symbol))
  (setf (~>> algebra operators (gethash name)) name))


(define-operator
    (standard-algebra + args weights value)
    (cons '+ args)
    (mapcar (lambda (x) `(setf ,x 1.0d0)) weights))
(register-operator *standard-algebra* '+)


(define-operator
    (standard-algebra * args weights value)
    (cons '* args)
    (cons 'progn
      (iterate
        (with args.weights = (mapcar #'list* args weights))
        (for a.w in args.weights)
        (for list = (remove a.w args.weights))
        (collecting `(setf ,(cdr a.w) (+ ,@(mapcar #'car list)))))))
(register-operator *standard-algebra* '*)
