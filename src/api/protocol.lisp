(in-package #:cl-autograd)


(defgeneric inline-value (expression state))

(defgeneric inline-binding (expression state arguments))

(defgeneric inline-gradient (expression state gradient))

(defgeneric compile-expression (expression arguments))

(defgeneric value (expression values &optional state))
