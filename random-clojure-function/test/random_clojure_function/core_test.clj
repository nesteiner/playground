(ns random-clojure-function.core-test
  (:require [clojure.test :refer :all]
            [random-clojure-function.core :as SUT]))

(deftest random-function-test
  (testing "show random function from clojure standard library"
    (is (seq SUT/standard-library-functions))
    (is (string? (SUT/random-function SUT/standard-library-functions)))))
