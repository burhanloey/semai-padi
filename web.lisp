(in-package #:semai-padi)

(defvar *web-server* nil)
(defvar *project-path* (component-pathname (find-system "semai-padi")))

(defun find-document-root ()
  (merge-pathnames-as-directory *project-path* #p"www/"))

(defun start-web (&key (port 3000))
  (setf *web-server* (make-instance 'easy-acceptor
                                    :port port
                                    :document-root (find-document-root)))
  (start *web-server*))

(defun stop-web ()
  (stop *web-server*))

;; Download/Upload
(define-easy-handler (download :uri "/download") ()
  (format nil "Downloading..."))
