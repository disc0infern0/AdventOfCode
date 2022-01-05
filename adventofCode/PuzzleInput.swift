// 10 unique paths visiting small caves at most once
/*
      start
      /   \
 c - A  -  b - d
      \   /
       end
 */
let testData1 = """
start-A
start-b
A-c
A-b
b-d
A-end
b-end
"""

/*
// 19 unique paths visiting small caves at most once

LN - dc ---------
    / | \        \
   /  |  start - kj - sa
  /   |  /        |
end   | /         |
  \___HN--+-------/

  dc - end -
*/
let testData2 = """
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
"""

// 226 unique paths visiting small caves at most once
let testData3 = """
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW
"""

let puzzleData = """
LP-cb
PK-yk
bf-end
PK-my
end-cb
BN-yk
cd-yk
cb-lj
yk-bf
bf-lj
BN-bf
PK-cb
end-BN
my-start
LP-yk
PK-bf
my-BN
start-PK
yk-EP
lj-BN
lj-start
my-lj
bf-LP
"""
