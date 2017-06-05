Buchi_automaton — Library for work with buchi automata.
-------------------------------------------------------------------------------
%%VERSION%%

Buchi_automaton is distributed under the ISC license.

Homepage: https://github.com/vasil-sd/ocaml-ba

## Installation

bitset can be installed with `opam`:

    opam install ocaml-ba

If you don't use `opam` consult the [`opam`](opam) file for build
instructions.

## Documentation

The documentation and API reference is generated from the source
interfaces. It can be consulted [online][doc] or via `odig doc
buchi_automaton`.

[doc]: https://vasil-sd.github.io/ocaml-ba/doc

## Sample programs

If you installed bitset with `opam` sample programs are located in
the directory `opam var buchi_automaton:doc`.

In the distribution sample programs and tests are located in the
[`test`](test) directory. They can be built and run
with:

    topkg build --tests true && topkg test 
