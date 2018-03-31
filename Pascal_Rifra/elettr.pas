program prova;
uses Graph,Crt;
var Display,Modo,wait,xi,k,yi,yneg,x,nex,nexi,neyi,z:integer;Tasto:char;
    y,ney:real;
begin
     Display:=EGA;
     Modo:=EGAHi;
     InitGraph(Display,Modo,'');
  Repeat
      k:=100;
     for x:=-k to k do begin
      y:=sqrt(-sqr(x)+sqr(k));
      xi:=x+200+trunc(y*sqrt(2)/4);
      yi:=trunc(y*sqrt(2)/4)+100;
      nex:=-x;
      ney:=-sqrt(-sqr(nex)+sqr(k));
      nexi:=nex+200+trunc(ney*sqrt(2)/4);
      neyi:=trunc(ney*sqrt(2)/4)+100;
      setcolor(15);line(xi,yi,nexi,neyi);
      putpixel(xi,yi,10);
      putpixel(nexi,neyi,10);
      for wait:=1 to 10000 do begin end;
      Setcolor(0);line(xi,yi,nexi,neyi);
      putpixel(xi,yi,5);
      putpixel(nexi,neyi,5);
      setcolor(15);Line(200,0,200,200);
     end
  Until Keypressed
end.
