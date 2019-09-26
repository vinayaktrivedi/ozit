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

declare AST Env Stmt Bind
AST = [var ident(x) [ [var ident(y) [var ident(x) [bind ident(x) literal(10)]]] [bind ident(x) literal(10)] ]  ]

Env = {Dictionary.new}
{Push tuple(sem:AST env:Env) SStack}
Stmt = {NewCell nil}

proc {Bind X Y Env}
   {Unify X Y Env}
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