#!/usr/bin/env -S csi -script
(import (chicken string)
        shell)

(define devices
  (capture (bluetoothctl devices Connected)))

(display
  (string-append
    (if (eqv? devices #!eof)
        (if (= 0 (run* ("bluetoothctl show | grep 'Powered: yes'")))
            "󰂯 Disconnected"
            "󰂲 Off")
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

