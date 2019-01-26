(in-package #:cl-autograd)


(defgeneric inline-value (expression state))

(defgeneric inline-binding (expression state &rest arguments))

(defgeneric inline-gradient (expression state gradient))

(defgeneric compile-expression (expression))
