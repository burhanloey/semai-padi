(in-package :cl-user)

(asdf:defsystem "semai-padi"
  :description "Kotak untuk menyemai benih dan muat turun secara langsung."
  :version "0.0.1"
  :license "GPL v3"
  :depends-on (:hunchentoot
               :cl-fad)
  :components ((:file "packages")
               (:file "web")))
