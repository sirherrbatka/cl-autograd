(in-package #:cl-autograd.algebra)


(defmacro define-operator ((algebra-type operator)
                           value-function
                           value-inline-form
                           gradient-function
                           gradient-inline-form))
