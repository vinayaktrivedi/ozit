% Need to write SAS code
declare SASKey SAS AddSASKey
SAS = {Dictionary.new}
SASKey = {NewCell 0}

fun {AddSASKey}
   SASKey := @SASKey + 1
   {Dictionary.put SAS @SASKey equivalence(@SASKey)}
   @SASKey
end

fun { RetrieveFromSAS SASKey}
	local Val in
		Val = {Dictionary.get SAS SASKey}
		case Val of
			reference(Y) then {RetrieveFromSAS Y}
		else Val
		end
	end

end

proc {BindRefToKeyInSAS Main Subs}
	if Main == Subs then skip
	else {Dictionary.put SAS Subs reference(Main)}
	end
end

proc {BindValueToKeyInSAS Key Val}
	{Dictionary.put SAS Key Val}
end


	



