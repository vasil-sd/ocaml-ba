module Predicates : sig
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
end

module type STATE = sig
  type t
  val compare : t -> t -> int
end

module type S = sig
  type state
  type t
  type tr = {src : state; dst : state; cond : unit -> bool}
  val make : desc : string -> init:state list -> accept:state list -> fail:state list -> tr list -> t
  val get_description : t -> string
  val eval : t -> unit
  val reset : t -> unit
  val is_active : t -> bool
  val is_accepted : t -> bool
  val is_failed : t -> bool
  val get_active_states : t -> state list
  val get_accepted_states : t -> state list
  val get_failed_states : t -> state list
end

module Make (St : STATE) : (S with type state = St.t)
module Default : (S with type state = int)
