#!/usr/bin/env ocaml
#use "topfind"
#require "topkg"
open Topkg

let () =
  Pkg.describe "buchi_automaton" @@ fun c ->
  Ok [ Pkg.mllib "src/buchi_automaton.mllib";
       Pkg.test "test/test"; ]
