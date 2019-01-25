(in-package #:cl-autograd.algebra)


(defmacro define-operator ((algebra-type operator-name arguments)
                           value-function
                           value-form)
  (with-gensyms (!operator !state !form)
    `(progn
       (defmethod evaluate-operator-value ((algebra ,algebra-type)
                                           (,!operator (eql ',operator-name))
                                           ,!form
                                           ,!state)
         (bind ((,arguments (iterate
                              (for i
                                   from (~> ,!form
                                            cl-autograd.graph:forms-count
                                            1-)
                                   downto 0)
                              (collect (~>> ,!form
                                            (cl-autograd.graph:form-at i)
                                            cl-autograd.graph:index
                                            (cl-autograd.tape:value-at ,!state))
                                at start))))
           ,value-function))
       (defmethod inline-operator-value ((algebra ,algebra-type)
                                         (,!operator (eql ',operator-name))
                                         ,!form
                                         ,!state)
         (bind ((,arguments (iterate
                              (for i
                                   from (~> ,!form
                                            cl-autograd.graph:forms-count
                                            1-)
                                   downto 0)
                              (collect (~>> ,!form
                                            (cl-autograd.graph:form-at i)
                                            cl-autograd.graph:index
                                            (list 'cl-autograd.tape:value-at _ ',!state))
                                at start))))
           ,value-form)))))
