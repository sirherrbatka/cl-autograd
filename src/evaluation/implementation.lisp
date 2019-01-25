(in-package #:cl-autograd.evaluation)


(defmethod evaluate-form-value (algebra
                                (form cl-autograd.graph:form)
                                state)
  (case (cl-autograd.graph:form-type form)
    (list
     (~> form
         cl-autograd.graph:content
         first
         (cl-autograd.algebra:evaluate-operator-value algebra
                                                      _
                                                      form
                                                      state)))
    (number
     (setf (~>> form cl-autograd.graph:index (cl-autograd.tape:value-at state))
           (cl-autograd.graph:content form)))))
