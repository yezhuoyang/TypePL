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
exception Stuck


(*This function should perform exactly one small-step reduction based on the operational semantics*)
let rec step t =
    match t with

    (*E-IFTRUE*)
    | If (True, t2, t3) -> 
        t2

    (*E-IFFALSE*)
    | If (False, t2, t3) -> 
        t3

    (*When the condition is a value but is not true of false*)    
    | If (v1, t2, t3) when isval v1 ->
        raise Stuck   
     
    (*E-IF*)
    | If (t1, t2, t3) -> 
        If (step t1, t2, t3)

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
    | Greater (v1, t2) when isval v1 ->
        Greater (v1, step t2)

    (*E-GT1: Left side is an expression*)
    | Greater (t1 , t2) ->
        Greater (step t1, t2)


    | _ ->
        if isval t then
            raise NormalForm
        else
            raise Stuck

    


(* Problem 1b. *)

(*This function use the previous step function to execute a given term t until it reaches a normal form(Either a value or a stuck expression*)
let rec eval t =
    try
        eval (step t)
    with
    | NormalForm -> t



(*This function evaluate any input term by definition of big step semantic directly*)    
let rec evalBig t =
    match t with
    (*B-True*)
    | True -> True
    (*B-False*)
    | False -> False
    (*B-Int*)    
    | Int _ -> t

 
    | If (t1, t2, t3) ->
        (match evalBig t1 with
            | True -> evalBig t2
            | False -> evalBig t3
            | _    -> raise Stuck 
        )

    | Plus (t1, t2) ->
        (match (evalBig t1, evalBig t2) with
            | (Int n1, Int n2) -> Int (n1 + n2)
            | _ -> raise Stuck
        )

    | Greater (t1, t2) ->
        (match (evalBig t1, evalBig t2) with
            | (Int n1, Int n2) -> if n1 > n2 then True else False
            | _ -> raise Stuck
        )


(*Test cases*)



let rec to_string = function
   | True -> "True"
   | False -> "False"
   | Int n -> "Int " ^ string_of_int n
   | If (t1, t2, t3) ->
       "If (" ^ to_string t1 ^ ", " ^ to_string t2 ^ ", " ^ to_string t3 ^ ")"
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



type outcome =
    | Value of t
    | RaisedNormalForm
    | RaisedStuck
    | RaisedImplementMe

let outcome_to_string = function
    | Value v -> "Value(" ^ to_string v ^ ")"
    | RaisedNormalForm -> "<NormalForm>"
    | RaisedStuck -> "Stuck"
    | RaisedImplementMe -> "<ImplementMe>"


let run_eval f term: outcome =
    try
        Value (f term)
    with
        | NormalForm -> RaisedNormalForm
        | Stuck -> RaisedStuck
        | ImplementMe -> RaisedImplementMe




let test_eval name term = 
    print_endline ("== " ^ name ^ "==");
    print_endline ("input: " ^ to_string term);


    let out_small = run_eval eval term in
    let out_big = run_eval evalBig term in

    if out_small = out_big then
        print_endline ("[PASS] Small-step and big-step agree: " ^ outcome_to_string out_small)
    else begin
        print_endline ("[FAIL] mismatch");
        print_endline ("  small-step: " ^ outcome_to_string out_small);
        print_endline (" big-step:  "^ outcome_to_string out_big);
    end;

    print_endline ""



(* let () =
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
  () *)



let () =
    test_eval "eval If True" (If (True, Int 1, Int 2));
    test_eval "eval Plus" (Plus (Int 10, Int 32));
    test_eval "eval nested" (If (Greater (Int 3, Int 2), Plus (Int 1, Int 2), Int 0));
    test_eval "eval stuck If(Int ...)" (If (Int 0, Int 1, Int 2));
    ()