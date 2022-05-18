import compilerTools.Token;

%%
%class Lexer
%type Token
%line
%column
%{
    private Token token(String lexeme, String lexicalComp, int line, int column){
        return new Token(lexeme, lexicalComp, line+1, column+1);
    }
%}
/* Variables básicas de comentarios y espacios */
TerminadorDeLinea = \r|\n|\r\n
EntradaDeCaracter = [^\r\n]
EspacioEnBlanco = {TerminadorDeLinea} | [ \t\f]
ComentarioEspecial = "*" {EntradaDeCaracter}* {TerminadorDeLinea}?

/* Comentario */
Comentario = {ComentarioEspecial}

/* Identificador */
LetraIndex = [X | x] | [Y|y]
Letra = [A-Za-zÑñ_ÁÉÍÓÚáéíóúÜü]
Digito = [0-9]
Identificador = {Letra}({Letra}|{Digito})*
DirSimple = ({Letra}|{Digito})({Letra}|{Digito})
DirExt = {DirSimple}{DirSimple}
/* Número */
Numero = 0 | [1-9][0-9]*
%%

/* Direccion */
\${DirSimple} { return token(yytext(), "DirSimple", yyline, yycolumn); }
\${DirExt} { return token(yytext(), "DirExt", yyline, yycolumn); }
/* Comentarios o espacios en blanco */
{Comentario}|{EspacioEnBlanco} { /*Ignorar*/ }


/* Operadores de agrupacion */
"(" {return token(yytext(),"PARENTESIS_A",yyline,yycolumn);}
")" {return token(yytext(),"PARENTESIS_C",yyline,yycolumn);}
"{" {return token(yytext(),"LLAVE_A",yyline,yycolumn);}
"}" {return token(yytext(),"LLAVE_C",yyline,yycolumn);}

/* Signos de operacion */
"#" {return token(yytext(),"LLAVE_A",yyline,yycolumn);}
"$" {return token(yytext(),"LLAVE_C",yyline,yycolumn);}
"," {return token(yytext(),"COMA",yyline,yycolumn);}

/* Directivas */
"ORG" | "org" {return token(yytext(),"Directiva_ORG",yyline,yycolumn);}
"EQU" | "equ" {return token(yytext(),"Directiva_EQU",yyline,yycolumn);}
"FCB" | "fcb" {return token(yytext(),"Directiva_FCB",yyline,yycolumn);}
"END" | "end" {return token(yytext(),"Directiva_END",yyline,yycolumn);}

/*INSTRUCCIONES*/

/*Instrucciones aritmeticas de suma y resta*/

"SBA" | "sba" {return token(yytext(),"Inst_SBA",yyline,yycolumn);}      /* $10 */
"ABA" | "aba" {return token(yytext(),"Inst_ABA",yyline,yycolumn);}      /* $1B */
"ABY" | "aby" {return token(yytext(),"Inst_ABY",yyline,yycolumn);}      /* $18 3A */
"ABX" | "abx" {return token(yytext(),"Inst_ABX",yyline,yycolumn);}      /* $3A */
("SBCA" | "sbca"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_SBCA_INMEDIATO",yyline,yycolumn);}      /* $82 */
("SUBD" | "subd"){EspacioEnBlanco}\#\${DirExt} {return token(yytext(),"Inst_SUBD_INMEDIATO",yyline,yycolumn);}         /* $83 */
("ADCA" | "adca"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_ADCA_INMEDIATO",yyline,yycolumn);}      /* $89 */
("ADDA" | "adda"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_ADDA_INMEDIATO",yyline,yycolumn);}      /* $8B */
("ADDD" | "addd"){EspacioEnBlanco}\#\${DirExt} {return token(yytext(),"Inst_ADDD_INMEDIATO",yyline,yycolumn);}         /* $C3 */
("SBCA" | "sbca")\${DirSimple} | ("SBCA" | "sbca"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_SBCA_Dir",yyline,yycolumn);} /* $92 */
("SUBD" | "subd")\${DirSimple} | ("SUBD" | "subd"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_SUBD_Dir",yyline,yycolumn);} /* $93 */
("ADCA" | "adca")\${DirSimple} | ("ADCA" | "adca"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_ADCA_Dir",yyline,yycolumn);} /* $99 */
("ADDA" | "adda")\${DirSimple} | ("ADDA" | "adda"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_ADDA_Dir",yyline,yycolumn);} /* $9B */
("ADDD" | "addd")\${DirSimple} | ("ADDD" | "addd"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_ADDD_Dir",yyline,yycolumn);} /* $D3 */
("SBCA" | "sbca"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("SBCA" | "sbca"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_SBCA_Index",yyline,yycolumn);} /* $A2 */
("SUBD" | "subd"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("SUBD" | "subd"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_SUBD_Index",yyline,yycolumn);} /* $A3 */
("ADCA" | "adca"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ADCA" | "adca"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_ADCA_Index",yyline,yycolumn);} /* $A9 */
("ADDA" | "adda"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ADDA" | "adda"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_ADDA_Index",yyline,yycolumn);} /* $AB */
("ADDD" | "addd"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ADDD" | "addd"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_ADDD_Index",yyline,yycolumn);} /* $E3 */
("SBCA" | "sbca")\${DirExt} | ("SBCA" | "sbca"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_SBCA_Ext",yyline,yycolumn);} /* $B2 */
("SUBD" | "subd")\${DirExt} | ("SUBD" | "subd"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_SUBD_Ext",yyline,yycolumn);} /* $B3 */
("ADCA" | "adca")\${DirExt} | ("ADCA" | "adca"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_ADCA_Ext",yyline,yycolumn);} /* $B9 */
("ADDA" | "adda")\${DirExt} | ("ADDA" | "adda"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_ADDA_Ext",yyline,yycolumn);} /* $BB */
("ADDD" | "addd")\${DirExt} | ("ADDD" | "addd"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_ADDD_Ext",yyline,yycolumn);} /* $F3 */


/*Instrucciones aritmeticas de incremento y decremento*/
"INX" | "inx" {return token(yytext(),"Inst_INX",yyline,yycolumn);}      /* $08 */
"DEX" | "dex" {return token(yytext(),"Inst_DEX",yyline,yycolumn);}      /* $09 */
"INY" | "iny" {return token(yytext(),"Inst_INY",yyline,yycolumn);}      /* $18 08*/
"DEY" | "dey" {return token(yytext(),"Inst_DEY",yyline,yycolumn);}      /* $18 09*/
"DAA" | "daa" {return token(yytext(),"Inst_DAA",yyline,yycolumn);}      /* $19 */
"INS" | "ins" {return token(yytext(),"Inst_INS",yyline,yycolumn);}      /* $31 */
"DES" | "des" {return token(yytext(),"Inst_DES",yyline,yycolumn);}      /* $34 */
"NEGA" | "nega" {return token(yytext(),"Inst_NEGA",yyline,yycolumn);}   /* $40 */
"COMA" | "coma" {return token(yytext(),"Inst_COMA",yyline,yycolumn);}   /* $43 */
"DECA"|"deca" {return token(yytext(),"Inst_DECA",yyline,yycolumn);}     /* $4A */
"INCA"|"inca" {return token(yytext(),"Inst_INCA",yyline,yycolumn);}     /* $4C */
"CLRA"|"clra" {return token(yytext(),"Inst_CLRA",yyline,yycolumn);}     /* $4F */
("NEG" | "neg"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("NEG" | "neg"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_NEG_Index",yyline,yycolumn);} /* $60 */
("COM" | "com"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("COM" | "com"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_COM_Index",yyline,yycolumn);} /* $63 */
("DEC" | "dec"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("DEC" | "dec"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_DEC_Index",yyline,yycolumn);} /* $6A */
("INC" | "inc"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("INC" | "inc"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_INC_Index",yyline,yycolumn);} /* $6C */
("CLR" | "clr"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("CLR" | "clr"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_CLR_Index",yyline,yycolumn);} /* $6F */
("NEG" | "neg")\${DirExt} | ("NEG" | "neg"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_NEG_Ext",yyline,yycolumn);} /* $70 */
("COM" | "com")\${DirExt} | ("COM" | "com"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_COM_Ext",yyline,yycolumn);} /* $73 */
("DEC" | "dec")\${DirExt} | ("DEC" | "dec"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_DEC_Ext",yyline,yycolumn);} /* $7A */
("INC" | "inc")\${DirExt} | ("INC" | "inc"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_INC_Ext",yyline,yycolumn);} /* $7C */
("CLR" | "CLR")\${DirExt} | ("CLR" | "clr"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_CLR_Ext",yyline,yycolumn);} /* $7C */


/*b*/
"NEGB" | "negb" {return token(yytext(),"Inst_NEGB",yyline,yycolumn);}   /* $50 */
"COMB" | "comb" {return token(yytext(),"Inst_COMB",yyline,yycolumn);}   /* $53 */
"DECB"|"decb" {return token(yytext(),"Inst_DECB",yyline,yycolumn);}     /* $5A */
"INCB"|"incb" {return token(yytext(),"Inst_INCB",yyline,yycolumn);}     /* $5C */
"CLRB"|"clrb" {return token(yytext(),"Inst_CLRB",yyline,yycolumn);}     /* $5F */

/*Instrucciones aritmeticas de multiplicacion y division*/
"IDIV" | "idiv" {return token(yytext(),"Inst_IDIV",yyline,yycolumn);}      /* $02 */
"FDIV" | "fdiv" {return token(yytext(),"Inst_FDIV",yyline,yycolumn);}      /* $03 */
"MUL" | "mul" {return token(yytext(),"Inst_MUL",yyline,yycolumn);}      /* $3D */

/*Instrucciones de comparacion */
("CBA" | "cba") {return token(yytext(),"Inst_CBA",yyline,yycolumn);}      /* $11 */
("CPY" | "cpy"){EspacioEnBlanco}\#\${DirExt} {return token(yytext(),"Inst_CPY_INMEDIATO",yyline,yycolumn);}         /* $18 8C */
("CPY" | "cpy")\${DirSimple} | ("CPY" | "cpy"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_CPY_Dir",yyline,yycolumn);} /* $18 9C */
("CPY" | "cpy"){EspacioEnBlanco}\${DirSimple}\,{Letra} | ("CPY" | "cpy"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_CPY_Index",yyline,yycolumn);} /* $18 AC */
("CPY" | "cpy")\${DirExt} | ("CPY" | "cpy"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_CPY_Ext",yyline,yycolumn);} /* $18 BC */
("CPD" | "cpd"){EspacioEnBlanco}\#\${DirExt} {return token(yytext(),"Inst_CPD_INMEDIATO",yyline,yycolumn);}         /* $1A 83 */
("CPD" | "cpd")\${DirSimple} | ("CPD" | "cpd"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_CPD_Dir",yyline,yycolumn);} /* $1A 93 */
("CPD" | "cpd"){EspacioEnBlanco}\${DirSimple}\,{Letra} | ("CPD" | "cpd"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_CPD_Index",yyline,yycolumn);} /* $1A A3 */
("CPD" | "cpd")\${DirExt} | ("CPD" | "cpd"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_CPD_Ext",yyline,yycolumn);} /* $1A B3 */
("TSTA" | "tsta") {return token(yytext(),"Inst_TSTA",yyline,yycolumn);}      /* $4D */
("CMPA" | "cmpa"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_CMPA_INMEDIATO",yyline,yycolumn);}      /* $81 */
("BITA" | "bita"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_BITA_INMEDIATO",yyline,yycolumn);}      /* $85 */
("CPX" | "cpx"){EspacioEnBlanco}\#\${DirExt} {return token(yytext(),"Inst_CPX_INMEDIATO",yyline,yycolumn);}         /* $8C */
("CMPA" | "cmpa")\${DirSimple} | ("CMPA" | "cmpa"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_CMPA_Dir",yyline,yycolumn);} /* $91 */
("CPX" | "cpx")\${DirSimple} | ("CPX" | "cpx"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_CPX_Dir",yyline,yycolumn);} /* $9C */
("CMPA" | "cmpa"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("CMPA" | "cmpa"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_CMPA_Index",yyline,yycolumn);} /* $A2 */
("CPX" | "cpx"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("CPX" | "cpx"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_CPX_Index",yyline,yycolumn);} /* $AC */
("CMPA" | "cmpa")\${DirExt} | ("CMPA" | "cmpa"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_CMPA_Ext",yyline,yycolumn);} /* $B1 */
("CPX" | "cpx")\${DirExt} | ("CPX" | "cpx"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_CPX_Ext",yyline,yycolumn);} /* $BC */


("TSTB" | "tstb") {return token(yytext(),"Inst_TSTB",yyline,yycolumn);}      /* $5D */

/*Instrucciones de salto y bifurcacion*/
("BRSET" | "brset")\${DirSimple}\,\#{DirSimple} | ("BRSET" | "brset"){EspacioEnBlanco}\${DirSimple}\,\#{DirSimple} {return token(yytext(),"Inst_BRSET_Dir",yyline,yycolumn);} /* $12 */
("BRCLR" | "brclr")\${DirSimple}\,\#{DirSimple} | ("BRCLR" | "brclr"){EspacioEnBlanco}\${DirSimple}\,\#{DirSimple} {return token(yytext(),"Inst_BRCLR_Dir",yyline,yycolumn);} /* $13 */
("BRSET" | "brset")\${DirSimple}\,{LetraIndex}\,\#{DirSimple} | ("BRSET" | "brset"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex}\,\#{DirSimple} {return token(yytext(),"Inst_BRSET_Index",yyline,yycolumn);} /* $1F */
("BRCLR" | "brclr")\${DirSimple}\,{LetraIndex}\,\#{DirSimple} | ("BRCLR" | "brclr"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex}\,\#{DirSimple} {return token(yytext(),"Inst_BRCLR_Index",yyline,yycolumn);} /* $1F */

/*Instrucciones de control*/
("BSET" | "bset")\${DirSimple}\,\#{DirSimple} | ("BSET" | "bset"){EspacioEnBlanco}\${DirSimple}\,\#{DirSimple} {return token(yytext(),"Inst_BSET_Dir",yyline,yycolumn);} /* $14 */
("BCLR" | "bclr")\${DirSimple}\,\#{DirSimple} | ("BCLR" | "bclr"){EspacioEnBlanco}\${DirSimple}\,\#{DirSimple} {return token(yytext(),"Inst_BCLR_Dir",yyline,yycolumn);} /* $16 */
("BSET" | "bset")\${DirSimple}\,{LetraIndex}\,\#{DirSimple} | ("BSET" | "bset"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex}\,\#{DirSimple} {return token(yytext(),"Inst_BSET_Index",yyline,yycolumn);} /* $1C */
("BCLR" | "bclr")\${DirSimple}\,{LetraIndex}\,\#{DirSimple} | ("BCLR" | "bclr"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex}\,\#{DirSimple} {return token(yytext(),"Inst_BCLR_Index",yyline,yycolumn);} /* $1F */

/*Instrucciones logicas*/
("ORAA" | "oraa"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_ORAA_INMEDIATO",yyline,yycolumn);}      /* $8A */
("ANDA" | "anda"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_ANDA_INMEDIATO",yyline,yycolumn);}      /* $84 */
("EORA" | "eora"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_EORA_INMEDIATO",yyline,yycolumn);}      /* $88 */
("ORAA" | "oraa")\${DirSimple} | ("ORAA" | "oraa"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_ORAA_Dir",yyline,yycolumn);} /* $9A */
("ANDA" | "anda")\${DirSimple} | ("ANDA" | "anda"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_ANDA_Dir",yyline,yycolumn);} /* $94 */
("ANDA" | "anda")\${DirSimple} | ("ANDA" | "anda"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_EORA_Dir",yyline,yycolumn);} /* $98 */
("ORAA" | "oraa")\${DirExt} | ("ORAA" | "oraa"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_ORAA_Ext",yyline,yycolumn);} /* $BA */
("ANDA" | "anda")\${DirExt} | ("ANDA" | "anda"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_ANDA_Ext",yyline,yycolumn);} /* $B4 */
("EORA" | "eora")\${DirExt} | ("EORA" | "eora"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_EORA_Ext",yyline,yycolumn);} /* $B8 */
("ORAA" | "oraa"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ORAA" | "oraa"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_ORAA_Index",yyline,yycolumn);} /* $AA */
("ANDA" | "anda"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ANDA" | "anda"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_ANDA_Index",yyline,yycolumn);} /* $A4 */
("EORA" | "eora"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("EORA" | "eora"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_EORA_Index",yyline,yycolumn);} /* $A8 */

/*Instrucciones de rotacion y desplazamiento*/

("LSRD" | "lsrd") {return token(yytext(),"Inst_LSRD",yyline,yycolumn);}      /* $04 */
("ASLD" | "asld")|("LSLD" | "lsld") {return token(yytext(),"Inst_ASLD",yyline,yycolumn);}      /* $05 */
("LSRA" | "lsra") {return token(yytext(),"Inst_LSRA",yyline,yycolumn);}      /* $44 */
("RORA" | "rora") {return token(yytext(),"Inst_RORA",yyline,yycolumn);}      /* $46 */
("ASRA" | "asra") {return token(yytext(),"Inst_ASRA",yyline,yycolumn);}      /* $47 */
("ASLA" | "asla")| ("LSLA" | "lsla") {return token(yytext(),"Inst_ASLA",yyline,yycolumn);}      /* $48 */
("ROLA" | "rola") {return token(yytext(),"Inst_ROLA",yyline,yycolumn);}      /* $49 */
("LSR" | "lsr") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LSR" | "lsr"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_LSR_Index",yyline,yycolumn);} /* $64 */
("ASR" | "asr") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ASR" | "asr"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_ASR_Index",yyline,yycolumn);} /* $A7 */
("ASL" | "asl")| ("LSL" | "lsl"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ASL" | "asl")| ("LSL" | "lsl"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_EORA_Index",yyline,yycolumn);} /* $A8 */
("LSR" | "lsr")\${DirExt} | ("LSR" | "lsr") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_LSR_Ext",yyline,yycolumn);} /* $74 */
("ASR" | "asr")\${DirExt} | ("ASR" | "asr") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_ASR_Ext",yyline,yycolumn);} /* $77 */
("ASL" | "asl")| ("LSL" | "lsl")\${DirExt} | ("ASL" | "asl")| ("LSL" | "lsl"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_ASL_Ext",yyline,yycolumn);} /* $78 */
/*B*/
("LSRB" | "lsrb") {return token(yytext(),"Inst_LSRB",yyline,yycolumn);}      /* $54 */
("RORB" | "rorb") {return token(yytext(),"Inst_RORB",yyline,yycolumn);}      /* $56 */
("ASRB" | "asrb") {return token(yytext(),"Inst_ASRB",yyline,yycolumn);}      /* $57 */
("ASLB" | "aslb")| ("LSLB" | "lslb") {return token(yytext(),"Inst_ASLB",yyline,yycolumn);}      /* $58 */
("ROLB" | "rolb") {return token(yytext(),"Inst_ROLB",yyline,yycolumn);}      /* $59 */

/*Instrucciones de transferencia*/
("PSHX" | "pshx") {return token(yytext(),"Inst_PSHX",yyline,yycolumn);}      /* $3C */
("PULX" | "pulx") {return token(yytext(),"Inst_PULX",yyline,yycolumn);}      /* $38 */
("PULY" | "puly") {return token(yytext(),"Inst_PULY",yyline,yycolumn);}      /* $18 38 */
("PSHY" | "pshy") {return token(yytext(),"Inst_PSHY",yyline,yycolumn);}      /* $18 3C */

("LDS" | "lds"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_LDS_INMEDIATO",yyline,yycolumn);}  /* $8E */ 
("LDX" | "ldx"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_LDX_INMEDIATO",yyline,yycolumn);}  /* $CE */ 
("LDY" | "ldy"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_LDY_INMEDIATO",yyline,yycolumn);}  /* $18 CE */ 
("LDD" | "ldd"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_LDD_INMEDIATO",yyline,yycolumn);}  /* $CC */ 
("LDS" | "lds")\${DirSimple} | ("LDS" | "lds"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_LDS_Dir",yyline,yycolumn);} /* $9E */
("LDX" | "ldx")\${DirSimple} | ("LDX" | "ldx"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_LDX_Dir",yyline,yycolumn);} /* $DE */
("LDY" | "ldy")\${DirSimple} | ("LDY" | "ldy"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_LDY_Dir",yyline,yycolumn);} /* $18 DE */
("LDD" | "ldd")\${DirSimple} | ("LDD" | "ldd"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_LDD_Dir",yyline,yycolumn);} /* $DC */
("STD" | "std")\${DirSimple} | ("STD" | "std"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_STD_Dir",yyline,yycolumn);} /* $DD */
("LDS" | "lds") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LDS" | "lds"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_LDS_Index",yyline,yycolumn);} /* $AE */ /*18 AE*/
("LDX" | "ldx") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LDX" | "ldx"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_LDX_Index",yyline,yycolumn);} /* $FE */ /*18 FE*/
("LDY" | "ldy") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LDY" | "ldy"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_LDY_Index",yyline,yycolumn);} /* $1A EE */ /*18 EC*/
("LDD" | "ldd") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LDD" | "ldd"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_LDD_Index",yyline,yycolumn);} /* $EC */ /*18 EC*/
("STD" | "std") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("STD" | "std"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_STD_Index",yyline,yycolumn);} /* $ED */ /*18 ED*/
("LDS" | "lds")\${DirExt} | ("LDS" | "lds") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_LDS_Ext",yyline,yycolumn);} /* $BE */
("LDX" | "ldx")\${DirExt} | ("LDX" | "ldx") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_LDX_Ext",yyline,yycolumn);} /* $FE */
("LDY" | "ldy")\${DirExt} | ("LDY" | "ldy") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_LDY_Ext",yyline,yycolumn);} /* $18 FE */
("LDD" | "ldd")\${DirExt} | ("LDD" | "ldd") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_LDD_Ext",yyline,yycolumn);} /* $FC */
("STD" | "std")\${DirExt} | ("STD" | "std") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_STD_Ext",yyline,yycolumn);} /* $FD */

/*A*/
("TAP" | "tap") {return token(yytext(),"Inst_TAP",yyline,yycolumn);}      /* $06 */
("TPA" | "tpa") {return token(yytext(),"Inst_TPA",yyline,yycolumn);}      /* $07 */
("TAB" | "tab") {return token(yytext(),"Inst_TAB",yyline,yycolumn);}      /* $16 */
("PULA" | "pula") {return token(yytext(),"Inst_PULA",yyline,yycolumn);}      /* $32 */
("PSHA" | "psha") {return token(yytext(),"Inst_PSHA",yyline,yycolumn);}      /* $36 */
("LDAA" | "ldaa"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_LDAA_INMEDIATO",yyline,yycolumn);}  /* $86 */ 
("LDAA" | "ldaa")\${DirSimple} | ("LDAA" | "ldaa"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_LDAA_Dir",yyline,yycolumn);} /* $96 */
("STAA" | "ldaa")\${DirSimple} | ("STAA" | "staa"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_STAA_Dir",yyline,yycolumn);} /* $97 */
("LDAA" | "ldaa") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LDAA" | "ldaa"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_LDAA_Index",yyline,yycolumn);} /* $A6 */
("STAA" | "staa") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("STAA" | "staa"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_STAA_Index",yyline,yycolumn);} /* $A7 */
("LDAA" | "ldaa")\${DirExt} | ("LDAA" | "ldaa") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_LDAA_Ext",yyline,yycolumn);} /* $B6 */
("STAA" | "staa")\${DirExt} | ("STAA" | "staa") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_STAA_Ext",yyline,yycolumn);} /* $B7 */

/*B*/
("TBA" | "tba") {return token(yytext(),"Inst_TBA",yyline,yycolumn);}      /* $17 */
("PULB" | "pulb") {return token(yytext(),"Inst_PULB",yyline,yycolumn);}      /* $33 */
("PSHB" | "pshb") {return token(yytext(),"Inst_PSHB",yyline,yycolumn);}      /* $37 */
("LDAB" | "ldab"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_LDAB_INMEDIATO",yyline,yycolumn);}  /* $C6 */
("LDAB" | "ldab")\${DirSimple} | ("LDAB" | "ldab"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_LDAB_Dir",yyline,yycolumn);} /* $D6 */
("STAB" | "stab")\${DirSimple} | ("STAB" | "stab"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_STAB_Dir",yyline,yycolumn);} /* $D7 */
("LDAB" | "ldab") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LDAB" | "ldab"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_LDAB_Index",yyline,yycolumn);} /* $E6 */
("STAB" | "stab") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("STAB" | "stab"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_STAB_Index",yyline,yycolumn);} /* $E7 */
("LDAB" | "ldab")\${DirExt} | ("LDAB" | "ldab") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_LDAB_Ext",yyline,yycolumn);} /* $F6 */
("STAB" | "stab")\${DirExt} | ("STAB" | "stab") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_STAB_Ext",yyline,yycolumn);} /* $F7 */

/* Other */

("TEST" | "test") {return token(yytext(),"Inst_TEST",yyline,yycolumn);}      /* $00 */
("NOP" | "nop") {return token(yytext(),"Inst_NOP",yyline,yycolumn);}         /* $01 */
("CLV" | "clv") {return token(yytext(),"Inst_CLV",yyline,yycolumn);}         /* $0A */
("SEV" | "sev") {return token(yytext(),"Inst_SEV",yyline,yycolumn);}         /* $0B */
("CLC" | "clc") {return token(yytext(),"Inst_CLC",yyline,yycolumn);}         /* $0C */
("SEC" | "sec") {return token(yytext(),"Inst_SEC",yyline,yycolumn);}         /* $0D */
("CLI" | "cli") {return token(yytext(),"Inst_CLI",yyline,yycolumn);}         /* $0E */
("SEI" | "sei") {return token(yytext(),"Inst_SEI",yyline,yycolumn);}         /* $0F */
("STOP" | "stop") {return token(yytext(),"Inst_STOP",yyline,yycolumn);}         /* $CF */
/* Branches */

("BRA" | "bra") {return token(yytext(),"Inst_BRA",yyline,yycolumn);}         /* $20 */
("BRN" | "brn") {return token(yytext(),"Inst_BRN",yyline,yycolumn);}         /* $21 */
("BHI" | "bhi") {return token(yytext(),"Inst_BHI",yyline,yycolumn);}         /* $22 */
("BLS" | "bls") {return token(yytext(),"Inst_BLS",yyline,yycolumn);}         /* $23 */
("BCC" | "bcc") |("BHS" | "bhs")  {return token(yytext(),"Inst_BCC",yyline,yycolumn);}         /* $24 */
("BCS" | "bcs") |("BLO" | "blo")  {return token(yytext(),"Inst_BCC",yyline,yycolumn);}         /* $25 */
("BNE" | "bne") {return token(yytext(),"Inst_BNE",yyline,yycolumn);}         /* $26 */
("BEQ" | "beq") {return token(yytext(),"Inst_BEQ",yyline,yycolumn);}         /* $27 */
("BVC" | "bvc") {return token(yytext(),"Inst_BVC",yyline,yycolumn);}         /* $28 */
("BVS" | "bvs") {return token(yytext(),"Inst_BVS",yyline,yycolumn);}         /* $29 */
("BPL" | "bpl") {return token(yytext(),"Inst_BPL",yyline,yycolumn);}         /* $2A */
("BMI" | "bmi") {return token(yytext(),"Inst_BMI",yyline,yycolumn);}         /* $2B */
("BGE" | "bge") {return token(yytext(),"Inst_BGE",yyline,yycolumn);}         /* $2C */
("BLT" | "blt") {return token(yytext(),"Inst_BLT",yyline,yycolumn);}         /* $2D */
("BGT" | "bgt") {return token(yytext(),"Inst_BGT",yyline,yycolumn);}         /* $2E */
("BLE" | "ble") {return token(yytext(),"Inst_BLE",yyline,yycolumn);}         /* $2F */