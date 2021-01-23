(defmacro wrap [msg & body] 
    ~(try 
        (do ,(splice body))
        ([err] (error (string ,msg " \nDetails:\n" err)))
    )
)

(defmacro str [& args] 
    ~(error (string  ,;args))
)

(defmacro tracev-all
    "Performs tracev on every element in body"
    [& body] 
    ~(upscope ,;(seq [form :in body]
        ~(tracev ,form)
    ))
)
