(**
 * Module defining circularly-linked lists in OCaml.
 * Lists are represented as recursively defined cons cells with two links.
 * Null links represent the ends of the list.
 * 
 * Sure, we could do the same thing more simply and efficiently with zippers,
 * but then there'd be no fun with mutual recursion.
 *
 * Links are lazy and this is a bummer. Ran into problems trying to write a 
 * [lock] to recursively chain elements; we'd pushed [let rec] to the limit.
 *)



type 'a t

(**
 * [create ()] initialize a new doubly-linked list
 *)
val create : unit -> 'a t

(**
 * [head xs] returns the first value stored in [xs]. Raises [Failure] if the list is empty.
 *)
val head : 'a t -> 'a

(**
 * [tail xs] returns the right tail of [xs]. Raises [Failure] if the list has no right tail.
 *)
val tail : 'a t -> 'a t

(**
 * [lait xs] returns the left tail of [xs]. Raises [Failure] if the list has no left tail.
 *)
val lait : 'a t -> 'a t

(**
 * [march_to_start xs] move the context of [xs] furthest to the left.
 * More specifically, the result of calling [march_to_start] on a non-empty list
 * is a [Cons] cell with left pointer to [Nil].
 *)
val march_to_start : 'a t -> 'a t

(**
 * [march_to_end xs] is the converse of [march_to_start]. Moves the context
 * as far right as possible; right pointer of result should go to [Nil].
 *)
val march_to_end : 'a t -> 'a t

(**
 * [cons x xs] Creates a new doubly-linked list with value [x] at the first position and
 * the values of [xs] in the tail. Runs in O(n) because the entire list has to be updated
 * for the back pointers to be right.
 *)
val cons : 'a -> 'a t -> 'a t

(**
 * [snoc xs x] Converse of [cons]. Creates a new list with all elements of [xs] and
 * [x] at the end. The operation's no faster than appending with normal lists.
 *)
val snoc : 'a t -> 'a -> 'a t

(**
 * [foldl f acc xs] Left-to-right fold over the elements.
 *)
val foldl : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a

(**
 * [foldr f xs acc] Right-to-left fold over the elements.
 *)
val foldr : ('a -> 'b -> 'b) -> 'a t -> 'b -> 'b

(**
 * [from_list xs] converts a list into a doubly-linked list.
 * Runs in O(n), recommended over iterated use of [cons].
 *)
val from_list : 'a list -> 'a t

(**
 * [to_list xs] converts a doubly-linked list into a normal OCaml list.
 *)
val to_list : 'a t -> 'a list

(**
 * [length xs] Counts the number of elements in [xs].
 *)
val length : 'a t -> int

(**
 * [sum xs] Adds the elements of [xs].
 *)
val sum : int t -> int

(**
 * [map f xs] Applies [f] to each element of [xs], creating a new list.
 *)
val map : ('a -> 'b) -> 'a t -> 'b t

(**
 * [to_string xs] Returns a string representation of [xs].
 *)
val to_string : int t -> string

(**
 * [append xs ys] Creates a new list with all elements of [xs] then all elements of [ys],
 * in order.
 *)
val append : 'a t -> 'a t -> 'a t

(**
 * [slice xs i j] Extracts a sublist from [xs] starting at index [i] (inclusive) and
 * ending at index [j] (exclusive).
 *)
val slice : 'a t -> int -> int -> 'a t

(**
 * [reverse xs] Creates a  new list with all elements of [xs], order reversed.
 *)
val reverse : 'a t -> 'a t

(**
 * [merge xs ys] Creates a new list with elements of [xs] interwoven with elements
 * of [ys]. If lists are of unequal length then the trailing elements of the longer
 * list are the last elements of the result.
 *)
val merge : 'a t -> 'a t -> 'a t

(**
 * [make_circle x] Creates a circular, doubly-linked list with a single element, [x].
 *)
val make_circle : 'a -> 'a t
