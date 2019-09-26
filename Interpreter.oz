
\insert 'Unify.oz'

declare SStack Push Pop
SStack = {NewCell nil}

proc {Push Cont Stack}
   Stack := Cont|@Stack
end

fun {Pop Stack}
   case @Stack
   of nil then nil
   [] H|T then
      Stack := T
      H
   end
end

declare AST Env Stmt Bind CalClo
%AST = [var ident(x) [ [var ident(y) [var ident(x) [bind ident(x) literal(10)]]] [bind ident(x) literal(10)] ]  ]
%AST = [var ident(x) [var ident(y) [[bind ident(x) [record literal(tuple) [[literal(h) literal(1)] [literal(y) ident(y)]]]] [bind ident(y) ['proc' [ident(x)] [bind ident(x) literal(2)]]]]]]     
%AST = [var ident(x) [var ident(z) [bind ident(x) ['proc' [ident(w)] [var ident(y) [bind ident(y) ['proc' [ident(a)] [bind ident(z) literal(2)]]]]]]]]
AST = [var ident(a) [var ident(x) [[var ident(y) [[  bind ident(y) ['proc' [ident(y) ident(z)] [[bind ident(z) literal('hello')] [bind ident(y) ['proc' [ident(z)] [bind ident(x) ident(z)]]    ] ]]   ] [   bind ident(a) [record literal(tuple) [[literal(a) literal(1)] [literal(b) ident(a)]]]    ]]] [var ident(b) [bind ident(b) [record literal(tuple) [[literal(a) ident(b)] [literal(b) ident(a)]]]] ] [bind ident(x) literal(100)] ]]]

Env = {Dictionary.new}
{Push tuple(sem:AST env:Env) SStack}


fun {FindFV Stmt Env BV FV}
   case Stmt
   of ['proc' Xs S] then {CalClo S Env {Append Xs BV} FV}
   [] H|T then {FindFV H Env BV {FindFV T Env BV FV}}
   [] ident(X) then
      if {List.member ident(X) BV} then FV
      else
   if {Dictionary.member FV X} then FV
   else
      if {Dictionary.member Env X} then
         {Dictionary.put FV X {Dictionary.get Env X}}
         FV
      else nil
      end
   end
      end     
   else FV
   end   
end

fun {CalClo Stmt Env BV FV}
   case Stmt
   of nil then FV
   [] [nop] then FV
   [] [var ident(X) S] then {CalClo S Env ident(X)|BV FV}
   [] [bind X Y] then {FindFV X Env BV {FindFV Y Env BV FV}}
   [] H|T then {CalClo H Env BV {CalClo T Env BV FV}}
   end
end

proc {Bind X Y Env}
   case Y
   of ['proc' Xs S] then
      local Val CDict Free in
   CDict = {Dictionary.new}
   Free = {CalClo S Env Xs CDict}
   if Free \= nil then
      {Show ['Free' {Dictionary.entries Free}]}
   end
   Val = ['proc' Xs S Free]
   {Unify X Val Env}
      end
   else {Unify X Y Env}
   end
end

Stmt = {NewCell nil}

declare
proc {Execute}
   {Show ['SStack' @SStack]}
   {Show ['SAS' {Dictionary.entries SAS}]}
   Stmt:={Pop SStack}
   case @Stmt
   of nil then skip
   else
      {Show ['Environment' {Dictionary.entries @Stmt.env}]}
      %{Browse {Dictionary.entries @Stmt.env}}
      case @Stmt.sem
      of [nop] then {Execute}
      [] [var ident(X) S] then
   {Dictionary.put @Stmt.env X {AddSASKey}}
         %{Browse {Dictionary.entries @Stmt.env}}
   {Push tuple(sem:S env:{Dictionary.clone @Stmt.env}) SStack}
   {Execute}
      [] [bind X Y] then
         %{Browse {Dictionary.entries @Stmt.env}}
   {Bind X Y @Stmt.env}
   {Execute}
      [] S1|S2 then
   case S2
   of nil then skip
   else
      {Push tuple(sem:S2 env:{Dictionary.clone @Stmt.env}) SStack}
   end
   {Push tuple(sem:S1 env:{Dictionary.clone @Stmt.env}) SStack}
   {Execute}
      else skip
      end
   end
end

{Execute}