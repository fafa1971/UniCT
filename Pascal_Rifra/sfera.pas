Program Gomitolo;
Uses Graph,Crt;
const r=100;punti=200;
Type coordinata=array[0..200] of record
                                  xp,yp:integer
                                end;
Var coordinate:coordinata;
    Poli:^coordinata;
    Poli2:^coordinata;
    xint,yint,xneint,xne,yneint,z,rp:integer;
    x,y:real;n:integer;
    Video,Modo:integer;
Procedure Inizializza;
Begin
  Video:=EGA;
  Modo:=EGAHi;
  InitGraph(Video,Modo,'');
end;
Function f(x:real):real;
Begin
  f:=sqrt(sqr(rp)-x*x);
end;
Begin
   Inizializza;
   For z:=0 to 40 do begin
    rp:=trunc(sqrt(sqr(r)-sqr(r-5*z)));
   For n:=-rp to rp do begin
    x:=n;
    y:=f(x);
    xint:=trunc(x+y*sqrt(2)/4);
    yint:=trunc(y*sqrt(2)/4);
    poli^[n+rp].xp:=xint+200;
    poli^[n+rp].yp:=yint+200+5*z end;
    SetColor(14);
    DrawPoly(n+rp,poli^);
   For xne:=rp downto -rp do begin
    yneint:=trunc(-f(xne)*sqrt(2)/4);
    xneint:=trunc(xne-f(xne)*sqrt(2)/4);
    poli2^[-xne+rp].xp:=xneint+200;
    poli2^[-xne+rp].yp:=yneint+200+5*z end;
    SetColor(6);
    Drawpoly(-xne+rp,poli2^)
end;
   Repeat until keypressed;end.
