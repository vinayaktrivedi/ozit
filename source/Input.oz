declare AST

%AST = [var ident(x) [ [var ident(y) [var ident(x) [bind ident(x) literal(10)]]] [bind ident(x) literal(10)] ]  ]
%AST = [var ident(x) [var ident(y) [[bind ident(x) [record literal(tuple) [[literal(h) literal(1)] [literal(y) ident(y)]]]] [bind ident(y) ['proc' [ident(x)] [bind ident(x) literal(2)]]]]]]     
%AST = [var ident(x) [var ident(z) [bind ident(x) ['proc' [ident(w)] [var ident(y) [bind ident(y) ['proc' [ident(a)] [bind ident(z) literal(2)]]]]]]]]
%AST = [var ident(a) [var ident(x) [[var ident(y) [[  bind ident(y) ['proc' [ident(y) ident(z)] [[bind ident(z) literal('hello')] [bind ident(y) ['proc' [ident(z)] [bind ident(x) ident(z)]]    ] ]]   ] [   bind ident(a) [record literal(tuple) [[literal(a) literal(1)] [literal(b) ident(a)]]]    ]]] [var ident(b) [bind ident(b) [record literal(tuple) [[literal(a) ident(b)] [literal(b) ident(a)]]]] ] [bind ident(x) literal(100)] ]]]

AST = [var ident(x) [var ident(y) [var ident(z) [[bind ident(y) literal(10)] [bind ident(z) literal(25)] [bind literal(x) [sum ident(y) ident(z)]]]]]]