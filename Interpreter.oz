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
AST = [var ident(x) [ [var ident(y) [var ident(x) [bind ident(x) literal(10)]]] [bind ident(x) literal(10)] ]  ]

Env = {Dictionary.new}
{Push tuple(sem:AST env:Env) SStack}
Stmt = {NewCell nil}

fun {FindFV Stmt Env BV FV}
   case Stmt
   of H|T then {FindFV H Env BV {FindFV T Env BV FV}}   
   [] ident(X) then
      if {List.member ident(X) BV} then FV
      else
	 if {Dictionary.member FV X} then FV
	 else
	    if {Dictionary.member Env X} then
	       {Dictionary.put FV X {Dictionary.get Env X}}
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
   of [proce Xs S] then
      local Val CDict Free in
	 CDict = {Dictionary.new}
	 Free = {CalClo S Env Xs CDict}
	 Val = [proce Xs S Free]
	 {Unify X Val Env}
      end
   else {Unify X Y Env}
   end
end

declare
proc {Execute}
   {Browse @SStack}
   {Browse {Dictionary.entries SAS}}
   Stmt:={Pop SStack}
   case @Stmt
   of nil then skip
   else
      {Browse {Dictionary.entries @Stmt.env}}
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