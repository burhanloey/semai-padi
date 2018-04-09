(in-package #:semai-padi)

(defconstant +project-root+ (component-pathname (find-system "semai-padi")))
(defconstant +document-root+ (merge-pathnames "www/" +project-root+))
(defconstant +download-path+ (merge-pathnames "download/" +document-root+))

(defvar *web-server* nil)
(defvar *processes* (make-hash-table))

(defun start-web (&key (port 3000))
  (setf *web-server* (make-instance 'easy-acceptor
                                    :port port
                                    :document-root +document-root+))
  (start *web-server*))

(defun stop-web ()
  (stop *web-server*))

(defun create-random-dirname ()
  "Create random directory name using random salt converted to hex string.
  Hopefully they are unique."
  (byte-array-to-hex-string (make-random-salt)))

(defun download-file (filename &key (dirname (create-random-dirname)))
  (ensure-directories-exist
   (merge-pathnames (format nil "~a/~a" dirname filename)
                    +download-path+)))

(defun remove-dead-processes ()
  "When the process is no longer alive, remove it from the hash table."
  (flet ((remove-dead-process (pid process)
           (format t "~a: ~a~&" pid process)
           (unless (process-alive-p process)
             (remhash pid *processes*))))
    (maphash #'remove-dead-process *processes*)))

(defun split-file (filename
                   &key
                     (archivename (pathname-name filename))
                     (dirname "")
                     (size "100m"))
  "Split file using 7zip. SIZE is a string including the unit [b|k|m|g]."
  (let* ((dirpath (merge-pathnames (format nil "~a/" dirname)
                                   +download-path+) )
         (process (launch-program (list "7z" "a"
                                        (format nil "-v~a" size)
                                        (format nil "~a.7z" archivename)
                                        filename)
                                  :directory dirpath))
         (key (format nil "~a-~a"
                      (process-info-pid process)
                      (get-universal-time))))
    (setf (gethash key *processes*) process)))

(define-easy-handler (download :uri "/download") ()
  (case (request-method*)
    (:get
     (format nil "~a~&" (content-type*)))
    (otherwise
     (setf (return-code*) +http-not-found+)
     nil)))
