#! /usr/bin/env racket
#lang racket

(require racket/cmdline)

(define instructions (list))

(define width 100)
(define height 50)

(command-line
    #:program "racket solution.rkt"

    #:once-any
    [("-f" "--file") fpath
                     "Read input from file"
                     (set! instructions
                         (append-map string-split (file->lines fpath)))]
    [("-i" "--input") input
                      "Provide input as a command line parameter"
                      (set! instructions (string-split input))]
    ["--test" "Test the program with a sample input"
                      (set! instructions (string-split "E5 S6 E5 N4 W3 N2 E7 S2 W2 S4 E12 N4 W4 S9 W3 N2 E11 N9 E7 S4 W4 S3 E4 S4 W13 S2 W9 N5 W8 S2 E4 S3 W3 N1 W4 S1 W2 N4 E3 N4 W3 N4"))]

    #:once-each
    ["--max-width" max-width
                   "Max length of a line in the grid (default=100)"
                   (set! width (string->number max-width))]
    ["--max-height" max-height
                    "Maximum number of lines in the grid (default=50)"
                    (set! height (string->number max-height))])


(define tracks
    (hash "NE" #\╔ "WS" #\╔
          "NW" #\╗ "ES" #\╗
          "SE" #\╚ "WN" #\╚
          "SW" #\╝ "EN" #\╝
          "N"  #\║ "S"  #\║
          "W"  #\═ "E"  #\═
          "+"  #\╬))

(define grid
    (for/list ([i (in-range height)])
        (make-vector width #\Space)))

(define (no-track? y x)
    (char=? #\Space (vector-ref (list-ref grid y) x)))

(define (place-track y x track-id)
    (let* ([row (list-ref grid y)]
           [track (hash-ref tracks track-id)])
        (vector-set! row x track)))

(define (display-grid grid)
    (for ([vec grid])
        (define line (list->string (vector->list vec)))
        #:break (regexp-match #rx"^ *$" line)
        (displayln (string-trim line #:left? #f))))

(let ([y 0] [x 0] [prevdir "N"])
    (for ([instruction instructions])
        (let ([direction (substring instruction 0 1)]
               [steps (string->number (substring instruction 1))])
            (let ([track (string-append prevdir direction)])
                (place-track y x track))
            (for ([i (in-range steps)])
                (cond
                    [(string=? direction "N") (set! y (sub1 y))]
                    [(string=? direction "E") (set! x (add1 x))]
                    [(string=? direction "S") (set! y (add1 y))]
                    [(string=? direction "W") (set! x (sub1 x))])
                (if (no-track? y x)
                    (place-track y x direction)
                    (place-track y x "+")))
            (set! prevdir direction))))

(display-grid grid)
