#+sb-core-compression
(defmethod asdf:perform ((o asdf/bundle:program-op) (c asdf:system))
  (uiop:dump-image (asdf:output-file o c) :executable t :compression 9))

(format t "~& BUILDING STATIC BINARY ~%")
(declaim (optimize speed space))

(qlot:install "vortaro")

(let ((cwd (uiop:getcwd)))
  (qlot:with-local-quicklisp (cwd :central-registry (list cwd))
    (qlot:quickload :vortaro)
    (asdf:make :vortaro)))
