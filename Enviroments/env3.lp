% environment #3
cell((0,0),0). cell((0,1),0). cell((0,2),32800). cell((0,3),0). cell((0,4),0).
cell((1,0),0). cell((1,1),0). cell((1,2),32800). cell((1,3),0). cell((1,4),0).
cell((2,0),1025). cell((2,1),1025). cell((2,2),33825). cell((2,3),1025). cell((2,4),1025).
cell((3,0),0). cell((3,1),0). cell((3,2),32800). cell((3,3),0). cell((3,4),0).
cell((4,0),0). cell((4,1),0). cell((4,2),32800). cell((4,3),0). cell((4,4),0).

start(agent(0),(2,0),0,dir(e)). 
end(agent(0),(2,4),50).
start(agent(1),(0,2),0,dir(s)). 
end(agent(1),(4,2),50).