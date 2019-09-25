declare SStack Push Pop SAS
SStack = {NewCell nil}
SAS = {Dictionary.new}

fun {Push Cont Stack}
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

declare AST Env Stmt
AST = [[nop] [nop] [nop]]

Env = {Dictionary.new}
{Push tuple(sem:AST env:Env) SStack}
Stmt = {NewCell nil}

declare
fun {Execute}
   {Browse @SStack}
   Stmt:={Pop SStack}
   case @Stmt
   of nil then skip
   else case @Stmt.sem
        of [nop] then {Execute}
        [] [var ident(X) S] then skip
        [] [bind X Y] then skip
        [] S1|S2 then
           case S2
           of nil then skip
           else {Push tuple(sem:S2 env:@Stmt.env) SStack}
           end
           {Push tuple(sem:S1 env:@Stmt.env) SStack}
           {Execute}    
        else skip
        end
   end
end

