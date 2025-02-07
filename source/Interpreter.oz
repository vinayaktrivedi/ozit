\insert 'Unify.oz'
\insert 'Input.oz'
%\insert 'SingleAssignmentStore.oz'

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

proc {AddPatternVars Pattern Env}
   case Pattern of
      H|T then
      case H.2.1 of
	 ident(X) then
	 {Dictionary.put Env X {AddSASKey}}
	 {AddPatternVars T Env}
      else skip
      end
   else skip
   end
end

      
fun {CalClo Stmt Env BV FV}
   case Stmt
   of nil then FV
   [] [nop] then FV
   [] [var ident(X) S] then {CalClo S Env ident(X)|BV FV}
   [] [bind X Y] then {FindFV X Env BV {FindFV Y Env BV FV}}
   [] [conditional ident(X) S1 S2] then
      if {List.member ident(X) BV} then {CalClo S2 Env BV {CalClo S1 Env BV FV}}
      else
	 if {Dictionary.member FV X} then {CalClo S2 Env BV {CalClo S1 Env BV FV}}
	 else
	    if {Dictionary.member Env X} then
	       {Dictionary.put FV X {Dictionary.get Env X}}
	       {CalClo S2 Env BV {CalClo S1 Env BV FV}}
	    else raise varNotFound(X) end
	    end
	 end
      end
   [] [match ident(X) P S1 S2] then
      local NewEnv in
	 NewEnv = {Dictionary.clone Env}
	 if {List.member ident(X) BV} then
	    {AddPatternVars P.2.2.1 NewEnv}
	    {CalClo S1 NewEnv BV {CalClo S2 Env BV FV}}
	 else
	    if {Dictionary.member FV X} then
	       {AddPatternVars P.2.2.1 NewEnv}
	       {CalClo S1 NewEnv BV {CalClo S2 Env BV FV}}
	    else
	       if {Dictionary.member Env X} then
		  {Dictionary.put FV X {Dictionary.get Env X}}
		  {AddPatternVars P.2.2.1 NewEnv}
		  {CalClo S1 NewEnv BV {CalClo S2 Env BV FV}}
	       else raise varNotFound(X) end
	       end
	    end
	 end
      end
   [] apply|ident(X)|Xs then
      if {List.member ident(X) BV} then {FindFV Xs Env BV FV}
      else
	 if {Dictionary.member FV X} then {FindFV Xs Env BV FV}
	 else
	    if {Dictionary.member Env X} then
	       {Dictionary.put FV X {Dictionary.get Env X}}
	       {FindFV Xs Env BV FV}
	    else raise varNotFound(X) end
	    end
	 end
      end
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
	    {Browse ['Free Variables:' X {Dictionary.entries Free}]}
	 end
	 Val = ['proc' Xs S Free]
	 {Unify X Val Env}
      end
   else {Unify X Y Env}
   end
end

proc {MakeProcEnv FreeEnv StmtEnv Xs Xp}
   case Xs
   of H|T then
      local ProcArg Tail in
	 ident(ProcArg)|Tail = Xp
	 case H
	 of ident(X) then
	    if {Dictionary.member StmtEnv X}==true then
	       {Dictionary.put FreeEnv ProcArg StmtEnv.X}
	       {MakeProcEnv FreeEnv StmtEnv T Tail}
	    else raise argumentNotDeclared(X) end
	    end
	 else
	    {Dictionary.put FreeEnv ProcArg {AddSASKey}}
	    {Bind ident(ProcArg) H FreeEnv}
	    {MakeProcEnv FreeEnv StmtEnv T Tail}
	 end
      end
   else skip
   end
end

declare
fun {InList L X Env}
   case L
   of nil then false
   [] X1|Xr then
      if X1.1==X.1 then
	 {Bind X1.2.1 X.2.1 Env}
	 true
      else
	 {InList Xr X Env}
      end
   end
end

declare
fun {Subsets L1 L2 Env}
   case L1
   of nil then true
   [] X|Xr then
      if {InList L2 X Env} then
	 {Subsets Xr L2 Env}
      else false
      end
   end
end

declare Line

Stmt = {NewCell nil}
Line = {NewCell 1}

declare
proc {Execute}
   {Browse '-------------------------------------------------------------------------'}
   {Browse @Line}
   Line := @Line + 1
   {Browse ['Semantic Stack:' @SStack]}
   {Browse ['Single Assignment Store:' {Dictionary.entries SAS}]}
   Stmt:={Pop SStack}
   case @Stmt
   of nil then skip
   else
      {Browse ['Environment:' {Dictionary.entries @Stmt.env}]}
      %{Browse {Dictionary.entries @Stmt.env}}
      case @Stmt.sem
      of [nop] then {Execute}
      [] [var ident(X) S] then
	 {Dictionary.put @Stmt.env X {AddSASKey}}
         %{Browse {Dictionary.entries @Stmt.env}}
	 {Push tuple(sem:S env:{Dictionary.clone @Stmt.env}) SStack}
	 {Execute}
      [] [bind X Y] then
	 case Y
	 of [sum ident(Y) ident(Z)] then
	    if {Dictionary.member @Stmt.env Y} andthen {Dictionary.member @Stmt.env Z} then
	       case {RetrieveFromSAS @Stmt.env.Y}
	       of literal(Num1) then
		  case {RetrieveFromSAS @Stmt.env.Z}
		  of literal(Num2) then {Bind X literal(Num1+Num2) @Stmt.env}
		  else raise sumValNotBound(Z) end
		  end
	       else raise sumValNotBound(Y) end
	       end
	    else raise sumValNotDefined() end
	    end
	 [] [product ident(Y) ident(Z)] then
	    if {Dictionary.member @Stmt.env Y} andthen {Dictionary.member @Stmt.env Z} then
	       case {RetrieveFromSAS @Stmt.env.Y}
	       of literal(Num1) then
		  case {RetrieveFromSAS @Stmt.env.Z}
		  of literal(Num2) then {Bind X literal(Num1*Num2) @Stmt.env}
		  else raise productValNotBound(Z) end
		  end
	       else raise productValNotBound(Y) end
	       end
	    else raise productValNotDefined() end
	    end
	 else {Bind X Y @Stmt.env}
	 end
         %{Browse {Dictionary.entries @Stmt.env}}
	 %{Bind X Y @Stmt.env}
	 {Execute}
      [] [match ident(X) P S1 S2] then
	 if {Dictionary.member @Stmt.env X}==true then
	    local CaseDict XVal in
	       CaseDict = {Dictionary.clone @Stmt.env}
	       XVal = {RetrieveFromSAS {Dictionary.get @Stmt.env X}}
	       case P
	       of [record literal(N) L] then
		  {AddPatternVars L CaseDict}
		  case XVal
		  of [record literal(M) K] then
		     if (N == M andthen {Length L} == {Length K}) andthen {Subsets L K CaseDict} then
			{Push tuple(sem:S1 env:CaseDict) SStack}
			{Execute}
		     else
			{Push tuple(sem:S2 env:{Dictionary.clone @Stmt.env}) SStack}
			{Execute}
		     end
		  else
		     raise identNotRecord(X) end
		  end
	       else
		  raise patternNotRecord(P) end
	       end
	    end
	 else raise varNotFoundInEnv(X) end
	 end
      [] apply|ident(F)|Xs then
	 if {Dictionary.member @Stmt.env F}==true then
	    local ProcValue in
	       ProcValue = {RetrieveFromSAS {Dictionary.get @Stmt.env F}}
	       case ProcValue
	       of ['proc' Xp StmtOfProc FreeOfProc] then
		  %{Browse [Xp StmtOfProc FreeOfProc]}
		  if {Length Xp} == {Length Xs} then
		     local NewEnv in
			NewEnv = {Dictionary.clone FreeOfProc}
			try
			   {MakeProcEnv NewEnv @Stmt.env Xs Xp}
			   {Push tuple(sem:StmtOfProc env:NewEnv) SStack}
			   {Execute}
			catch E then
			   raise error(E) end
			end
		     end
		  else
		     raise arityDifferentForProc(ProcValue) end
		  end
	       else raise notaProcedureValue(ProcValue) end
	       end
	    end
	 else raise varNotFoundInEnv(F) end
	 end
      [] [conditional ident(X) S1 S2] then
	 if {Dictionary.member @Stmt.env X} then
	    local Val in
	       Val = {RetrieveFromSAS {Dictionary.get @Stmt.env X}}
	       case Val
	       of literal(true) then {Push tuple(sem:S1 env:{Dictionary.clone @Stmt.env}) SStack}
	       [] literal(false) then {Push tuple(sem:S2 env:{Dictionary.clone @Stmt.env}) SStack}
	       [] equivalence(_) then raise executionSuspend end
	       else raise varNotBoolean(X) end
	       end
	    end	  
	 else
	    raise varNotFoundInEnv(X) end
	 end
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