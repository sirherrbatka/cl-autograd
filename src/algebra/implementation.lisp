(in-package #:cl-autograd.algebra)


(defmethod operatorp ((algebra standard-algebra) name)
  (and (symbolp name)
       (~>> algebra operators (gethash name) not null)))


(defmethod register-operator ((algebra standard-algebra) (name symbol))
  (setf (~>> algebra operators (gethash name)) name))


(defmethod evaluate-form-value ((algebra fundamental-algebra)
                                (form cl-autograd.graph:form)
                                state)
  (case (cl-autograd.graph:form-type form)
    (list
     (evaluate-operator-value algebra
                              (~> form
                                  cl-autograd.graph:content
                                  first)
                              form
                              state))
    (number
     (setf (value-at state (cl-autograd.graph:index form))
           (cl-autograd.graph:content form)))))
