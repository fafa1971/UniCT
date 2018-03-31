program cerchio;
uses graph,crt ;
const detect=0;
var
   j,modo,r,x,y,c:integer;
  procedure  cer  ;
  begin
    initgraph(j,modo ,'');
    setcolor(c);

    arc(x,y,275,360,r);
  end;
  begin
    j:=detect;
    modo:=2 ;

    write('x: ');readln(x);
    write('y: ');readln(y) ;
    write('r: ');readln(r);
    write('c: ');readln(c);
    cer;
    repeat until readkey<>#0;
    closegraph;
   end.


