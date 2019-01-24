(in-package #:cl-autograd.algebra)


(defgeneric evaluate-operator-value (algebra operator form state))

(defgeneric evaluate-form-value (algebra form state))

(defgeneric evaluate-form-gradient (algebra form state))

(defgeneric evaluate-operator-gradient (algebra form state))

(defgeneric operatorp (algebra name))
