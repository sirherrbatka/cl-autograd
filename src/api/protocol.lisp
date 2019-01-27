(in-package #:cl-autograd)


(defgeneric inline-value (expression state))

(defgeneric inline-binding (expression state arguments))

(defgeneric inline-gradient (expression state))

(defgeneric inline-weight (expression state))

(defgeneric compile-expression (expression arguments))

(defgeneric compile-gradient (expression))

(defgeneric value (expression values &optional state))

(defgeneric gradient (expression state))

(defgeneric make-state (expression))
