(in-package #:cl-autograd)


(defclass expression ()
  ((%algebra :reader algebra
             :initarg :algebra)
   (%graph :reader graph
           :initarg :graph)
   (%value-function :reader value-function
                    :initarg :value-function)
   (%gradient-function :reader gradient-function
                       :initarg :gradient-function)))


(defun make-expression (lambda-list form
                        &key (algebra cl-autograd.algebra:*standard-algebra*))
  (make 'expression
        :algebra algebra
        :graph (cl-autograd.graph:make-expression lambda-list form)))


(defparameter *expression* (make-expression '(a b) '(+ a b)))
(~> *expression* (value '(1.0d0 2.0d0)) print)
