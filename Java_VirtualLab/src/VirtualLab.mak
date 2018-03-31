# Microsoft Developer Studio Generated NMAKE File, Format Version 4.20
# ** DO NOT EDIT **

# TARGTYPE "Java Virtual Machine Java Workspace" 0x0809

!IF "$(CFG)" == ""
CFG=VirtualLab - Java Virtual Machine Debug
!MESSAGE No configuration specified.  Defaulting to VirtualLab - Java Virtual\
 Machine Debug.
!ENDIF 

!IF "$(CFG)" != "VirtualLab - Java Virtual Machine Release" && "$(CFG)" !=\
 "VirtualLab - Java Virtual Machine Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "VirtualLab.mak"\
 CFG="VirtualLab - Java Virtual Machine Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "VirtualLab - Java Virtual Machine Release" (based on\
 "Java Virtual Machine Java Workspace")
!MESSAGE "VirtualLab - Java Virtual Machine Debug" (based on\
 "Java Virtual Machine Java Workspace")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 
################################################################################
# Begin Project
# PROP Target_Last_Scanned "VirtualLab - Java Virtual Machine Debug"
JAVA=jvc.exe

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir ""
# PROP BASE Intermediate_Dir ""
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir ""
# PROP Intermediate_Dir ""
# PROP Target_Dir ""
OUTDIR=.
INTDIR=.

ALL : "$(OUTDIR)\VirtualLab.class" "$(OUTDIR)\VirtualLab.dep"\
 "$(OUTDIR)\LoginDialog.class" "$(OUTDIR)\LoginDialog.dep"\
 "$(OUTDIR)\LabClient.class" "$(OUTDIR)\LabClient.dep"\
 "$(OUTDIR)\SingleLabServer.class" "$(OUTDIR)\SingleLabServer.dep"\
 "$(OUTDIR)\OutputFrame.class" "$(OUTDIR)\OutputFrame.dep"\
 "$(OUTDIR)\InputFrame.class" "$(OUTDIR)\InputFrame.dep"\
 "$(OUTDIR)\addUser.class" "$(OUTDIR)\addUser.dep" "$(OUTDIR)\listUsers.class"\
 "$(OUTDIR)\listUsers.dep" "$(OUTDIR)\FileManager.class"\
 "$(OUTDIR)\FileManager.dep" "$(OUTDIR)\LabResources.class"\
 "$(OUTDIR)\LabResources.dep" "$(OUTDIR)\DataManager.dep"\
 "$(OUTDIR)\ExecutionThread.class" "$(OUTDIR)\ExecutionThread.dep"\
 "$(OUTDIR)\LabResourcesFrame.class" "$(OUTDIR)\LabResourcesFrame.dep"\
 "$(OUTDIR)\RSA.class" "$(OUTDIR)\RSA.dep" "$(OUTDIR)\DES.class"\
 "$(OUTDIR)\DES.dep" "$(OUTDIR)\CryptographyLibrary.dep"\
 "$(OUTDIR)\MultiLabServer.class" "$(OUTDIR)\MultiLabServer.dep"\
 "$(OUTDIR)\LabServer.class" "$(OUTDIR)\LabServer.dep"\
 "$(OUTDIR)\AnimationThread.class" "$(OUTDIR)\AnimationThread.dep"\
 "$(OUTDIR)\LabSecurityManager.class" "$(OUTDIR)\LabSecurityManager.dep"\
 "$(OUTDIR)\listResources.class" "$(OUTDIR)\listResources.dep"

CLEAN : 
	-@erase "$(INTDIR)\addUser.class"
	-@erase "$(INTDIR)\addUser.dep"
	-@erase "$(INTDIR)\AnimationThread.class"
	-@erase "$(INTDIR)\AnimationThread.dep"
	-@erase "$(INTDIR)\CryptographyLibrary.class"
	-@erase "$(INTDIR)\CryptographyLibrary.dep"
	-@erase "$(INTDIR)\DataManager.class"
	-@erase "$(INTDIR)\DataManager.dep"
	-@erase "$(INTDIR)\DES.class"
	-@erase "$(INTDIR)\DES.dep"
	-@erase "$(INTDIR)\ExecutionThread.class"
	-@erase "$(INTDIR)\ExecutionThread.dep"
	-@erase "$(INTDIR)\FileManager.class"
	-@erase "$(INTDIR)\FileManager.dep"
	-@erase "$(INTDIR)\InputFrame.class"
	-@erase "$(INTDIR)\InputFrame.dep"
	-@erase "$(INTDIR)\LabClient.class"
	-@erase "$(INTDIR)\LabClient.dep"
	-@erase "$(INTDIR)\LabResources.class"
	-@erase "$(INTDIR)\LabResources.dep"
	-@erase "$(INTDIR)\LabResourcesFrame.class"
	-@erase "$(INTDIR)\LabResourcesFrame.dep"
	-@erase "$(INTDIR)\LabSecurityManager.class"
	-@erase "$(INTDIR)\LabSecurityManager.dep"
	-@erase "$(INTDIR)\LabServer.class"
	-@erase "$(INTDIR)\LabServer.dep"
	-@erase "$(INTDIR)\listResources.class"
	-@erase "$(INTDIR)\listResources.dep"
	-@erase "$(INTDIR)\listUsers.class"
	-@erase "$(INTDIR)\listUsers.dep"
	-@erase "$(INTDIR)\LoginDialog.class"
	-@erase "$(INTDIR)\LoginDialog.dep"
	-@erase "$(INTDIR)\MultiLabServer.class"
	-@erase "$(INTDIR)\MultiLabServer.dep"
	-@erase "$(INTDIR)\OutputFrame.class"
	-@erase "$(INTDIR)\OutputFrame.dep"
	-@erase "$(INTDIR)\RSA.class"
	-@erase "$(INTDIR)\RSA.dep"
	-@erase "$(INTDIR)\SingleLabServer.class"
	-@erase "$(INTDIR)\SingleLabServer.dep"
	-@erase "$(INTDIR)\VirtualLab.class"
	-@erase "$(INTDIR)\VirtualLab.dep"

# ADD BASE JAVA /O
# ADD JAVA /O

!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir ""
# PROP BASE Intermediate_Dir ""
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir ""
# PROP Intermediate_Dir ""
# PROP Target_Dir ""
OUTDIR=.
INTDIR=.

ALL : "$(OUTDIR)\VirtualLab.class" "$(OUTDIR)\VirtualLab.dep"\
 "$(OUTDIR)\LoginDialog.class" "$(OUTDIR)\LoginDialog.dep"\
 "$(OUTDIR)\LabClient.class" "$(OUTDIR)\LabClient.dep"\
 "$(OUTDIR)\SingleLabServer.class" "$(OUTDIR)\SingleLabServer.dep"\
 "$(OUTDIR)\OutputFrame.class" "$(OUTDIR)\OutputFrame.dep"\
 "$(OUTDIR)\InputFrame.class" "$(OUTDIR)\InputFrame.dep"\
 "$(OUTDIR)\addUser.class" "$(OUTDIR)\addUser.dep" "$(OUTDIR)\listUsers.class"\
 "$(OUTDIR)\listUsers.dep" "$(OUTDIR)\FileManager.class"\
 "$(OUTDIR)\FileManager.dep" "$(OUTDIR)\LabResources.class"\
 "$(OUTDIR)\LabResources.dep" "$(OUTDIR)\DataManager.dep"\
 "$(OUTDIR)\ExecutionThread.class" "$(OUTDIR)\ExecutionThread.dep"\
 "$(OUTDIR)\LabResourcesFrame.class" "$(OUTDIR)\LabResourcesFrame.dep"\
 "$(OUTDIR)\RSA.class" "$(OUTDIR)\RSA.dep" "$(OUTDIR)\DES.class"\
 "$(OUTDIR)\DES.dep" "$(OUTDIR)\CryptographyLibrary.dep"\
 "$(OUTDIR)\MultiLabServer.class" "$(OUTDIR)\MultiLabServer.dep"\
 "$(OUTDIR)\LabServer.class" "$(OUTDIR)\LabServer.dep"\
 "$(OUTDIR)\AnimationThread.class" "$(OUTDIR)\AnimationThread.dep"\
 "$(OUTDIR)\LabSecurityManager.class" "$(OUTDIR)\LabSecurityManager.dep"\
 "$(OUTDIR)\listResources.class" "$(OUTDIR)\listResources.dep"

CLEAN : 
	-@erase "$(INTDIR)\addUser.class"
	-@erase "$(INTDIR)\addUser.dep"
	-@erase "$(INTDIR)\AnimationThread.class"
	-@erase "$(INTDIR)\AnimationThread.dep"
	-@erase "$(INTDIR)\CryptographyLibrary.class"
	-@erase "$(INTDIR)\CryptographyLibrary.dep"
	-@erase "$(INTDIR)\DataManager.class"
	-@erase "$(INTDIR)\DataManager.dep"
	-@erase "$(INTDIR)\DES.class"
	-@erase "$(INTDIR)\DES.dep"
	-@erase "$(INTDIR)\ExecutionThread.class"
	-@erase "$(INTDIR)\ExecutionThread.dep"
	-@erase "$(INTDIR)\FileManager.class"
	-@erase "$(INTDIR)\FileManager.dep"
	-@erase "$(INTDIR)\InputFrame.class"
	-@erase "$(INTDIR)\InputFrame.dep"
	-@erase "$(INTDIR)\LabClient.class"
	-@erase "$(INTDIR)\LabClient.dep"
	-@erase "$(INTDIR)\LabResources.class"
	-@erase "$(INTDIR)\LabResources.dep"
	-@erase "$(INTDIR)\LabResourcesFrame.class"
	-@erase "$(INTDIR)\LabResourcesFrame.dep"
	-@erase "$(INTDIR)\LabSecurityManager.class"
	-@erase "$(INTDIR)\LabSecurityManager.dep"
	-@erase "$(INTDIR)\LabServer.class"
	-@erase "$(INTDIR)\LabServer.dep"
	-@erase "$(INTDIR)\listResources.class"
	-@erase "$(INTDIR)\listResources.dep"
	-@erase "$(INTDIR)\listUsers.class"
	-@erase "$(INTDIR)\listUsers.dep"
	-@erase "$(INTDIR)\LoginDialog.class"
	-@erase "$(INTDIR)\LoginDialog.dep"
	-@erase "$(INTDIR)\MultiLabServer.class"
	-@erase "$(INTDIR)\MultiLabServer.dep"
	-@erase "$(INTDIR)\OutputFrame.class"
	-@erase "$(INTDIR)\OutputFrame.dep"
	-@erase "$(INTDIR)\RSA.class"
	-@erase "$(INTDIR)\RSA.dep"
	-@erase "$(INTDIR)\SingleLabServer.class"
	-@erase "$(INTDIR)\SingleLabServer.dep"
	-@erase "$(INTDIR)\VirtualLab.class"
	-@erase "$(INTDIR)\VirtualLab.dep"

# ADD BASE JAVA /g
# ADD JAVA /g

!ENDIF 

################################################################################
# Begin Target

# Name "VirtualLab - Java Virtual Machine Release"
# Name "VirtualLab - Java Virtual Machine Debug"

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE=.\VirtualLab.java

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"


"$(INTDIR)\VirtualLab.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\VirtualLab.dep" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"


"$(INTDIR)\VirtualLab.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\VirtualLab.dep" : $(SOURCE) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\VirtualLab.html

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\images\img0001.gif

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\images\img0002.gif

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\images\img0003.gif

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\images\img0004.gif

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\images\img0005.gif

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\images\img0006.gif

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\images\img0007.gif

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\images\img0008.gif

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\images\img0009.gif

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\images\img0010.gif

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\images\img0011.gif

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\images\img0012.gif

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\images\img0013.gif

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\images\img0014.gif

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\images\img0015.gif

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\images\img0016.gif

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\images\img0017.gif

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\images\img0018.gif

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\LoginDialog.java

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"


"$(INTDIR)\LoginDialog.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\LoginDialog.dep" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"


"$(INTDIR)\LoginDialog.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\LoginDialog.dep" : $(SOURCE) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\LabClient.java

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"


"$(INTDIR)\LabClient.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\LabClient.dep" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"


"$(INTDIR)\LabClient.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\LabClient.dep" : $(SOURCE) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\SingleLabServer.java

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"


"$(INTDIR)\SingleLabServer.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\SingleLabServer.dep" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"


"$(INTDIR)\SingleLabServer.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\SingleLabServer.dep" : $(SOURCE) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\OutputFrame.java

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"


"$(INTDIR)\OutputFrame.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\OutputFrame.dep" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"


"$(INTDIR)\OutputFrame.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\OutputFrame.dep" : $(SOURCE) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\InputFrame.java

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"


"$(INTDIR)\InputFrame.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\InputFrame.dep" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"


"$(INTDIR)\InputFrame.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\InputFrame.dep" : $(SOURCE) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\addUser.java

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"


"$(INTDIR)\addUser.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\addUser.dep" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"


"$(INTDIR)\addUser.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\addUser.dep" : $(SOURCE) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\listUsers.java

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"


"$(INTDIR)\listUsers.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\listUsers.dep" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"


"$(INTDIR)\listUsers.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\listUsers.dep" : $(SOURCE) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\FileManager.java

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"


"$(INTDIR)\FileManager.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\FileManager.dep" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"


"$(INTDIR)\FileManager.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\FileManager.dep" : $(SOURCE) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\LabResources.java

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"


"$(INTDIR)\LabResources.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\LabResources.dep" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"


"$(INTDIR)\LabResources.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\LabResources.dep" : $(SOURCE) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\DataManager.java

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

DEP_JAVA_DATAM=\
	"C:\Windows\Java\Classes\classes.zip"\
	

"$(INTDIR)\DataManager.class" : $(SOURCE) $(DEP_JAVA_DATAM) "$(INTDIR)"

"$(INTDIR)\DataManager.dep" : $(SOURCE) $(DEP_JAVA_DATAM) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

DEP_JAVA_DATAM=\
	"C:\Windows\Java\Classes\classes.zip"\
	

"$(INTDIR)\DataManager.class" : $(SOURCE) $(DEP_JAVA_DATAM) "$(INTDIR)"

"$(INTDIR)\DataManager.dep" : $(SOURCE) $(DEP_JAVA_DATAM) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\ExecutionThread.java

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"


"$(INTDIR)\ExecutionThread.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\ExecutionThread.dep" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"


"$(INTDIR)\ExecutionThread.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\ExecutionThread.dep" : $(SOURCE) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\LabResourcesFrame.java

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

DEP_JAVA_LABRE=\
	"C:\Windows\Java\Classes\classes.zip"\
	

"$(INTDIR)\LabResourcesFrame.class" : $(SOURCE) $(DEP_JAVA_LABRE) "$(INTDIR)"

"$(INTDIR)\LabResourcesFrame.dep" : $(SOURCE) $(DEP_JAVA_LABRE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

DEP_JAVA_LABRE=\
	"C:\Windows\Java\Classes\classes.zip"\
	

"$(INTDIR)\LabResourcesFrame.class" : $(SOURCE) $(DEP_JAVA_LABRE) "$(INTDIR)"

"$(INTDIR)\LabResourcesFrame.dep" : $(SOURCE) $(DEP_JAVA_LABRE) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\RSA.java

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"


"$(INTDIR)\RSA.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\RSA.dep" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"


"$(INTDIR)\RSA.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\RSA.dep" : $(SOURCE) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\DES.java

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

DEP_JAVA_DES_J=\
	".\DataManager.class"\
	"C:\Windows\Java\Classes\classes.zip"\
	
NODEP_JAVA_DES_J=\
	".\CryptographyLibrary.class"\
	

"$(INTDIR)\DES.class" : $(SOURCE) $(DEP_JAVA_DES_J) "$(INTDIR)"\
 "$(INTDIR)\DataManager.class" "$(INTDIR)\CryptographyLibrary.class"

"$(INTDIR)\DES.dep" : $(SOURCE) $(DEP_JAVA_DES_J) "$(INTDIR)"\
 "$(INTDIR)\DataManager.class" "$(INTDIR)\CryptographyLibrary.class"


!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

DEP_JAVA_DES_J=\
	".\DataManager.class"\
	"C:\Windows\Java\Classes\classes.zip"\
	
NODEP_JAVA_DES_J=\
	".\CryptographyLibrary.class"\
	

"$(INTDIR)\DES.class" : $(SOURCE) $(DEP_JAVA_DES_J) "$(INTDIR)"\
 "$(INTDIR)\DataManager.class" "$(INTDIR)\CryptographyLibrary.class"

"$(INTDIR)\DES.dep" : $(SOURCE) $(DEP_JAVA_DES_J) "$(INTDIR)"\
 "$(INTDIR)\DataManager.class" "$(INTDIR)\CryptographyLibrary.class"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\CryptographyLibrary.java

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"


"$(INTDIR)\CryptographyLibrary.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\CryptographyLibrary.dep" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"


"$(INTDIR)\CryptographyLibrary.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\CryptographyLibrary.dep" : $(SOURCE) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\MultiLabServer.java

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"


"$(INTDIR)\MultiLabServer.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\MultiLabServer.dep" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"


"$(INTDIR)\MultiLabServer.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\MultiLabServer.dep" : $(SOURCE) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\LabServer.java

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"


"$(INTDIR)\LabServer.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\LabServer.dep" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"


"$(INTDIR)\LabServer.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\LabServer.dep" : $(SOURCE) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\AnimationThread.java

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"

DEP_JAVA_ANIMA=\
	"C:\Windows\Java\Classes\classes.zip"\
	

"$(INTDIR)\AnimationThread.class" : $(SOURCE) $(DEP_JAVA_ANIMA) "$(INTDIR)"

"$(INTDIR)\AnimationThread.dep" : $(SOURCE) $(DEP_JAVA_ANIMA) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"

DEP_JAVA_ANIMA=\
	"C:\Windows\Java\Classes\classes.zip"\
	

"$(INTDIR)\AnimationThread.class" : $(SOURCE) $(DEP_JAVA_ANIMA) "$(INTDIR)"

"$(INTDIR)\AnimationThread.dep" : $(SOURCE) $(DEP_JAVA_ANIMA) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\LabSecurityManager.java

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"


"$(INTDIR)\LabSecurityManager.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\LabSecurityManager.dep" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"


"$(INTDIR)\LabSecurityManager.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\LabSecurityManager.dep" : $(SOURCE) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\listResources.java

!IF  "$(CFG)" == "VirtualLab - Java Virtual Machine Release"


"$(INTDIR)\listResources.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\listResources.dep" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "VirtualLab - Java Virtual Machine Debug"


"$(INTDIR)\listResources.class" : $(SOURCE) "$(INTDIR)"

"$(INTDIR)\listResources.dep" : $(SOURCE) "$(INTDIR)"


!ENDIF 

# End Source File
# End Target
# End Project
################################################################################
