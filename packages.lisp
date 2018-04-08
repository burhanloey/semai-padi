(in-package :cl-user)

(defpackage #:semai-padi
  (:use :cl :asdf :hunchentoot :ironclad)
  (:export #:start-web
           #:stop-web))
