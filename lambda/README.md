# Lambda Calculus



# Example


```ocaml

(function x -> x + x) 34 --> 34 + 34 --> 68

(function f -> f (f 2)) (function x -> x + x) -->
     (function x -> x + x)( (function x -> x + x) 2) -->
     (function x -> x + x) (2 + 2) -->
     (function x -> x + x) 4 -->
     4 + 4 -->
     8
```

function calling is left associative:


```ocaml
(function x -> (function y -> x + y)) 3 4 -->
(function y -> 3 + y) 4 -->
3 + 4 --> 7
```


# Syntax:


```ocalm
t :: x | function x -> t | t1 t2
```

Here x is a metavariable that ranges over an infinite set of variable names.

Syntactic conventions:

1. Function calling is left associative, such that t1 t2 t3 is interpreted as (t1 t2) t3
2. Function x -> x x is interpreted as (function x -> x x)


A function call (t1 t2) is also called a function application.

x is *bound* in the body (t) of (function x -> t)

variables that are not bound are called *free* variables. 

```ocaml
(*x is bound but y is free*)
function x -> x + y
```

A *closed* term is a term that has no free variables. 


```ocaml
v ::= function x -> t
```

Small step semantics judgement of the form t-->t'


Computation rule:

```ocaml
-------------------------------- (E-AppBeta)
(function x-> t) v --> t[x |-> v]
```

Here [x |-> v] denotes substitution of all *free* occurrences of x with v. For example:



```ocaml
(function x -> ((function x -> x)(x+1))) 34 -->
      ((function x -> x)(x+1))[x |-> 34] =
      ((function x -> x)(34+1)) -->
      (function x-> x) 35 -->
      35
```

The substitution is defined semantically by cases:


```ocaml
x[x |-> v] = v
y[x |-> v] = y (* y != X*)
(function y -> t) [x |-> v] = (function x -> t)

```
