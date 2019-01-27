(in-package #:cl-autograd.evaluation)


(defmethod inline-form-value (algebra
                              (form cl-autograd.graph:form)
                              state)
  (case (cl-autograd.graph:form-type form)
    (list
     (~> form
         cl-autograd.graph:content
         first
         (cl-autograd.algebra:inline-operator-value algebra
                                                    _
                                                    form
                                                    state)))
    (number
     `(setf (cl-autograd.tape:value-at ,state
                                       ,(cl-autograd.graph:index form))
            ,(cl-autograd.graph:content form)))))


(defmethod inline-form-weight (algebra
                               (form cl-autograd.graph:form)
                               state)
  (case (cl-autograd.graph:form-type form)
    (list
     (~> form
         cl-autograd.graph:content
         first
         (cl-autograd.algebra:inline-operator-weight
          algebra _ form state)))
    (symbol nil)
    (number nil)))


(defmethod make-state ((expression cl-autograd.graph:expression))
  (cl-autograd.tape:make-state
   (cl-autograd.graph:forms-count expression)
   (iterate outer
     (for i from 1
          below (cl-autograd.graph:forms-count expression))
     (for form = (cl-autograd.graph:form-at expression i))
     (maximize (cl-autograd.graph:parents-count form)))))
