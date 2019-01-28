(in-package #:cl-autograd)


(defclass expression ()
  ((%expression-type :reader expression-type
                     :type symbol
                     :initarg :expression-type)
   (%algebra :reader algebra
             :initarg :algebra)
   (%graph :reader graph
           :initarg :graph)
   (%value-function :reader value-function
                    :initarg :value-function)
   (%gradient-function :reader gradient-function
                       :initarg :gradient-function)))


(defun make-expression (lambda-list form
                        &key (algebra cl-autograd.algebra:*standard-algebra*)
                          (expression-type 'lambda))
  (check-type expression-type (member lambda vector))
  (make 'expression
        :algebra algebra
        :graph (cl-autograd.graph:make-expression lambda-list form)
        :expression-type expression-type))


(defparameter *expression* (make-expression '(x y) '(+ (* x y) (sin x))
                                            :expression-type 'vector))
(progn
  (defparameter *state* (make-state *expression*))
  (~> *expression* (value '(50.5d0 30.2d0) *state*) print)
  (setf (cl-autograd.tape:gradient-at *state* 0) 1.0d0)
  (gradient *expression* *state*))

(print
 (- (cl-autograd.tape:gradient-at *state* 4) 30.2d0 (cos 50.5d0)))
