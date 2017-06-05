type t = { mutable v : bool; mutable pv : bool; eval : unit -> unit }
val make : (unit -> bool) -> t
val ( !?. ) : t -> bool
val ( ?. ) : t -> bool
val ( ??. ) : t -> bool
