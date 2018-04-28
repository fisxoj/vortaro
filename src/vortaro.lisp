(defpackage :vortaro
  (:use #:cl
        #:nest))

(in-package #:vortaro)

(defapp app
  :middlewares (lack.middleware.backtrace:*lack-middleware-backtrace*
                lack.middleware.accesslog:*lack-middleware-accesslog*
                lack.middleware.session:*lack-middleware-session*
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
        (render "result.html"
                :demando demando))
    (v:<validation-error> (e)
      (declare (ignore e))
      (render "result.html"
              :error t
              :status 400))))
