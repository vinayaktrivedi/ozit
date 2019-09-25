declare Stack
Stack = {Stack.new}
declare
fun {NopOnly AST}
   case AST of
      H|T then local Env in Env={Dictionary.new} {StackPut Stack tuple(sem:H env:Env)} end {NopOnly T}
   else skip
   end
end

declare
fun {Execute S}
   case S of
      H|T then case H.sem of
		  nop then {Execute T}
	       else skip
	       end
   else skip
   end
end

