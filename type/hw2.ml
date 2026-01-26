exception ImplementMe


type t = True | False | If of t * t * t | Int of int | Plus of t * t | Greater of t * t
type typ = Bool | Integer


(* Problem 1. *)
exception TypeError
let rec typecheck t =
    match t with

        | True -> Bool

        | False -> Bool

        | Int n -> Integer

        | If (t1,t2,t3) -> 
            (    
            match typecheck t1 with
                | Bool -> 
                        (
                            match (typecheck t2, typecheck t3) with
                                | (Integer, Integer) -> Integer
                                | (Bool, Bool) -> Bool
                                | (_ , _) -> raise TypeError
                        )
                | _ -> raise TypeError 
            )          

        | Plus (t1, t2) ->
            (    
            match (typecheck t1, typecheck t2) with
                | (Integer, Integer) -> Integer
                | (_ , _ ) -> raise TypeError
            ) 

        | Greater (t1, t2) -> 
            (
            match (typecheck t1, typecheck t2) with
                | (Integer, Integer) -> Bool
                | (_, _) -> raise TypeError
            )
    

(* Convert the program to string *)
let rec to_string_term = function
        | True -> "True"
        | False -> "False"
        | Int n -> "Int " ^ string_of_int n
        | If (t1, t2, t3) 
            -> "If (" ^ to_string_term t1 ^ ", " ^ to_string_term t2 ^ ", " ^ to_string_term t3 ^ ")"
        | Plus (t1, t2)
            -> "Plus (" ^ to_string_term t1 ^ ", " ^ to_string_term t2 ^ ")"
        | Greater (t1, t2) 
            -> "Greater (" ^ to_string_term t1 ^ ", " ^ to_string_term t2 ^ ")"


let to_string_typ : typ -> string = function
        | Bool -> "Bool"
        | Integer -> "Integer"    



(* Run typecheck and print the output*)
let test_typecheck : string -> t -> unit = fun  name term -> 
  print_endline ("== " ^ name ^ " ==");
  print_endline ("input:  " ^ to_string_term term);
  print_endline ("output: " ^ (to_string_typ (typecheck term)))




let () =
    test_typecheck "Test case 1" (If (True, True, Int 2));
       
