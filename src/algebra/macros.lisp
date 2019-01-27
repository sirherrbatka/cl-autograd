(in-package #:cl-autograd.algebra)


(defmacro define-operator ((algebra-type operator-name
                            arguments weights value)
                           value-form
                           weight-form)
  (with-gensyms (!operator !state !form)
    `(progn
       (defmethod inline-operator-value ((algebra ,algebra-type)
                                         (,!operator (eql ',operator-name))
                                         ,!form
                                         ,!state)
         (bind ((,arguments
                 (iterate
                   (for i
                        from (~> ,!form
                                 cl-autograd.graph:forms-count
                                 1-)
                        downto 0)
                   (collect (~>> ,!form
                                 (cl-autograd.graph:form-at _ i)
                                 cl-autograd.graph:index
                                 (list 'cl-autograd.tape:value-at
                                       ,!state))
                     at start))))
           (declare (ignorable ,arguments))
           `(setf (cl-autograd.tape:value-at ,,!state
                                             ,(cl-autograd.graph:index ,!form))
                  ,,value-form)))
       (defmethod inline-operator-weight ((algebra ,algebra-type)
                                          (,!operator (eql ',operator-name))
                                          ,!form
                                          ,!state)
         (bind ((,value `(cl-autograd.tape:value-at (cl-autograd.graph:index ,,!form)
                                                    ,,!state))
                (,arguments
                 (iterate
                   (for i
                        from (~> ,!form
                                 cl-autograd.graph:forms-count
                                 1-)
                        downto 0)
                   (collect (~>> ,!form
                                 (cl-autograd.graph:form-at i)
                                 cl-autograd.graph:index
                                 (list 'cl-autograd.tape:value-at
                                       ,!state _))
                     at start)))
                (,weights
                 (iterate
                   (for i
                        from (~> ,!form
                                 cl-autograd.graph:forms-count
                                 1-)
                        downto 0)
                   (for child = (cl-autograd.graph:form-at ,!form i))
                   (for parent-position = (iterate
                                            (for i from 0 below (cl-autograd.graph:parents-count child))
                                            (for parent = (cl-autograd.graph:parent-at child i))
                                            (finding i such-that (eq parent ,!form))))
                   (collect (~>> child
                                 cl-autograd.graph:index
                                 (list 'cl-autograd.tape:weight-at
                                       ,!state _ parent-position))
                     at start))))
           (declare (ignorable ,value ,arguments ,weights))
           ,weight-form)))))
