(define-constant MAX-COUNT u100)

(define-map counters principal uint)

(define-data-var total-ops uint u0)

(define-read-only (get-count (who principal))
  (default-to u0 (map-get? counters who))
)

(define-read-only (get-total-operations) 
  (var-get total-ops)
)

(define-private (update-total-ops)
  (var-set total-ops (+ (var-get total-ops) u1))
)

(define-public (count-up)
  (let((current-count (get-count tx-sender)))
    (asserts! (< current-count MAX-COUNT)(err u1))
    (update-total-ops)
    (ok(map-set counters tx-sender (+ current-count u1)))
  )
)

(define-public (count-down)
  (let((current-count (get-count tx-sender)))
    (asserts! (> current-count u0)(err u2))
    (update-total-ops)
    (ok(map-set counters tx-sender (- current-count u1)))
  )
)
(define-public (reset-count)
  (begin
    (update-total-ops)
    (ok(map-set counters tx-sender u0))
  )
)
