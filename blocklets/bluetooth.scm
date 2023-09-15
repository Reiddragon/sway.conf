#!/usr/bin/env -S csi -script
(import (chicken string)
        shell)

(define devices
  (capture (bluetoothctl devices Connected)))

(display
  (string-append
    (if (eqv? devices #!eof)
        (if (list-ref (string-split
                        (capture
                          ("bluetoothctl show | grep 'Powered: yes'")))
                      1)
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

