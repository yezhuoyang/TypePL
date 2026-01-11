exception ImplementMe
type t = 
    | True  
    | False 
    | If of t * t * t    (* Construct of If expression,  If cond then else *)
    | Int of int         (* Construct of Int,    Int 3 *)
    | Plus of t * t      (* Construct of Plus,    Plus t1 t2 *)
    | Greater of t * t   (* Construct of Greater, Greater t1 t2 *)


let isval t =
  match t with
  True|False -> true
  | Int _ -> true
  | _ -> false


(* Problem 1a. *)
exception NormalForm

(*This function should perform exactly one small-step reduction based on the operational semantics*)
let rec step t =
    match t with
    | True -> True
    | False -> False

    (*E-IFTRUE*)
    | If (True, t2, t3) -> 
        t2

    (*E-IFFALSE*)
    | If (False, t2, t3) -> 
        t3

    (*E-IF*)
    | If (t1, t2, t3) -> 
        If (step t1, t2, t3)

    | Int n -> Int n

    (* E-PLUS: both sides are integers*)
    | Plus (Int n1 , Int n2) ->
       Int (n1 + n2)

    (* E-PLUS2: Left is a vlue, step the right expression*)
    | Plus (v1, t2) when isval v1 ->
       Plus (v1, step t2)  
      
    (* E-PLUS1 Step left expression otherwise*)  
    | Plus (t1, t2) ->
       Plus (step t1, t2)  

    (* E-GT: Both sides are integers*)   
    | Greater (Int n1, Int n2) ->
        if n1 > n2 then True else False

    (* E-GT2: Left side is an integer, right side is an expression*)      
    | Greater (Int n1, t2) ->
        Greater (Int n1, step t2)

    (*E-GT1: Left side is an expression*)
    | Greater (t1 , t2) ->
        Greater (step t1, t2)


    | _ -> raise NormalForm

    

      



(* Problem 1b. *)

(*This function use the previous step function to execute a given term t until
it reaches a normal form(Either a value or a stuck expression*)
(* let rec eval t =
    match t with
    | True -> True
    | False -> False
    | If (t1, t2, t3) -> ???
    | Int n -> t
    | Plus (t1, t2) -> ???
    | Greater (t1, t2) -> ??? *)



(*Test cases*)



let rec to_string = function
   | True -> "True"
   | False -> "False"
   | Int n -> "Int " ^ string_of_int n
   | If (t1, t2, t3) ->
       "If (" ^ to_string t1 ^ ", " ^ to_string t2 ^ ", " ^ to_string t2 ^ ")"
   | Plus (t1, t2) ->
       "Plus (" ^ to_string t1 ^ ", " ^ to_string t2 ^ ")"
   | Greater (t1, t2) ->
       "Greater (" ^ to_string t1 ^ ", " ^ to_string t2 ^ ")"


let test_step name term =
  print_endline ("== " ^ name ^ " ==");
  print_endline ("input:  " ^ to_string term);
  try
    let term' = step term in
    print_endline ("output: " ^ to_string term');
    print_endline ""
  with
  | NormalForm ->
      print_endline "output: <NormalForm>";
      print_endline ""
  | ImplementMe ->
      print_endline "output: <ImplementMe raised>";
      print_endline ""

let () =
  test_step "step True" True;
  test_step "step (If True ...)" (If (True, Int 1, Int 2));
  test_step "step (If False ...)" (If (False, Int 1, Int 2));

  (* E-IF should step the condition *)
  test_step "step If (Greater ...)" (If (Greater (Int 3, Int 2), Int 1, Int 0));

  (* Plus *)
  test_step "step Plus (Int, Int)" (Plus (Int 10, Int 32));
  test_step "step Plus (Int, Plus ...)" (Plus (Int 1, Plus (Int 2, Int 3)));
  test_step "step Plus (Plus ..., Int)" (Plus (Plus (Int 2, Int 3), Int 1));

  (* Greater *)
  test_step "step Greater (Int, Int) true" (Greater (Int 5, Int 2));
  test_step "step Greater (Int, Int) false" (Greater (Int 1, Int 9));
  test_step "step Greater (Int, Plus ...)" (Greater (Int 5, Plus (Int 2, Int 3)));

  (* Stuck / Normal form checks *)
  test_step "step Int is NormalForm (if you choose so)" (Int 7);
  test_step "step stuck If (Int ...)" (If (Int 0, Int 1, Int 2));
  ()

