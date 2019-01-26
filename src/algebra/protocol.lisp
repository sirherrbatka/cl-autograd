(in-package #:cl-autograd.algebra)


(defgeneric inline-operator-weight (algebra operator form state))

(defgeneric inline-operator-value (algebra operator form state))

(defgeneric operatorp (algebra name))

(defgeneric register-operator (algebra name))
