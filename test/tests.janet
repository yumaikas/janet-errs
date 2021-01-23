(import ../err)
 (use testament)
 
 (deftest err/str-composes
    (assert-thrown-message "1 2 3 4" (err/str 1 " 2 " 3 " 4"))
 )
 
 (deftest ctx-adds-contenxt
    (assert-thrown-message 
        "abc \nDetails:\nefg" 
        (err/wrap "abc"
            (error "efg")
        )))
        
(deftest tracev-all-can-work-with-defs 
    (def outbuf @"")
    (def errbuf @"")
    (with-dyns [:out outbuf :err errbuf]
        (err/tracev-all 
            (def a 2)
            (def b 3)
            (def c (+ a b))
        )
        (assert-equal c 5 "tracev-all, like tracev, shouldn't introduce new scopes")
    )
    
    (assert-equivalent outbuf "")
    (assert-equal true 
        (if (and
            (string/find "(def a 2)" errbuf)
            (string/find "(def b 3)" errbuf)
            (string/find "(def c (+ a b))" errbuf))
                true false) 
        "All lines should be traced")
    
)
(run-tests!)
