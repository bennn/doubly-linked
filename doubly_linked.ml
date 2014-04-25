(* type 'a dublist = Nil | Cons of 'a dublist * 'a * 'a dublist *)
type 'a dublist = Nil | Cons of 'a tail * 'a * 'a tail
and 'a tail = unit -> 'a dublist

let create () = Nil

let head xs =
  begin match xs with
    | Nil -> failwith "expected to get head"
    | Cons(_,x,_) -> x
  end

let tail xs =
  begin match xs with
    | Nil -> failwith "expected to get tail"
    | Cons(_,_,t) -> t ()
  end

let lait xs =
  begin match xs with
    | Nil -> failwith "expected to get laid"
    | Cons(t,_,_) -> t ()
  end

let rec march_to_start xs =
  begin match xs with
    | Nil -> xs
    | Cons(t,_,_) -> 
      begin match t() with
        | Nil -> xs
        | prev -> march_to_start prev
      end
  end

let rec march_to_end xs =
  begin match xs with
    | Nil -> Nil
    | Cons(_,_,t) -> 
      begin match t() with 
        | Nil -> xs
        | next -> march_to_end next
      end 
  end

(* Create a new list with [prev] as back-pointer for all entries in [xs] *)
let rec lock prev xs =
  begin match xs with
    | Nil -> Nil
    | Cons(_,x,next) ->
      let next' = next () in
      let rec xs' = 
        Cons((fun () -> prev), x, fun () -> lock xs' next')
      in xs'
  end

let rec kcol xs next =
  begin match xs with
    | Nil -> Nil
    | Cons(prev,x,_) ->
      let prev' = prev () in
      let rec xs' = 
        Cons((fun () -> kcol prev' xs'), x, (fun () -> next))
      in xs'
  end

let cons x xs =
  begin match march_to_start xs with
    | Nil -> Cons((fun () -> Nil),x,(fun () -> Nil))
    | Cons(prev,y,next) ->
      (* [prev] should be thunked [Nil] *)
      let next' = next() in
      let rec new1 =
        Cons(prev, x, (fun () -> new2))
      and new2 =
        Cons((fun () -> new1), y, (fun () -> lock new2 next'))
      in new1
  end

let snoc xs x =
  begin match march_to_end xs with
    | Nil -> 
      Cons((fun () -> Nil), x, (fun () -> Nil))
    | Cons(prev,y,next) ->
      (* [next] should be thunked [Nil] *)
      let prev' = prev () in
      let rec new1 =
        Cons((fun () -> new2), x, next)
      and new2 =
        Cons((fun () -> kcol prev' new2), y, (fun () -> new1))
      in new1
  end

let rec foldl_aux f acc xs =
  begin match xs with
    | Nil -> acc
    | Cons(_,x,t) -> foldl_aux f (f acc x) (t())
  end

let foldl f acc xs =
  foldl_aux f acc (march_to_start xs)

let rec foldr_aux f xs acc =
  begin match xs with
    | Nil -> acc
    | Cons(_,x,t) -> f x (foldr_aux f (t()) acc)
  end
let foldr f xs acc = 
  foldr_aux f (march_to_start xs) acc

let length xs = foldl (fun acc _ -> 1 + acc) 0 xs
let sum xs = foldl (+) 0 xs

let map f xs =
  foldr (fun x acc -> (f x) :: acc) xs []

let append xs ys =
  begin match march_to_end xs, march_to_start ys with
    | Nil,Nil -> Nil
    | _,Nil -> xs
    | Nil,_ -> ys
    | Cons(prev_thunk,x',_), Cons(_,y',next_thunk) ->
      (* The underscores should point to [Nil] *)
      begin match prev_thunk(), next_thunk() with
        | Nil, Nil -> 
          (* Both are single-element lists. *)
          let rec new1 = 
            Cons((fun () -> Nil),x',(fun () -> new2))
          and new2 =
            Cons((fun () -> new1),y',(fun () -> Nil))
          in new1
        | Nil,Cons(_,_,_)
        | Cons(_,_,_),Nil ->
          failwith "I suspect these can be handled in unified way"
        | Cons(prev_thunk,x,_), Cons(_,y,next_thunk) ->
          let prev, next = prev_thunk(), next_thunk() in
          let rec new1 =
            Cons((fun () -> kcol prev new1), x, (fun () -> new2))
          and new2 =
            Cons((fun () -> new1), x', (fun () -> new3))
          and new3 =
            Cons((fun () -> new2), y', (fun () -> new4))
          and new4 =
            Cons((fun () -> new3), y, (fun () -> lock new4 next))
          in march_to_start new1
      end
  end
  
let rec slice xs i j =
  if j=0 then
    Nil
  else
    begin match xs,i with
      | Nil,_ -> failwith "slice: index outta bounds"
      | Cons(_,h,t),0 -> cons h (slice (t()) i (j-1))
      | Cons(_,_,t),_ -> slice (t()) (i-1) j
    end

let reverse xs =
  foldl (fun acc x -> cons x acc) (create ()) xs

let to_list xs =
  foldr (fun x acc -> x :: acc) xs []

let to_string xs =
  Format.sprintf "< %s >" (String.concat " - " (map string_of_int xs))

let make_circle (x:'a) =
  (* all bets are off... *)
  let rec xs = Cons((fun () -> xs),x,(fun () -> xs)) in
  xs
