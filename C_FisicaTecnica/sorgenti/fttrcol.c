// Disegna il Triangolo dei Colori (fttrcol.c) //

void TriangoloColori(void);
void TestoColori(void);

void TriangoloColori(void)
{
  int i;
  int cifre=2;
  char str[5];
  float x[]={
    .2839,.3285,.3483,.3481,.3362,.3187,.2908,.2511,.1954,.1421,
    .0956,.0580,.0320,.0147,.0049,.0024,.0093,.0291,.0633,.1096,
    .1655,.2257,.2904,.3597,.4334,.5121,.5945,.6784,.7621,.8425 };
  float y[]={
    .0116,.0168,.0230,.0298,.0380,.0480,.0600,.0739,.0910,.1126,
    .1390,.1693,.2080,.2586,.3230,.4073,.5030,.6082,.7100,.7932,
    .8620,.9149,.9540,.9803,.9950,1.0002,9950,.9786,.9520,.9154 };
  float z[]={
    1.3856,1.6230,1.7471,1.7826,1.7721,1.7441,1.6692,1.5281,1.2876,1.0419,
    .8130,.6162,.4652,.3533,.2720,.2123,.1582,.1117,.0782,.0573,
    .0422,.0298,.0203,.0134,.0087,.0057,.0039,.0027,.0021,.0018 };

  float x1[]={.3,.1,.12,.2,.32,.5};
  float y1[]={.15,.4,.55,.6,.55,.3};

  settextstyle(DEFAULT_FONT,HORIZ_DIR,1);
  setcolor(WHITE);
  setlinestyle(SOLID_LINE,SOLID_FILL,3);

  line(60,400,60,100);
  line(60,100,360,400);
  line(360,400,60,400);

  setlinestyle(SOLID_LINE,SOLID_FILL,1);
  moveto((x[1]/(x[1]+y[1]+z[1]))*300+60,400);
  for(i=1;i<26;i++)
    lineto((x[i]/(x[i]+y[i]+z[i]))*300+60,-(y[i]/(x[i]+y[i]+z[i]))*300+400);

  moveto(x1[1]*300+60,-y1[1]*300+400);
  for(i=2;i<6;i++)
    lineto(x1[i]*300+60,-y1[i]*300+400);

  line(62,227,95,233);
  line(70,298,172,212);
  line(90,280,164,374);
  line(148,232,230,270);
  line(148,354,211,310);
  line(211,310,218,348);
  line(108,400,279,319);

  setfillstyle(SOLID_FILL,GREEN);
  floodfill(120,190,WHITE);
  setfillstyle(SOLID_FILL,CYAN);
  floodfill(90,250,WHITE);
  setfillstyle(SOLID_FILL,BLUE);
  floodfill(120,385,WHITE);
  setfillstyle(SOLID_FILL,MAGENTA);
  floodfill(180,355,WHITE);
  setfillstyle(SOLID_FILL,RED);
  floodfill(240,310,WHITE);
  setfillstyle(SOLID_FILL,YELLOW);
  floodfill(190,250,WHITE);
  setfillstyle(SOLID_FILL,WHITE);
  floodfill(150,290,WHITE);
  floodfill(100,240,WHITE);

  setlinestyle(SOLID_LINE,SOLID_FILL,3);

  for(i=0;i<9;i++)
    { line(60,i*30+130,i*30+90,i*30+130);
      gcvt(i+1,cifre,str);
      outtextxy(30,-i*30+370,"0.");
      outtextxy(45,-i*30+370,str);

      line(30*i+90,400,30*i+90,30*i+130);
      outtextxy(30*i+81,420,"0.");
      outtextxy(30*i+96,420,str);

      outtextxy(-30*i+328,-30*i+360,"0.");
      outtextxy(-30*i+343,-30*i+360,str);
    }

  setcolor(YELLOW);
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,3);
  outtextxy(50,410,"x");
  outtextxy(25,90,"y");
  outtextxy(365,375,"z");
  setcolor(WHITE);
}

void TestoColori(void)
{
  settextstyle(DEFAULT_FONT,HORIZ_DIR,1);
  outtextxy(130,100,"Tutte le possibili cromaticit… sono rappresentate sul");
  outtextxy(145,115,"triangolo C.I.E. (1939), qui schematizzato in 8 colori.");
  outtextxy(160,130,"Ad ogni colore corrisponde una proporzione opportuna di");
  outtextxy(175,145,"3 colori fondamentali, le cui frazioni possono essere");
  outtextxy(190,160,"lette come coordinate cromatiche (x,y,z).");
  outtextxy(205,175,"Poich‚ risulta  x+y+z=1 , note 2 coordinate la terza");
  outtextxy(220,190,"risulta univocamente determinata ; come Š visibile,");
  outtextxy(235,205,"all'annullarsi di 2 coordinate non corrisponde");
  outtextxy(250,220,"alcun colore reale.");
  outtextxy(265,235,"Il baricentro del triangolo rappresenta il");
  outtextxy(280,250,"bianco perfetto, in cui tutte le radiazioni");
  outtextxy(295,265,"delle varie lunghezze d'onda presentano");
  outtextxy(310,280,"la stessa energia.");
  setcolor(RED);
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,5);
  outtextxy(400,320,"Triangolo");
  outtextxy(445,365,"C.I.E.");
}