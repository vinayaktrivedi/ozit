declare AST

%AST = [var ident(x) [ [var ident(y) [var ident(x) [bind ident(x) literal(10)]]] [bind ident(x) literal(10)] ]  ]
%AST = [var ident(x) [var ident(y) [[bind ident(x) [record literal(tuple) [[literal(h) literal(1)] [literal(y) ident(y)]]]] [bind ident(y) ['proc' [ident(x)] [bind ident(x) literal(2)]]]]]]     
%AST = [var ident(x) [var ident(z) [bind ident(x) ['proc' [ident(w)] [var ident(y) [bind ident(y) ['proc' [ident(a)] [bind ident(z) literal(2)]]]]]]]]
%AST = [var ident(a) [var ident(x) [[var ident(y) [[  bind ident(y) ['proc' [ident(y) ident(z)] [[bind ident(z) literal('hello')] [bind ident(y) ['proc' [ident(z)] [bind ident(x) ident(z)]]    ] ]]   ] [   bind ident(a) [record literal(tuple) [[literal(a) literal(1)] [literal(b) ident(a)]]]    ]]] [var ident(b) [bind ident(b) [record literal(tuple) [[literal(a) ident(b)] [literal(b) ident(a)]]]] ] [bind ident(x) literal(100)] ]]]

%AST = [var ident(x) [var ident(y) [var ident(z) [[bind ident(y) literal(10)] [bind ident(z) literal(25)] [bind ident(x) [product ident(y) ident(z)]]]]]]

%AST = [var ident(x) [var ident(y) [[bind ident(x) [record literal(rr) [[literal(a) literal(10)] [literal(b) literal(20)]]]] [match ident(x) [record literal(rr) [[literal(a) ident(z)] [literal(b) ident(q)]]] [bind ident(y) literal(100)] [bind ident(y) literal(200)] ] ] ]]

%AST = [var ident(x) [var ident(c) [var ident(y) [[bind ident(c) literal(true)] [bind ident(x) literal(10)] [conditional ident(c) [bind ident(y) literal(30)] [bind ident(y) literal(40)] ]]]]]

%AST = [var ident(z) [var ident(a) [var ident(b) [var ident(d) [bind ident(d) ['proc' [ident(x) ident(y)] [bind ident(z) [record literal(map) [[literal(i1) ident(a)] [literal(i2) ident(b)]]]]]]]]]]

%AST = [var ident(z) [[var ident(z) [var ident(x) [[bind ident(z) literal(true)] [bind ident(x) ['proc' [ident(x) ident(y)] [conditional ident(z) [bind ident(x) ident(z)] [bind ident(y) ident(z)]]]]] ]] [var ident(z) [bind ident(z) literal(100)]]] ]

%AST = [var ident(x) [var ident(z) [[bind ident(z) ['proc' [ident(y)] [bind ident(y) ident(x)]]] [apply ident(z) ident(x)]]]]

%AST = [var ident(x) [[var ident(y) [[bind ident(y) literal(2)] [bind ident(x) ['proc' [ident(a)] [bind ident(a) ident(y)]]]]] [var ident(y) [var ident(b) [[bind ident(y) literal(100)] [apply ident(x) ident(b)]]]]]]

%AST = [var ident(x) [[var ident(y) [var ident(d) [[bind ident(y) literal(2)] [bind ident(d) literal(3)] [bind ident(x) ['proc' [ident(k) ident(a)] [conditional ident(k) [bind ident(a) ident(y)][bind ident(a) ident(d)]]]]]]] [var ident(y) [var ident(b) [[bind ident(y) literal(true)] [apply ident(x) ident(y) ident(b)]]]]]]

%AST = [var ident(x) [var ident(y) [[bind ident(x) [record literal(map) [[literal(name) literal(10)][literal(2) literal(14)]]]] [match ident(x) [record literal(map) [[literal(name) ident(a)] [literal(3) ident(b)]]] [bind ident(y) literal(10)] [match ident(x) [record literal(map) [[literal(name) ident(c)] [literal(2) ident(d)]]] [bind ident(y) literal(20)] [bind ident(y) literal(30)]]]]]]
