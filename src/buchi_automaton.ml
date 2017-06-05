module Predicates = struct
  include Predicates
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

module Make (St : STATE) : (S with type state = St.t) = struct

  type state = St.t

  type t =
    {
      desc : string;
      states : state array;
      active : Bits.bits;
      init : Bits.bits;
      accept : Bits.bits;
      fail : Bits.bits;
      tr_table : (unit -> bool) array array
    }

  type tr =
    {
      src : state;
      dst : state;
      cond : unit -> bool
    }

  let rec mem s = function
    | [] -> false
    | h :: t -> if St.compare s h == 0 then true else mem s t

  let rec int_of_state ?from:(f=0) s states =
    if St.compare states.(f) s == 0
      then f
      else int_of_state ~from:(f+1) s states

  let make ~desc ~init ~accept ~fail trans =

    let tr_states =
      List.(map (fun {src; dst} -> [src;dst]) trans |> concat) in

    let states =
      Array.of_list
        List.(concat [init; accept; fail; tr_states]
              |> sort_uniq St.compare) in

    let nst = Array.length states in
    let to_bits l = Bits.init nst (fun i -> mem states.(i) l) in
    let init = to_bits init in
    let active = Bits.copy init in
    let accept = to_bits accept in
    let fail = to_bits fail in
    let tr_table = Array.(make nst (make nst (fun () -> false))) in

    List.iter
      (fun {src; dst; cond} ->
        Array.set
          tr_table.(int_of_state src states)
          (int_of_state dst states)
          cond)
      trans;

    {
      desc;
      states;
      active;
      init;
      accept;
      fail;
      tr_table
    }

  let get_description t = t.desc

  let eval t = Bits.(
    let nst = length t.active in
    let new_active = make nst false in
    iteri_on_val
      (fun src ->
        Array.iteri
          (fun n p ->
            if (p ()) then set new_active n true)
          t.tr_table.(src))
      t.active
      true;
    fill t.active 0 nst false;
    ignore (lor_inplace t.active new_active))

  let reset t = Bits.(
    let len = length t.active in
    fill t.active 0 len false;
    ignore(lor_inplace t.active t.init))

  let is_active t = not (Bits.all_zeros t.active)

  let is_accepted t = not Bits.(all_zeros (t.accept land t.active))

  let is_failed t = not Bits.(all_zeros (t.fail land t.active))

  let of_bits b s =
    let l = ref [] in
    Bits.iteri_on_val
      (fun i -> l := s.(i) :: !l)
      b
      true;
    !l

  let get_active_states t = of_bits t.active t.states

  let get_accepted_states t = of_bits t.accept t.states

  let get_failed_states t = of_bits t.fail t.states

end

module Default = Make (struct type t = int let compare = compare end)