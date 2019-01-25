(in-package #:cl-user)


(asdf:defsystem cl-autograd
  :name "cl-autograd"
  :version "0.0.0"
  :license "BSD simplified"
  :author "Marek Kochanowicz"
  :maintainer "Marek Kochanowicz"
  :depends-on (:iterate       :alexandria
               :serapeum      :prove
               :prove-asdf    :closer-mop
               :metabang-bind :cl-data-structures)
  :defsystem-depends-on (:prove-asdf)
  :serial T
  :pathname "src"
  :components ((:file "aux-package")
               (:module "graph"
                :components ((:file "package")
                             (:file "errors")
                             (:file "protocol")
                             (:file "types")
                             (:file "methods")))
               (:module "tape"
                :components ((:file "package")
                             (:file "macros")
                             (:file "types")))
               (:module "algebra"
                :components ((:file "package")
                             (:file "macros")
                             (:file "protocol")
                             (:file "types")
                             (:file "implementation")))
               (:module "evaluation"
                :components ((:file "package")
                             (:file "macros")
                             (:file "protocol")
                             (:file "types")
                             (:file "implementation")))
               ))
