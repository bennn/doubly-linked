type 'a dublist =
    Nil
  | Cons of (unit -> 'a dublist) * 'a * (unit -> 'a dublist)
val create : unit -> 'a dublist
val head : 'a dublist -> 'a
val tail : 'a dublist -> 'a dublist
val lait : 'a dublist -> 'a dublist
val march_to_start : 'a dublist -> 'a dublist
val march_to_end : 'a dublist -> 'a dublist
val lock : 'a dublist -> 'a dublist -> 'a dublist
val kcol : 'a dublist -> 'a dublist -> 'a dublist
val cons : 'a -> 'a dublist -> 'a dublist
val snoc : 'a dublist -> 'a -> 'a dublist
val foldl : ('a -> 'b -> 'a) -> 'a -> 'b dublist -> 'a
val foldr : ('a -> 'b -> 'b) -> 'a dublist -> 'b -> 'b
val length : 'a dublist -> int
val sum : int dublist -> int
val map : ('a -> 'b) -> 'a dublist -> 'b list
val append : 'a dublist -> 'a dublist -> 'a dublist
val slice : 'a dublist -> int -> int -> 'a dublist
val reverse : 'a dublist -> 'a dublist
val to_list : 'a dublist -> 'a list
val to_string : int dublist -> string
val make_circle : 'a -> 'a dublist
