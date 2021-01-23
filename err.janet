(defmacro ctx [msg & body] 
    ~(try 
        (do ,(splice body))
        ([err] (error (string ,msg " \nDetails:\n" err)))
    )
)

(defmacro str [& args] 
    ~(error (string (splice ,args)))
)

(defmacro tracev-all
    "Performs tracev on every element in body"
    [& body] 
    ~(do ,;(seq [form :in body]
        ~(tracev ,form)
    ))
)
