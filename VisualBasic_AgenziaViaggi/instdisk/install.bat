@echo off
echo Installazione del programma "Agenzia di Viaggi" per Windows.
echo Dopo la copia dei file rispondere 'Y' alle richieste dello scompattatore.
md c:\viaggi
copy a:\zipped.exe c:\viaggi\*.*
md c:\viaggi\foto
copy a:\foto.exe c:\viaggi\foto\*.*
c:
cd\
cd viaggi
c:\viaggi\zipped.exe
del c:\viaggi\zipped.exe
cd foto
c:\viaggi\foto\foto.exe
del c:\viaggi\foto\foto.exe
cd\
cls
echo Installazione Terminata.
echo Avviare da Windows il programma C:\VIAGGI\VIAGGI.EXE
echo ( Š disponibile l'icona C:\VIAGGI\VIAGGI.ICO )

