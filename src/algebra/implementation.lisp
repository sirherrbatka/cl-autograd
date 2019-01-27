(in-package #:cl-autograd.algebra)


(defmethod operatorp ((algebra standard-algebra) name)
  (and (symbolp name)
       (~>> algebra operators (gethash name) not null)))


(defmethod register-operator (algebra (name symbol))
  (setf (~>> algebra operators (gethash name)) name))


(define-operator
    (standard-algebra + args weights value)
    (cons '+ args)
    (mapcar (constantly 1.0d0) weights))

(register-operator *standard-algebra* '+)
