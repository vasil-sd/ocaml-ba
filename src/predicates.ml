type t =
  { mutable v : bool;
    mutable pv : bool;
    eval : unit -> unit}

let make f =
  let rec r =
    { v = false;
      pv = false;
      eval = (fun () -> 
                r.pv <- r.v;
                r.v <- f ())} in
  r

let (!?.) r = r.eval (); r.v
let (?.) r = r.v
let (??.) r = r.pv