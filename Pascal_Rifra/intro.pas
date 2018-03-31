Program Introduzione;
Uses Graph,Crt;
Var a,b,Opzione,OpzPreced:integer;tasto:char;

Begin
a:=3;b:=1;
Initgraph(a,b,'');
SetBkColor(0);

SetFillStyle(SolidFill,5);
Bar(150,20,460,110);

SetFillStyle(SolidFill,1);
Bar(160,30,450,100);

SetColor(14);
Rectangle(150,20,460,110);
Rectangle(160,30,450,100);

SetTextStyle(1,0,7);
OutTextXY(180,30,'Rifra 2.0');
SetTextStyle(1,0,4);
OutTextXY(160,120,'di Fabrizio Fazzino');

SetFillStyle( 8,14);
Bar(170,180,440,330);
SetFillStyle(SolidFill,1);
Bar(180,190,430,320);

SetFillStyle(SolidFill,4);
Bar(187,205,420,215);

SetTextStyle(0,0,0);
SetColor(15);
OutTextXY(192,207,'Introduzione alla Rifrazione');
OutTextXY(192,237,'Inserimento dati iniziali...');
OutTextXY(192,267,'Esegue il programma.........');
OutTextXY(192,297,'Ritorna al Sistema Operativo');

Opzione:=1;
Repeat
    Tasto:=Readkey;
    OpzPreced:=Opzione;
    If Tasto=#80 then Opzione:=Opzione+1;
    If Tasto=#72 then Opzione:=Opzione-1;
    If Opzione>4 then Opzione:=1;
    If Opzione<1 then Opzione:=4;
    If Opzione<>OpzPreced then begin
        SetFillStyle(SolidFill,1);
        Bar(187,OpzPreced*30+175,420,OpzPreced*30+185);
        SetFillStyle(SolidFill,4);
        Bar(187,Opzione*30+175,420,Opzione*30+185);

        SetTextStyle(0,0,0);
        SetColor(15);
        OutTextXY(192,207,'Introduzione alla Rifrazione');
        OutTextXY(192,237,'Inserimento dati iniziali...');
        OutTextXY(192,267,'Esegue il programma.........');
        OutTextXY(192,297,'Ritorna al Sistema Operativo');
        end;
Until Tasto=#13;
end.