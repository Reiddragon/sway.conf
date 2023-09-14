#!/usr/bin/env -S csi -script
(import (chicken string)
        shell)

(define net #f)
(define vpn #f)

(let loop ((connections (reverse
                          (string-split
                            (capture
                              (nmcli -g "NAME,TYPE" connection show --active))
                            "\n"))))
  (unless (null? connections)
    (let ((con (string-split
                 (car connections)
                 ":")))
      (case (string->symbol (list-ref con 1))
        ((802-11-wireless 802-3-ethernet) (set! net (list-ref con 0)))
        ((vpn) (set! vpn (list-ref con 0)))))
    (loop (cdr connections))))

(if net
    (begin (display (string-append "Connected to " net))
           (when vpn
             (display (string-append " (" vpn ")"))))
    (if (substring-index
          "disabled\n"
          (capture (nmcli radio wifi)))
        (display "Disabled")
        (display "Disconnected")))

(display "\n")

