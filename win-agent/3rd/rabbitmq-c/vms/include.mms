
.SUFFIXES ;

.SUFFIXES .EXE $(OLB) .OBJ .MMSD .cpp .cc .C .FOR .Y .L

.L.C
	flex -l $(MMS$SOURCE) -o $(MMS$TARGET)

.Y.C
	yacc $(MMS$SOURCE) -o $(MMS$TARGET)

.C.OBJ
	CC$(CFLAGS)/MMS=(FILE=$(MMS$TARGET_NAME).MMSD)/OBJ=$(MMS$TARGET_NAME).OBJ $(MMS$SOURCE)

.C.MMSD
	CC$(CFLAGS)/MMS=(FILE=$(MMS$TARGET_NAME).MMSD)/OBJ=$(MMS$TARGET_NAME).OBJ $(MMS$SOURCE)

.CPP.OBJ
	CXX$(CXXFLAGS)/MMS=(FILE=$(MMS$TARGET_NAME).MMSD)/OBJ=$(MMS$TARGET) $(MMS$SOURCE)

.CPP.MMSD
	CXX$(CXXFLAGS)/MMS=(FILE=$(MMS$TARGET))/OBJ=$(MMS$TARGET_NAME).OBJ $(MMS$SOURCE)

.CC.OBJ
	CXX$(CXXFLAGS)/MMS=(FILE=$(MMS$TARGET_NAME).MMSD)/OBJ=$(MMS$TARGET) $(MMS$SOURCE)

.CC.MMSD
	CXX$(CXXFLAGS)/MMS=(FILE=$(MMS$TARGET))/OBJ=$(MMS$TARGET_NAME).OBJ $(MMS$SOURCE)

.OBJ$(OLB)
	@ IF F$SEARCH("$(MMS$TARGET)") .EQS. "" THEN LIBRARY/CREATE $(MMS$TARGET)
	LIBRARY/REPLACE $(MMS$TARGET) $(MMS$SOURCE_LIST)

.FOR.OBJ
	FOR$(FORFLAGS)/OBJ=$(MMS$TARGET) $(MMS$SOURCE)

.FIRST 
	@ continue

.IFDEF USE_DEPEND
.ELSE
	@ WRITE SYS$OUTPUT "Entering ''F$ENVIRONMENT(""DEFAULT"")'"
.ENDIF

.IFDEF USE_DEPEND
.ELSE
.LAST
	@ WRITE SYS$OUTPUT "Leaving ''F$ENVIRONMENT(""DEFAULT"")'"
.ENDIF

ECHO = WRITE SYS$OUTPUT

DEPS = $(OBJS:.OBJ=.MMSD)

OPTFLAGS = /PREFIX=ALL/FLOAT=IEEE/IEEE=DENORM/NAMES=(UPPER,TRUNC)/POINTER=SHORT
DEFS = __USE_STD_IOSTREAM=1,VMS
CDEFS = VMS
INC = .

DEFAULT_TARGET : $(DEPS) MMS$DEPEND.MMSD INCLUDE_DEPS
	@ CONTINUE

MMS$DEPEND.MMSD : $(DEPS) MMS$GEN_DEPEND.COM
	@MMS$GEN_DEPEND.COM

MMS$GEN_DEPEND.COM :
	@ WRITE SYS$OUTPUT "Regenerating GEN_DEPEND.COM"
	@ OPEN/WRITE F MMS$GEN_DEPEND.COM
	@ WRITE F "$ OPEN/WRITE FH MMS$DEPEND.MMSD"
	@ WRITE F "$ WRITE FH ""# File generated by GEN_DEPEND.COM - DO NOT EDIT"""
	@ WRITE F "$ WRITE FH ""# Changes will be overwritten next time product is built"""
	@ WRITE F "$ WRITE FH "".IFDEF USE_DEPEND"""
	@ WRITE F "$ LOOP:"
	@ WRITE F "$  FIL = F$SEARCH(""*.MMSD"")"
	@ WRITE F "$  IF FIL .NES. """""
	@ WRITE F "$  THEN"
	@ WRITE F "$   NAM = F$PARSE(FIL,,,""NAME"")"
	@ WRITE F "$   IF NAM .EQS. ""MMS$DEPEND"" THEN GOTO LOOP"
	@ WRITE F "$   TYP = F$PARSE(FIL,,,""TYPE"")"
	@ WRITE F "$   FUL = NAM + TYP"
	@ WRITE F "$   WRITE FH "".INCLUDE "" + FUL"
	@ WRITE F "$   GOTO LOOP"
	@ WRITE F "$  ENDIF"
	@ WRITE F "$ WRITE FH "".ELSE"""
	@ WRITE F "$ WRITE FH ""DUMMY :"""
	@ WRITE F "$ WRITE FH ""    @ WRITE SYS$OUTPUT """"MMS$DEPEND.MMS must .INCLUDED by appropriate DESCRIP.MMS and not called directly"""""""
	@ WRITE F "$ WRITE FH "".ENDIF"""
	@ WRITE F "$ CLOSE FH"
	@ CLOSE F
	
INCLUDE_DEPS :
	MMK/EXTEND/MACRO=("USE_DEPEND=1") REAL_TARGET

REAL_TARGET : $(REAL_TARGETS)
	@ CONTINUE

CLEAN :
	IF F$SEARCH("*.MMSD*") .NES. "" THEN DEL/NOLOG *.MMSD*;*
    IF F$SEARCH("MMS$GEN_DEPEND.COM*") .NES. "" THEN DEL/NOLOG MMS$GEN_DEPEND.COM*;*
    IF F$SEARCH("MMS$LINK.OPT*") .NES. "" THEN DEL/NOLOG MMS$LINK.OPT*;*
    IF F$SEARCH("MMS$SYMBOLS.OPT*") .NES. "" THEN DEL/NOLOG MMS$SYMBOLS.OPT*;*
    IF F$SEARCH("*.OBJ*") .NES. "" THEN DEL/NOLOG *.OBJ*;*
    IF F$SEARCH("[.CXX_REPOSITORY*]*.*") .NES. "" THEN DEL/NOLOG [.CXX_REPOSITORY*]*.*;*
    IF F$SEARCH("CXX_REPOSITORY*.DIR") .NES. "" THEN -
		PIPE (SET SEC/PROT=O:D CXX_REPOSITORY*.DIR; && DEL CXX_REPOSITORY*.DIR;)
    IF F$SEARCH("*.OLB") .NES. "" THEN DEL/NOLOG *.OLB;*
    IF F$SEARCH("*.EXE") .NES. "" THEN DEL/NOLOG *.EXE;*
	IF F$SEARCH("*.OUT") .NES. "" THEN DEL/NOLOG *.OUT;*
	IF F$SEARCH("*.TMP") .NES. "" THEN DEL/NOLOG *.TMP;*
	IF F$SEARCH("TAGS.") .NES. "" THEN DEL/NOLOG TAGS.;*
.IFDEF EXTRA_FILES
	- DEL/NOLOG $(EXTRA_FILES)
.ENDIF

PURGE :
	- PURGE *.OLB,*.MMSD,*.OBJ,*.EXE,[.CXX_REPOSITORY]*.*

TAGS. :
	@ IF "''CTAGS'" .NES. "" THEN CTAGS --language-force=c++ --c++-kinds=+p --fields=+iaS --extra=+q *.h *.cxx *.cpp

.IFDEF USE_DEPEND
.INCLUDE MMS$DEPEND.MMSD
.ELSE
.ENDIF

