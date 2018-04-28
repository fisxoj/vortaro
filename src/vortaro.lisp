(defpackage :vortaro
  (:use #:cl
        #:nest
        #:alexandria)
  (:export #:run))

(in-package #:vortaro)

(defapp app
  :middlewares (lack.middleware.backtrace:*lack-middleware-backtrace*
                lack.middleware.accesslog:*lack-middleware-accesslog*
                ;; lack.middleware.session:*lack-middleware-session*
                (clack-static-asset-middleware:*clack-static-asset-middleware*
                 :root #P"static/"
                 :path "static/")
                ))

(defroute app "/"
  (render "home.html"))

(defroute app "/thanks"
  (render "thanks.html"))


(defroute app ("/serĉi" :post)
  (handler-case
      (let ((demando (v:str (parameter :demando) :min-length 2 :max-length 100)))
        (if-let ((difino (vortaro/datoj:define demando)))
          (redirect (format nil "/vorto/~a" demando))
          (render "result.html"
                  :demando demando
                  :resultoj (vortaro/datoj:suggest demando))))
    (v:<validation-error> (e)
      (declare (ignore e))
      (render "result.html"
              :error t
              :status 400))))

(defroute app "/vorto/:vorto"
  (let ((vorto (route-parameter :vorto)))
    (if-let ((difinoj (vortaro/datoj:define vorto)))
      (render "word.html"
              :vorto vorto
              :difinoj difinoj)
      (render "word.html"
              :vorto "Vorto ne trovita"
              :status 404))))

(defun run ()
  (vortaro/datoj:load-dict)
  (nest:start app))
