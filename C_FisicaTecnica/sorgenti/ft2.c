// Cicli Inversi (ft2.c) //

extern void Titolo(char *stringa);
void Laminatore(int x,int y);
void Evaporatore(int x,int y);
void Compressore(int x,int y);
void InvCondensatore(int x,int y);
void InvImpianto(void);
void InvGrafico(void);
void InvAnimazione(void);
void InvSpiegaTrasf0(void);
void InvSpiegaTrasf1(void);
void InvSpiegaTrasf2(void);
void InvSpiegaTrasf3(void);
void CicliInversi(void);

void Laminatore(int x,int y)
{
  line(x-5,y,x+5,y);
  line(x-5,y+15,x+5,y+15);
  line(x-5,y,x+5,y+15);
  line(x+5,y,x-5,y+15);
}

void Evaporatore(int x,int y)
{
  int spezzata[]={ x,y,x+5,y-5,x+15,y+5,x+25,y-5,x+35,y+5,
		   x+45,y-5,x+55,y+5,x+65,y-5,x+75,y+5,x+80,y };
  drawpoly(10,spezzata);
}

void Compressore(int x,int y)
{
  line(x-20,y,x+20,y);
  line(x+20,y,x+20,y+50);
  line(x+20,y+50,x-20,y+50);

  rectangle(x-20,y+5,x,y+45);
  line(x-20,y+25,x-40,y+25);
}

void InvCondensatore(int x,int y)
{
  int spezzata[]={ x,y,x+5,y-5,x+15,y+5,x+25,y-5,x+35,y+5,
		   x+45,y-5,x+55,y+5,x+65,y-5,x+75,y+5,x+80,y };
  drawpoly(10,spezzata);
}

void InvImpianto(void)
{
  int linea0[]={110,130,50,130,50,207};
  int linea1[]={50,222,50,300,110,300};
  int linea2[]={190,300,250,300,250,240};
  int linea3[]={250,190,250,130,190,130};

  setcolor(YELLOW);
  setbkcolor(BLACK);
  setlinestyle(SOLID_LINE,SOLID_FILL,3);
  Laminatore(50,207);
  Evaporatore(110,300);
  Compressore(250,190);
  InvCondensatore(110,130);
  drawpoly(3,linea0);
  drawpoly(3,linea1);
  drawpoly(3,linea2);
  drawpoly(3,linea3);
}

void InvGrafico(void)
{
  int verticex[]={550,295,550,305,558,300};
  int verticey[]={345,100,355,100,350,92};

  int grafico[]={ 360,280,370,260,390,200,410,160,440,140,480,140,
		  500,160,510,180,500,200,490,230,490,280 };

  setcolor(WHITE);
  setlinestyle(SOLID_LINE,SOLID_FILL,1);
  setfillstyle(SOLID_FILL,WHITE);

  line(350,300,550,300);
  line(350,300,350,100);   /* disegna gli assi */
  fillpoly(3,verticex);
  fillpoly(3,verticey);
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,2);
  outtextxy(330,100,"p");
  outtextxy(540,300,"h");

  drawpoly(11,grafico);     /* disegna la curva del vapore */

  setcolor(LIGHTGRAY);
  setlinestyle(DASHED_LINE,SOLID_FILL,1);
  line(390,260,390,300);   /* traccia le proiezioni sull'asse h */
  line(490,260,490,300);
  line(525,200,525,300);
}

void InvAnimazione(void)
{
  int trasf0[]={390,200,390,260};
  int trasf1[]={390,260,490,260};
  int trasf2[]={490,260,525,200};
  int trasf3[]={525,200,390,200};

  setcolor(CYAN);
  setlinestyle(SOLID_LINE,SOLID_FILL,3);
  drawpoly(2,trasf0);      /* ogni volta tutte le trasf.sono celesti */
  drawpoly(2,trasf1);
  drawpoly(2,trasf2);
  drawpoly(2,trasf3);

  setcolor(RED);
  switch(trasformazione)   /* colora rossa la trasformazione corrente */
  { case 0: drawpoly(2,trasf0); break;
    case 1: drawpoly(2,trasf1); break;
    case 2: drawpoly(2,trasf2); break;
    case 3: drawpoly(2,trasf3); break; }

  setcolor(YELLOW);        /* fa ritornare giallo il componente precedente */
  trasf_preced=trasformazione-1;
  switch(trasf_preced)
  { case 0: Laminatore(50,207); break;
    case 1: Evaporatore(110,300); break;
    case 2: Compressore(250,190); break;
    case 3: InvCondensatore(110,130); break; }

  setcolor(RED);
  switch(trasformazione)   /* colora rosso il componente corrente */
  { case 0: Laminatore(50,207); break;
    case 1: Evaporatore(110,300); break;
    case 2: Compressore(250,190); break;
    case 3: InvCondensatore(110,130); break; }

  setfillstyle(SOLID_FILL,BLACK);
  bar(0,350,640,440);      /* cancella la parte bassa dello schermo */
  setcolor(WHITE);	   /* scrive la spiegazione delle trasformazioni */
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,3);
  switch(trasformazione)
  { case 0: InvSpiegaTrasf0(); break;
    case 1: InvSpiegaTrasf1(); break;
    case 2: InvSpiegaTrasf2(); break;
    case 3: InvSpiegaTrasf3(); break; }
}

void InvSpiegaTrasf0(void)
{
  outtextxy(10,350,"Nella VALVOLA DI LAMINAZIONE il vapore si espande");
  outtextxy(10,380,"isoentalpicamente.");
  outtextxy(10,410,"Non viene dunque compiuto lavoro positivo di ciclo.");
}

void InvSpiegaTrasf1(void)
{
  outtextxy(10,350,"Nell'EVAPORATORE il vapore viene riscaldato e cambia");
  outtextxy(10,380,"fase. La variazione entalpica coincide col calore");
  outtextxy(10,410,"positivo di ciclo ceduto al vapore.");
}

void InvSpiegaTrasf2(void)
{
  outtextxy(10,350,"Nel COMPRESSORE il vapore Š compresso");
  outtextxy(10,380,"adiabaticamente. La variazione entalpica coincide col");
  outtextxy(10,410,"lavoro negativo di ciclo compiuto dal compressore.");
}

void InvSpiegaTrasf3(void)
{
  outtextxy(10,350,"Nel CONDENSATORE il vapore cambia di fase.");
  outtextxy(10,380,"La variazione entalpica coincide col calore negativo");
  outtextxy(10,410,"di ciclo ceduto dal vapore allo scambiatore.");
}

void CicliInversi(void)
{
  cleardevice();
  Titolo("Ciclo Inverso a Vapore");
  InvImpianto();
  InvGrafico();
  for(trasformazione=0;trasformazione<4;trasformazione++)
    {
      InvAnimazione();
      sound((trasformazione+1)*1000);
      delay(30);
      nosound();
      getch();
    }
  cleardevice();
}
