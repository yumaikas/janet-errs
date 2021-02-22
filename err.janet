(defmacro wrap [msg & body] 
    "If wrap catches an error, it adds context to it, so that it's easier to see what's going on."
    ~(try 
        (do ,(splice body))
        ([err] (error (string ,msg " \nDetails:\n" err)))))

(defmacro str
    "Creates a concatented error string"
    [& args] 
        ~(error (string  ,(splice args))))

(defmacro signal 
    "Raises an error as a tuple"
    [sig & args] 
        ~(error [,sig (string ,(splice args))]))

(defmacro try*
    ```Executes an expression, attemts to match it against
       the various exception clauses, propogating the error if none of them match
    ```
    [expr & match-clauses] 
    (with-syms [$err $fib]
        ~(try 
            ,expr 
            ([$err $fib] 
                (match $err  
                    ,;(seq 
                        [clause :in match-clauses 
                         form :in clause] 
                        form
                        )
                    _ (propagate $err $fib))))))

(defmacro tracev-all
    "Performs tracev on every element in body"
    [& body] 
    ~(upscope ,(splice (seq [form :in body]
        ~(tracev ,form)
    )))
)
