(ns clacks.core
  (:require [clojure.set]))

(def alphabet {"a" "010001"
               "b" "001010"
               "t" "100111"})

(def alphabet-inverted (clojure.set/map-invert alphabet))

(defn message-clacks
  "Convert a message ti the Clacks notation"
  [message alphabet]
  (map (fn [character]
         (get alphabet (str character)))
       message))

(defn clacks-message
  "Convert a collection of Clacks notations to messsage using the alphabet"
  [clacks alphabet]
  (->> clacks
       (map (fn [clack] (get alphabet clack)))
       (reduce str)))


