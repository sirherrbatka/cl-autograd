(in-package #:cl-autograd.graph)


(defmethod form ((expression expression))
  (~> expression forms
      first-elt content))


(defmethod form-at ((container forms-container) index)
  (~> container forms (elt index)))


(defmethod forms-count ((container forms-container))
  (~> container forms length))


(defmethod parents-count ((form form))
  (~> form parents length))


(defmethod parent-at ((form form) index)
  (~> form parents (elt index)))


(defmethod print-object ((object argument) stream)
  (print-unreadable-object (object stream
                            :identity t)
    (princ (name object) stream)))


(defmethod print-object ((object form) stream)
  (print-unreadable-object (object stream
                            :identity t)
    (format stream "~a~:[~;!~]" (content object) (argumentp object))))


(defmethod print-object ((object expression) stream)
  (print-unreadable-object (object stream
                            :identity t
                            :type 'expression)
    (format stream "(~{~a~^ ~}) -> ~A"
            (~>> object lambda-list (mapcar #'name))
            (form object))))


(defmethod argumentp ((form form))
  (not (null (argument form))))


(defmethod form-type ((form form))
  (etypecase (content form)
    (list 'list)
    (number 'number)
    (symbol 'symbol)))
