(import ../err)
(use testament)
 
(deftest err/str-composes
   (assert-thrown-message "1 2 3 4" (err/str 1 " 2 " 3 " 4")))
   
(deftest err/signal-works
    (try
    (do 
        (err/signal :err "1 2 3 4")
    )
    ([err] (do
        (match err 
            [:err e] (do 
                (assert-equal e "1 2 3 4")
            )
            _ (error "Couldn't match!")
        )
    ))
    )
)
 
(deftest ctx-adds-contenxt
   (assert-thrown-message 
       "abc \nDetails:\nefg" 
       (err/wrap "abc"
           (error "efg"))))
        
(deftest tracev-all-can-work-with-defs 
    (def outbuf @"")
    (def errbuf @"")
    (with-dyns [:out outbuf :err errbuf]
        (err/tracev-all 
            (def a 2)
            (def b 3)
            (def c (+ a b))
        )
        (assert-equal c 5 "tracev-all, like tracev, shouldn't introduce new scopes"))
    
    (assert-equivalent outbuf "")
    # Currently testament doesn't have "assert-truthy" 
    (assert-equal true 
        (if (and
            (string/find "(def a 2)" errbuf)
            (string/find "(def b 3)" errbuf)
            (string/find "(def c (+ a b))" errbuf))
                true false) 
        "All lines should be traced")
)

(deftest try*-matches-as-expected 
    (err/try* 
        (do (error "EHEHEH"))
        ("EHEHEH" (assert-equal "" "")))
    
    (err/try*
        (err/signal :catch "Uncatchable!")
        ([:catch msg] 
         (do 
           (assert-equal "Uncatchable!" msg)
           (assert-equal true true)))))
    (err/try*
        (assert-equal true true))
  

(run-tests!)

