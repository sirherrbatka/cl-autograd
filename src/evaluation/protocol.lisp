(in-package #:cl-autograd.evaluation)


(defgeneric inline-form-value (algebra form state))


(defgeneric inline-form-weight (algebra form state))


(defgeneric inline-form-gradient (form state)
  (:method ((form cl-autograd.graph:form)
            (state symbol))
    `(setf (cl-autograd.tape:gradient-at ,state
                                         ,(cl-autograd.graph:index form))
           (+
            ,@(iterate
                (with index = (cl-autograd.graph:index form))
                (for i from 0 below (cl-autograd.graph:parents-count form))
                (for parent = (cl-autograd.graph:parent-at form i))
                (for parent-index = (cl-autograd.graph:index parent))
                (for weight = `(cl-autograd.tape:weight-at ,state ,index ,i))
                (for parent-gradient = `(cl-autograd.tape:gradient-at
                                         ,state
                                       ,parent-index))
                (collecting `(* (the 'double-float ,weight)
                                (the 'double-float ,parent-gradient))))))))


(defgeneric make-state (expression))
