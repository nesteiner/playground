(ns random-clojure-function.core
  (:gen-class))

(def standard-library-functions
  "Fully qualified function names from clojure.core"
  (vals (ns-publics 'clojure.core)))

(def all-public-functions
  "Fully qualified function names from available"
  (mapcat #(vals (ns-publics %)) (all-ns)))

(defn function-list [namespace]
  (vals (ns-publics namespace)))

(defn selective-namespace-functions [namespace-sequence]
  (mapcat #(function-list (symbol %)) namespace-sequence))

(defn random-function [function-list]
  (let [function-details (meta (rand-nth function-list))]
    (str (function-details :ns) "/" (function-details :name)
         "\n" (function-details :arglists)
         "\n" (function-details :doc))))

(defn -main
  "Return a random function and its details from all avaliable namespaces"
  [& args]
  (if (seq args)
    (println (random-function (selective-namespace-functions args)))
    (println (random-function all-public-functions))))

;; REPL experiments
(comment
  ;; a hash-map of functions in clojure.core
  (ns-publics 'clojure.core)

  ;; a sequence of function vars from clojure.core
  (vals (ns-publics 'clojure.core))

  ;; random var from the sequence
  (rand-nth (vals (ns-publics 'clojure.core)))

  ;; metadata from a function var
  (meta #'map)

  ;; get all namespaces from the current classpath
  (all-ns)

  (require '[clojure.inspector :as inspector])
  (inspector/inspect-tree (all-ns))

  (mapcat function-list '[clojure.core])
  (mapcat #(function-list (symbol %)) '[clojure.core])
  (mapcat #(function-list (symbol %)) ["clojure.core"])
  (mapcat function-list '[clojure.core clojure.string])

  (ns-publics (var map))
  (symbol 'clojure.core)
  (function-list 'clojure.core)
  (-main "clojure.string")

  ;; call main without arguments uses Clojure standard library
  ;; plus any other namespaces in the REPL
  (-main)
  (-main "clojure.string"))