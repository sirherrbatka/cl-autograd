(in-package #:cl-autograd.graph)


(defclass forms-container ()
  ((%forms :initarg :forms
           :initform nil
           :type (or null vector)
           :writer write-forms
           :reader forms)))


(defclass expression (forms-container)
  ((%lambda-list :reader lambda-list
                 :type list
                 :initarg :lambda-list)))


(defclass form (forms-container)
  ((%parents :initarg :parents
             :type vector
             :reader parents
             :writer write-parents
             :initform (vect))
   (%index :initarg :index
           :reader index
           :writer write-index
           :initform 0
           :type 'fixnum)
   (%content :initarg :content
             :type (or symbol list number)
             :reader content)
   (%argument :initarg :argument
              :initform nil
              :writer write-argument
              :reader argument)))


(defclass argument (forms-container)
  ((%name :initarg :name
          :reader name)))


(defun gather-all-subforms (lambda-list tree)
  (let ((vector (vect (make 'form
                            :index 0
                            :content '=)))
        (arguments-table (make-hash-table)))
    (iterate
      (for l in lambda-list)
      (for form = (make 'form
                        :content (name l)
                        :argument l))
      (setf (gethash (name l) arguments-table)
            form)
      (write-forms (vector form) l))
    (labels ((gather (node)
               (check-type node (or symbol list number))
               (let ((form nil))
                 (if (and (symbolp node)
                          (find node lambda-list
                                :key #'name))
                     (setf form (gethash node arguments-table))
                     (progn
                       (setf form (make 'form
                                        :index (length vector)
                                        :content node))
                       (vector-push-extend form vector)
                       (unless (atom node)
                         (write-forms
                          (map 'vector
                               (lambda (sub-node)
                                 (lret ((result (gather sub-node)))
                                   (vector-push-extend form
                                                       (parents result))))
                               (rest node))
                          form))))
                 form)))
      (gather tree)
      (iterate
        (for (key value) in-hashtable arguments-table)
        (write-index (length vector) value)
        (vector-push-extend value vector))
      (write-forms (vector (aref vector 1))
                   (first-elt vector))
      (vector-push-extend (aref vector 1)
                          (parents result)))
      vector)))


(defun make-expression (lambda-list form)
  (check-type lambda-list list)
  (when (null form)
    (error 'empty-body :body form))
  (iterate
    (for s in lambda-list)
    (check-type s symbol)
    (when (null s)
      (error 'lambda-list-nil
             :lambda-list lambda-list)))
  (unless (= (length lambda-list)
             (~> lambda-list remove-duplicates length))
    (error 'lambda-list-error :lambda-list lambda-list))
  (bind ((wrapped-lambda-list (mapcar (lambda (symbol)
                                        (make 'argument
                                              :name symbol
                                              :forms (vect)))
                                      lambda-list))
         (subforms-sequence (gather-all-subforms wrapped-lambda-list
                                                 form)))
    (iterate
      (for w in wrapped-lambda-list)
      (when (~> w forms emptyp)
        (warn 'warning "Argument ~a defined but not used!"
              (name w))))
    (make 'expression
          :forms subforms-sequence
          :lambda-list wrapped-lambda-list)))


(defparameter *testing* (make-expression '(a b) '(* a b (+ a b))))
