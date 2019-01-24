(in-package #:cl-autograd.evaluation)


(defgeneric evaluate-form-value (algebra form state))

(defgeneric evaluate-form-gradient (algebra form state))
