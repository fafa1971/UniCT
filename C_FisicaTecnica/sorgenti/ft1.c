// Cicli Diretti (ft1.c) //

extern void Titolo(char *stringa);
void Pompa(int x,int y);
void Turbina(int x,int y);
void Condensatore(int x,int y);
void Impianto(void);
void Grafico(void);
void Animazione(void);
void SpiegaTrasf0(void);
void SpiegaTrasf1(void);
void SpiegaTrasf2(void);
void SpiegaTrasf3(void);
void CicliDiretti(void);

int trasformazione,trasf_preced;

void Pompa(int x,int y)
{
  int triangolo[]={x,y-10,x+9,y+5,x-9,y+5};
  fillellipse(x,y-1,12,12);
  fillpoly(3,triangolo);
}

void Caldaia(int x,int y)
{
  bar(x,y+60,x+40,y);
  rectangle(x,y+60,x+40,y);
  line(x,y+50,x+40,y+50);
  line(x+10,y+60,x+10,y+50);
  line(x+20,y+60,x+20,y+50);
  line(x+30,y+60,x+30,y+50);
}

void Turbina(int x,int y)
{
  int trapezio[]={x,y,x+30,y-20,x+30,y+60,x,y+40};
  fillpoly(4,trapezio);
}

void Condensatore(int x,int y)
{
  int poligono[]={x-12,y+20,x-5,y-5,x,y+5,x+5,y-5,x+12,y+20};
  fillellipse(x,y,12,12);
  drawpoly(5,poligono);
}

void Impianto(void)
{
  int linea0[]={50,208,50,130,130,130};
  int linea1[]={170,130,230,130,230,200};
  int linea2[]={260,260,260,300,162,300};
  int linea3[]={138,300,50,300,50,232};

  setcolor(YELLOW);
  setbkcolor(BLACK);
  setlinestyle(SOLID_LINE,SOLID_FILL,3);
  setfillstyle(SOLID_FILL,BLUE);
  Pompa(50,220);
  Caldaia(130,100);
  Turbina(230,200);
  Condensatore(150,300);
  drawpoly(3,linea0);
  drawpoly(3,linea1);
  drawpoly(3,linea2);
  drawpoly(3,linea3);
}

void Grafico(void)
{
  int verticex[]={550,295,550,305,558,300};
  int verticey[]={345,100,355,100,350,92};

  int grafico[]={ 360,280,380,270,400,250,430,150,
		  447,135,470,135,510,155,540,160 };

  setcolor(WHITE);
  setlinestyle(SOLID_LINE,SOLID_FILL,1);
  setfillstyle(SOLID_FILL,WHITE);

  line(350,300,550,300);
  line(350,300,350,100);   /* disegna gli assi */
  fillpoly(3,verticex);
  fillpoly(3,verticey);
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,2);
  outtextxy(330,100,"h");
  outtextxy(540,300,"s");

  drawpoly(8,grafico);     /* disegna la curva del vapore */

  setcolor(LIGHTGRAY);
  setlinestyle(DASHED_LINE,SOLID_FILL,1);
  line(380,270,350,270);   /* traccia le proiezioni sull'asse h */
  line(380,250,350,250);
  line(510,110,350,110);
  line(510,180,350,180);
}

void Animazione(void)
{
  int trasf0[]={380,270,380,250};
  int trasf1[]={380,250,510,110};
  int trasf2[]={510,110,510,180};
  int trasf3[]={510,180,380,270};

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

  setcolor(YELLOW);        /* fa ritornare blu il componente precedente */
  trasf_preced=trasformazione-1;
  setfillstyle(SOLID_FILL,BLUE);
  switch(trasf_preced)
  { case 0: Pompa(50,220); break;
    case 1: Caldaia(130,100); break;
    case 2: Turbina(230,200); break;
    case 3: Condensatore(150,300); break; }

  setfillstyle(SOLID_FILL,RED);
  switch(trasformazione)   /* colora rosso il componente corrente */
  { case 0: Pompa(50,220); break;
    case 1: Caldaia(130,100); break;
    case 2: Turbina(230,200); break;
    case 3: Condensatore(150,300); break; }

  setfillstyle(SOLID_FILL,BLACK);
  bar(0,350,640,440);      /* cancella la parte bassa dello schermo */
  setcolor(WHITE);	   /* scrive la spiegazione delle trasformazioni */
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,3);
  switch(trasformazione)
  { case 0: SpiegaTrasf0(); break;
    case 1: SpiegaTrasf1(); break;
    case 2: SpiegaTrasf2(); break;
    case 3: SpiegaTrasf3(); break; }
}

void SpiegaTrasf0(void)
{
  outtextxy(10,350,"Nella POMPA il vapore viene compresso.");
  outtextxy(10,380,"La variazione entalpica coincide col lavoro negativo");
  outtextxy(10,410,"di ciclo compiuto dalla pompa.");
}

void SpiegaTrasf1(void)
{
  outtextxy(10,350,"Nella CALDAIA il vapore viene riscaldato e cambia fase.");
  outtextxy(10,380,"La variazione entalpica coincide col calore positivo");
  outtextxy(10,410,"di ciclo ceduto dalla caldaia al vapore.");
}

void SpiegaTrasf2(void)
{
  outtextxy(10,350,"Nella TURBINA il vapore si espande adiabaticamente.");
  outtextxy(10,380,"La variazione entalpica coincide col lavoro positivo");
  outtextxy(10,410,"di ciclo compiuto dalla turbina.");
}

void SpiegaTrasf3(void)
{
  outtextxy(10,350,"Nel CONDENSATORE il vapore cambia di fase.");
  outtextxy(10,380,"La variazione entalpica coincide col calore negativo");
  outtextxy(10,410,"di ciclo ceduto dal vapore allo scambiatore.");
}

void CicliDiretti(void)
{
  cleardevice();
  Titolo("Cicli Diretti");
  Impianto();
  Grafico();
  for(trasformazione=0;trasformazione<4;trasformazione++)
    {
      Animazione();
      sound((trasformazione+1)*1000);
      delay(30);
      nosound();
      getch();
    }
  cleardevice();
}
