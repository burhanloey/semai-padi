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
   (merge-pathnames +download-path+
                    (format nil "~a/~a/" dirname filename))))

(defun remove-dead-processes ()
  "When the process is no longer alive, remove it from the hash table."
  (flet ((remove-dead-process (pid process)
           (unless (uiop:process-alive-p process)
             (remhash pid *processes*))))
    (maphash #'remove-dead-process *processes*)))

(defun split-file ()
  (let* ((process (uiop:launch-program '("7z" "a" "jumanji.7z" "jumanji_2.mp4")
                                       :directory +download-path+))
         (key (format nil "~a-~a"
                      (uiop:process-info-pid process)
                      (get-universal-time))))
    (setf (gethash key *processes*) process)))

(define-easy-handler (download :uri "/download") ()
  (case (request-method*)
    (:get
     (format nil "~a~&" (content-type*)))
    (otherwise
     (setf (return-code*) +http-not-found+)
     nil)))
