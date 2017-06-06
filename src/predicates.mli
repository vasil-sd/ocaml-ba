type t = {
  mutable v : bool;
  mutable pv : bool;
  mutable eval : unit -> unit;
}
val make : (unit -> bool) -> t
val eval_list : t list -> unit
val on_eval : t -> t list -> unit
val sync_eval : t list -> unit
val ( && ) : t -> t -> t
val ( || ) : t -> t -> t
val not : t -> t
val history : ?depth:int -> t -> int -> bool
