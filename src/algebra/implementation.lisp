(in-package #:cl-autograd.algebra)


(defmethod operatorp ((algebra standard-algebra) name)
  (and (symbolp name)
       (~>> algebra operators (gethash name) not null)))
