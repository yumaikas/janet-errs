(defmacro wrap [msg & body] 
    ~(try 
        (do ,(splice body))
        ([err] (error (string ,msg " \nDetails:\n" err)))
    )
)

(defmacro str
    "Creates a concatented error string"
    [& args] 
        ~(error (string  ,;args))
)

(defmacro signal 
    "Raises an error as a tuple"
    [sig & args] 
        ~(error [,sig (string ,(splice args))])
)

(defmacro tracev-all
    "Performs tracev on every element in body"
    [& body] 
    ~(upscope ,;(seq [form :in body]
        ~(tracev ,form)
    ))
)
