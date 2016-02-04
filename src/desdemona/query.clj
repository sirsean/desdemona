(ns desdemona.query
  (:require [clojure.core.logic :as l]))

(defn ^:private gen-query
  "Expands a query and events to a core.logic program that executes
  it."
  [n-answers query events]
  `(l/run ~n-answers [results#]
     (l/fresh [~'x]
       (l/== [~'x] results#)
       (l/membero ~'x ~events)
       ~query)))

(defn run-query
  ([query events]
   (run-query 1 query events))
  ([n-answers query events]
   (let [compiled-query (gen-query n-answers query events)
         old-ns *ns*]
     (try
       (in-ns 'desdemona.query)
       (eval compiled-query)
       (finally
         (in-ns (ns-name old-ns)))))))
