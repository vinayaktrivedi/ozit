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


%AST = [var ident(x) [var ident(y) [[bind ident(x) [record literal(rr) [[literal(a) literal(10)] [literal(b) literal(20)]]]] [match ident(x) [record literal(rr) [[literal(a) ident(z)] [literal(b) ident(h)]]] [bind ident(y) ident(h)] [bind ident(y) literal(100)] ] ] ]]

%AST = [var ident(x) [[var ident(y) [var ident(d) [[bind ident(y) literal(2)] [bind ident(d) literal(3)] [bind ident(x) ['proc' [ident(k) ident(a)] [conditional ident(k) [bind ident(a) [sum ident(d) ident(y)]] [bind ident(a) [product ident(d) ident(y)]]]]]]]] [var ident(y) [var ident(b) [[bind ident(y) literal(true)] [apply ident(x) ident(y) ident(b)]]]]]]

%AST = [var ident(r) [var ident(x) [var ident(y) [var ident(z) [[bind ident(z) ['proc' [ident(c)] [match ident(x) [record literal(val) [[literal(left) ident(x)][literal(right) ident(y)]]] [bind ident(c) [sum ident(x) ident(y)]] [bind ident(c) [sum ident(y) ident(y)]]]]] [bind ident(x) [record literal(val) [[literal(left) literal(10)] [literal(riht) literal(20)]]]] [bind ident(y) literal(30)] [apply ident(z) ident(r)]]]]]]

AST = [var ident(x) [var ident(p1) [[bind ident(p1) ['proc' [ident(y)] [var ident(p2) [[bind ident(p2) ['proc' [ident(z)] 
    [conditional ident(z) [bind ident(y) [product ident(x) ident(x)] ] [bind ident(y) ident(z)]]]] [var ident(w) [[bind ident(w) literal(false)]
    [apply ident(p2) ident(w)]]]]]]] [bind ident(x) literal(10)] [var ident(x) [apply ident(p1) ident(x)]]]]]