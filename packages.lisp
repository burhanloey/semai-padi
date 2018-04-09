(in-package :cl-user)

(defpackage #:semai-padi
  (:use :cl)
  (:import-from #:asdf
                #:component-pathname
                #:find-system)
  (:import-from #:hunchentoot
                #:+http-not-found+
                #:content-type*
                #:define-easy-handler
                #:easy-acceptor
                #:request-method*
                #:return-code*)
  (:import-from #:ironclad
                #:byte-array-to-hex-string
                #:make-random-salt)
  (:import-from #:uiop
                #:launch-program
                #:process-alive-p
                #:process-info-pid)
  (:export #:start-web
           #:stop-web))
