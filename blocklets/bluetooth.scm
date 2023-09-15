#!/usr/bin/env -S csi -script
(import (chicken string)
        shell)

(define devices
  (capture (bluetoothctl devices Connected)))

(display
  (string-append
    (if (eqv? devices #!eof)
        (case (string->symbol
                (list-ref (string-split
                            (capture
                              ("bluetoothctl show | grep Powered")))
                          1))
          ((yes) "󰂯 Disconnected")
          ((no) "󰂲 Off")
          (else "sumthang's wrong"))
        (string-append "󰂱 Connected to "
                       (string-intersperse
                         (map
                           (lambda (dev)
                             (string-intersperse
                               (cdr (cdr (string-split dev)))
                               " "))
                           (string-split devices "\n"))
                         ", ")))
    "\n"))

