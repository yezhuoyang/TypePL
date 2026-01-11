# TypePL

This is the notes and my homework solution for Type and programming language course.

I also formalize the proof in Lean.




# Example of a tiny Language


We start with a tiny language with the following evaluation rules:


The syntax of a mini language with Boolean type is defined as follows:


```ocaml
t ::= true | false | if t then t else t
v ::= true | false
```





Following is the small-step operational semantics for this simple languages:

```ocaml
-------------------------------- (E-IFTRUE)
if true then t2 else t3 -> t2
```

```ocaml
-------------------------------- (E-IFFALSE)
if false then t2 else t3 -> t3
```

```ocaml
t1 -> t1'
------------------------------------------------(E-IF)
if t1 then t2 else t3 -> if t1' then t2 else t3
```

```ocaml
n1 [[+]] n2 = n
----------------------------------------------(E-PLUS)
n1 + n2 -> n
```

```ocaml
 t1 -> t1'
---------------------------------------- (E-PLUS1)
t1 + t2 -> t1' + t2
```

```ocaml
 t2 -> t2'
----------------------------------------- (E-PLUS2)
v1 + t2  -> v1 + t2'
```

```ocaml
n1 [[>]] n2 = b
------------------------------------------(E-GT)
n1>n2 -> b
```

```ocaml
t1 -> t1'
-------------------------------------------(E-GT1)
t1 > t2 -> t1' > t2
```

```ocaml
t2 -> t2'
--------------------------------------------(E-GT2)
v1 > t2 -> v1 > t2'
```



# Compile and run


Use the following command to compile ocaml program to executable binary and run:

```bash
ocamlc -o hm1.exe hm1.ml
./hw1.exe
```
