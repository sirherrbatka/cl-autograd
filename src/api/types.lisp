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
