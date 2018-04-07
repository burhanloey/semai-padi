(in-package :cl-user)

(defpackage #:semai-padi
  (:use :cl :asdf :hunchentoot :cl-fad)
  (:export #:start-web
           #:stop-web))
