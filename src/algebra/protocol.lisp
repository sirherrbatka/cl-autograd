(in-package #:cl-autograd.algebra)


(defgeneric evaluate-operator-value (algebra operator form arguments))

(defgeneric evaluate-form-value (algebra form arguments))
