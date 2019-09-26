\insert 'Unify.oz'
\insert 'Input.oz'

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

declare Env Stmt Bind CalClo

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
	    else raise varNotFound(X) end
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
	    {Show ['Free' X {Dictionary.entries Free}]}
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