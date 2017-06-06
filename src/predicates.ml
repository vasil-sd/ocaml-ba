type t =
  { mutable v : bool;
    mutable pv : bool;
    mutable eval : unit -> unit}

let make f =
  let rec r =
    { v = false;
      pv = false;
      eval = (fun () -> 
                r.pv <- r.v;
                r.v <- f ())} in
  r

let eval_list p_list =
  List.iter (fun p -> p.eval ()) p_list

let on_eval p p_list =
  let old_eval = p.eval in
  p.eval <-
    fun () -> 
      old_eval (); eval_list p_list

let sync_eval p_list =
  let old_eval = List.map (fun p -> p.eval) p_list in
  let eval = fun () ->
    List.iter (fun e -> e ()) old_eval in
  List.iter (fun p -> p.eval <- eval) p_list

let ( && ) p1 p2 =
  make
    (fun () ->
       p1.eval();
       if p1.v
       then (p2.eval(); p2.v)
       else false)

let ( || ) p1 p2 =
  make
    (fun () ->
       p1.eval();
       if not p1.v
       then (p2.eval(); p2.v)
       else true)

let not p =
  make
    (fun () ->
       p.eval();
       not p.v)

let history ?(depth=10) p =
 let h = Array.make depth false in
 let i = ref 0 in
 let old_eval = p.eval in
 let get_hist n =
   let j = if !i < n + 1 then !i - n - 1 + depth else !i - n - 1 in
   Array.get h j in
 let eval () =
   old_eval ();
   Array.set h !i p.v;
   i := (!i + 1) mod depth; in
 p.eval <- eval;
 get_hist
