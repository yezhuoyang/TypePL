# TypePL

This is the notes and my homework solution for Type and programming language course teached in UCLA by Todd.

I also formalize the proof in both Lean and Coq.




# Example of a tiny Language


We start with a tiny language.The syntax of a mini language with Boolean type is defined as follows:


```ocaml
t ::= true | false | if t then t else t
v ::= true | false
```

We can make the language slightly more complicated with extra integer type:


```ocaml
t ::= true | false | if t then t else t | n | t + t | t > t
v ::= true | false
n ::= integer constants
v ::= b | n
```


# Big-Step Operational Semantics
The big step semantics ⇓ is a logical relation between term and value. "t ⇓ v" reads "term t evaluates to value v"


```ocaml
------------------------------- B-True
true ⇓  true
```


```ocaml
------------------------------- B-False
false ⇓  false
```



```ocaml
t1 ⇓ true            t2 ⇓ v2
--------------------------------- B-IfTrue
if t1 then t2 else t3 ⇓ v2
```


```ocaml
t1 ⇓ false            t2 ⇓ v3
--------------------------------- B-IfFalse
if t1 then t2 else t3 ⇓ v3
```

```ocaml
------------------------------- B-Int
n ⇓  n
```


```ocaml
t1 ⇓ n1   t2 ⇓ n2   n1 [[+]] n2 = n 
--------------------------------------- B-Plus
t1 + t2  ⇓ n
```


```ocaml
t1 ⇓ n1   t2 ⇓ n2   n1 [[>]] n2 = b 
--------------------------------------- B-Gt
t1 > t2  ⇓ b
```


# Example of derivation by Big Step semantic


We can build a derivation by the ruls to prove that an expression evaluates to false/true. 


```ocaml
--------------- B-False    ------------------ B-False
false ⇓ false              false ⇓ false
--------------------------------------------------------(B-IfFalse)
(if false then true else false) ⇓ false
```


# Theorem proof by Big-Step Semantics

We have the following theorem for language of booleans by structural induction. 

```coq
Theorem: forall t, exists v such that t ⇓ v
Proof: By structural induction on t.
Case analysis on the form of t.
Induction Hypothesis:
      forall t0 where t0 is a subterm of t,
            exists v0 such that t0 ⇓ v0
      case t = true. Then v = true by B-True.
      case t = false. Then v = false by B-False.
      case t = if t1 then t2 else t3.
            By IH, exists v1 such that t1 ⇓ v1.
            Case analysis on v1:
            Case v1=true:
                         By IH, exists v2 such that t2 ⇓ v2.
                         Therefore, t ⇓ v2 by B-IfTrue.
            Case v1=false:
                         By IH, exists v3 such that t3 ⇓ v3.
                         Therefore, t ⇓ v3 by B-IfFalse.
QED                                     
```





# Small-Step Semantics

We model the semantic by logical relation, also called a judgment with to form t-->t'. This is read as "t evaluates in one step to t'".
There are two kinds of inference rules: 1. The computation rules where there are no premises. 2. Congruence rules where there is a single premise.


Following is the small-step operational semantics for this simple languages:

(Computation) When the condition term is true, evalute the first expression

```ocaml
-------------------------------- (E-IFTRUE)
if true then t2 else t3 --> t2
```

(Computation) If the condition term is false, evalute the second expression

```ocaml
-------------------------------- (E-IFFALSE)
if false then t2 else t3 --> t3
```

If the condition is a expression, evaluate it first

```ocaml
t1 --> t1'
------------------------------------------------(E-IF)
if t1 then t2 else t3 --> if t1' then t2 else t3
```

Plus rule of two integer constant.

```ocaml
n1 [[+]] n2 = n
----------------------------------------------(E-PLUS)
n1 + n2 --> n
```


```ocaml
 t1 --> t1'
---------------------------------------- (E-PLUS1)
t1 + t2 --> t1' + t2
```

```ocaml
 t2 --> t2'
----------------------------------------- (E-PLUS2)
v1 + t2  --> v1 + t2'
```

```ocaml
n1 [[>]] n2 = b
------------------------------------------(E-GT)
n1 > n2 --> b
```

```ocaml
t1 --> t1'
-------------------------------------------(E-GT1)
t1 > t2 --> t1' > t2
```

```ocaml
t2 --> t2'
--------------------------------------------(E-GT2)
v1 > t2 --> v1 > t2'
```

A *normal form* is defined as a term that does not step. Formally, t is a normal form if there is no t' such that t-->t'. Values are normal forms. Normal forms that are not values are called *stick expressions*. For example, 1 + true is a stuck expression. 
We also introduce *multistep relation*, denoted as t -->* t, this is a reflexive, transitive closure of -->. 


```ocaml
--------------------------------------------(E-Refl)
t -->* t
```


```ocaml
t --> t'
--------------------------------------------(E-Step)
t -->* t'
```


```ocaml
t -->* t''        t'' -->* t'
--------------------------------------------(E-Trans)
t -->* t'
```

A term t is *eventually stuck* if it is stuck after 0 or more steps. t -->* t' and t' is stuck.



# Example of derivation by Small Step semantic


Assume we want to prove：

```ocaml
(if (2 + 2 > 1) then (if false then true else false) else false) -->* if false then true else false
```


First we prove (2 + 2 > 1) -->* true:

```ocaml
                                                      -------------------------------(E-PLUS)
                                                         2 + 2 --> 4
---------------------(E-GT)                           -------------------------------(E-GT1)
4 > 1 --> true                                          2 + 2 > 1 --> 4 + 1
--------------------(E-STEP)                          -------------------------------(E-STEP)
4 > 1 -->* true                                        (2 + 2 > 1) -->* 4 > 1
-------------------------------------------------------------------------------------(E-GT1)
(2 + 2 > 1) -->* true
```

Then, we use the transitivity and (E-Step) rule to finish the proof

```ocaml
(2 + 2 > 1) -->* true
----------------------------------------------------------------------------------------------(E-IFTRUE, E-Step, E-Trans)
(if (2 + 2 > 1) then (if false then true else false) else false) -->* if false then true else false
```


# Compile and run


Use the following command to compile ocaml program to executable binary and run:

```bash
ocamlc -o hm1.exe hm1.ml
./hw1.exe
```
