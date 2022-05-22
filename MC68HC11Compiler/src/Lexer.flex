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
ComentarioEspecial = "*" {EntradaDeCaracter}* {TerminadorDeLinea}

/* Comentario */
Comentario = {ComentarioEspecial}

/* Identificador */

LetraIndex = [X | x] | [Y|y]
Letra = [A-Za-zÑñ_ÁÉÍÓÚáéíóúÜü]
Digito = [0-9]
Identificador = {Letra}({Letra}|{Digito})*
Identifier = [:jletter:] [:jletterdigit:]*
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
"#" {return token(yytext(),"GATO",yyline,yycolumn);}
"$" {return token(yytext(),"PESOS",yyline,yycolumn);}
"," {return token(yytext(),"COMA",yyline,yycolumn);}

/* Directivas */
("ORG" | "org") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"INICIO",yyline,yycolumn);}

"EQU" | "equ" {return token(yytext(),"Directiva_EQU",yyline,yycolumn);}

"FCB" | "fcb" {return token(yytext(),"Directiva_FCB",yyline,yycolumn);}

/* FINAL */
"END" | "end" {return token(yytext(),"FINAL",yyline,yycolumn);}

/*INSTRUCCIONES*/

/*Instrucciones aritmeticas de suma y resta*/

"SBA" | "sba" {return token(yytext(),"Inst_SBA",yyline,yycolumn);}      /* $10 */
"ABA" | "aba" {return token(yytext(),"Inst_ABA",yyline,yycolumn);}      /* $1B */
"ABY" | "aby" {return token(yytext(),"Inst_ABY",yyline,yycolumn);}      /* $18 3A */
"ABX" | "abx" {return token(yytext(),"Inst_ABX",yyline,yycolumn);}      /* $3A */

("SUBA" | "suba"){EspacioEnBlanco}\#\${DirExt} {return token(yytext(),"Inst_SUBA_INMEDIATO",yyline,yycolumn);}         /* $80 */
("SBCA" | "sbca"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_SBCA_INMEDIATO",yyline,yycolumn);}      /* $82 */
("SUBD" | "subd"){EspacioEnBlanco}\#\${DirExt} {return token(yytext(),"Inst_SUBD_INMEDIATO",yyline,yycolumn);}         /* $83 */
("ADCA" | "adca"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_ADCA_INMEDIATO",yyline,yycolumn);}      /* $89 */
("ADDA" | "adda"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_ADDA_INMEDIATO",yyline,yycolumn);}      /* $8B */
("ADDD" | "addd"){EspacioEnBlanco}\#\${DirExt} {return token(yytext(),"Inst_ADDD_INMEDIATO",yyline,yycolumn);}         /* $C3 */

("SUBA" | "suba"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_SUBA_Dir",yyline,yycolumn);} /* $90 */
("SBCA" | "sbca"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_SBCA_Dir",yyline,yycolumn);} /* $92 */
("SUBD" | "subd"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_SUBD_Dir",yyline,yycolumn);} /* $93 */
("ADCA" | "adca"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_ADCA_Dir",yyline,yycolumn);} /* $99 */
("ADDA" | "adda"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_ADDA_Dir",yyline,yycolumn);} /* $9B */
("ADDD" | "addd"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_ADDD_Dir",yyline,yycolumn);} /* $D3 */

("SUBA" | "suba"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_SUBA_Index",yyline,yycolumn);} /* $A0 */
("SBCA" | "sbca"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_SBCA_Index",yyline,yycolumn);} /* $A2 */
("ADDA" | "adda"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ADDA" | "adda"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_ADDA_Index",yyline,yycolumn);} /* $AB */
("ADDD" | "addd"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_ADDD_Index",yyline,yycolumn);} /* $E3 */

("SUBA" | "suba"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_SUBA_Ext",yyline,yycolumn);} /* $B0 */
("SBCA" | "sbca"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_SBCA_Ext",yyline,yycolumn);} /* $B2 */
("SUBD" | "subd"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_SUBD_Ext",yyline,yycolumn);} /* $B3 */
("ADCA" | "adca"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_ADCA_Ext",yyline,yycolumn);} /* $B9 */
("ADDA" | "adda"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_ADDA_Ext",yyline,yycolumn);} /* $BB */
("ADDD" | "addd"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_ADDD_Ext",yyline,yycolumn);} /* $F3 */

/* B */
("SUBB" | "subb"){EspacioEnBlanco}\#\${DirExt} {return token(yytext(),"Inst_SUBB_INMEDIATO",yyline,yycolumn);}         /* $C0 */
("SBCB" | "sbcb"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_SBCB_INMEDIATO",yyline,yycolumn);}      /* $C2 */
("ADCB" | "adcb"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_ADCB_INMEDIATO",yyline,yycolumn);}      /* $C9 */
("ADDB" | "addb"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_ADDB_INMEDIATO",yyline,yycolumn);}      /* $CB */

("SUBB" | "subb")\${DirSimple} | ("SUBB" | "subb"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_SUBD_Dir",yyline,yycolumn);} /* $D0 */
("SBCB" | "sbcb")\${DirSimple} | ("SBCB" | "sbcb"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_SBCD_Dir",yyline,yycolumn);} /* $D2 */
("ADCB" | "adcb")\${DirSimple} | ("ADCB" | "adcb"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_ADCD_Dir",yyline,yycolumn);} /* $D9 */
("ADDB" | "addb")\${DirSimple} | ("ADDB" | "addb"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_ADDD_Dir",yyline,yycolumn);} /* $DB */

("SUBB" | "subb"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("SUBB" | "subb"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_SUBB_Index",yyline,yycolumn);} /* $E0 */
("SBCB" | "sbcb"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("SBCB" | "sbcb"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_SBCB_Index",yyline,yycolumn);} /* $E2 */
("ADCB" | "adcb"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ADCB" | "adcb"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_ADCB_Index",yyline,yycolumn);} /* $E9 */
("ADDB" | "addb"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ADDB" | "addb"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_ADDB_Index",yyline,yycolumn);} /* $EB */

("SUBB" | "subb")\${DirExt} | ("SUBB" | "subb"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_SUBB_Ext",yyline,yycolumn);} /* $F0 */
("SBCB" | "sbcb")\${DirExt} | ("SBCB" | "sbcb"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_SBCB_Ext",yyline,yycolumn);} /* $F2 */
("ADCB" | "adcb")\${DirExt} | ("ADCB" | "adcb"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_ADCB_Ext",yyline,yycolumn);} /* $F9 */
("ADDB" | "addb")\${DirExt} | ("ADDB" | "addb"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_ADDB_Ext",yyline,yycolumn);} /* $FB */

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
("NEG" | "neg"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_NEG_Ext",yyline,yycolumn);} /* $70 */
("COM" | "com"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_COM_Ext",yyline,yycolumn);} /* $73 */
("DEC" | "dec"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_DEC_Ext",yyline,yycolumn);} /* $7A */
("INC" | "inc"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_INC_Ext",yyline,yycolumn);} /* $7C */
("CLR" | "clr"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_CLR_Ext",yyline,yycolumn);} /* $7C */


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
("TSTA" | "tsta") {return token(yytext(),"Inst_TSTA",yyline,yycolumn);}      /* $4D */

("CMPA" | "cmpa"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_CMPA_INMEDIATO",yyline,yycolumn);}      /* $81 */
("BITA" | "bita"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_BITA_INMEDIATO",yyline,yycolumn);}      /* $85 */
("CPX" | "cpx"){EspacioEnBlanco}\#\${DirExt} {return token(yytext(),"Inst_CPX_INMEDIATO",yyline,yycolumn);}         /* $8C */
("CPY" | "cpy"){EspacioEnBlanco}\#\${DirExt} {return token(yytext(),"Inst_CPY_INMEDIATO",yyline,yycolumn);}         /* $18 8C */
("CPD" | "cpd"){EspacioEnBlanco}\#\${DirExt} {return token(yytext(),"Inst_CPD_INMEDIATO",yyline,yycolumn);}         /* $1A 83 */

("CMPA" | "cmpa"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_CMPA_Dir",yyline,yycolumn);} /* $91 */
("BITA" | "bita"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_BITA_Dir",yyline,yycolumn);} /* $95 */
("CPX" | "cpx"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_CPX_Dir",yyline,yycolumn);} /* $9C */
("CPY" | "cpy"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_CPY_Dir",yyline,yycolumn);} /* $18 9C */
("CPD" | "cpd"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_CPD_Dir",yyline,yycolumn);} /* $1A 93 */

("CMPA" | "cmpa"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("CMPA" | "cmpa"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_CMPA_Index",yyline,yycolumn);} /* $A2 */
("BITA" | "bita"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("BITA" | "bita"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_BITA_Index",yyline,yycolumn);} /* $A5 */
("CPX" | "cpx"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("CPX" | "cpx"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_CPX_Index",yyline,yycolumn);} /* $AC */
("CPY" | "cpy") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("CTY" | "cty"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_CPY_Index",yyline,yycolumn);} /* $1A AC */ /*18 AC*/
("CPD" | "cpd"){EspacioEnBlanco}\${DirSimple}\,{Letra} | ("CPD" | "cpd"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_CPD_Index",yyline,yycolumn);} /* $1A A3 */

("CMPA" | "cmpa"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_CMPA_Ext",yyline,yycolumn);} /* $B1 */
("BITA" | "bita"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_BITA_Ext",yyline,yycolumn);} /* $B5 */
("CPX" | "cpx"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_CPX_Ext",yyline,yycolumn);} /* $BC */
("CPY" | "cpy"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_CPY_Ext",yyline,yycolumn);} /* $18 BC */
("CPD" | "cpd"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_CPD_Ext",yyline,yycolumn);} /* $1A B3 */

/*B*/
("TSTB" | "tstb") {return token(yytext(),"Inst_TSTB",yyline,yycolumn);}      /* $5D */

("CMPB" | "cmpb"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_CMPB_INMEDIATO",yyline,yycolumn);}      /* $C1 */
("BITB" | "bitb"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_BITB_INMEDIATO",yyline,yycolumn);}      /* $C5 */

("CMPB" | "cmpb"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_CMPB_Dir",yyline,yycolumn);} /* $D1 */
("BITB" | "bitb"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_BITB_Dir",yyline,yycolumn);} /* $D5 */

("CMPB" | "cmpb"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("CMPB" | "cmpb"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_CMPB_Index",yyline,yycolumn);} /* $E1 */
("BITB" | "bitb"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("BITB" | "bitb"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_BITB_Index",yyline,yycolumn);} /* $E5 */

("CMPB" | "cmpb"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_CMPB_Ext",yyline,yycolumn);} /* $F1 */
("BITB" | "bitb"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_BITB_Ext",yyline,yycolumn);} /* $F5 */


/*Instrucciones de salto y bifurcacion*/
("BRSET" | "brset"){EspacioEnBlanco}\${DirSimple}\,\#{DirSimple} {return token(yytext(),"Inst_BRSET_Dir",yyline,yycolumn);} /* $12 */
("BRCLR" | "brclr"){EspacioEnBlanco}\${DirSimple}\,\#{DirSimple} {return token(yytext(),"Inst_BRCLR_Dir",yyline,yycolumn);} /* $13 */
("BRSET" | "brset"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex}\,\#{DirSimple} {return token(yytext(),"Inst_BRSET_Index",yyline,yycolumn);} /* $1F */
("BRCLR" | "brclr"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex}\,\#{DirSimple} {return token(yytext(),"Inst_BRCLR_Index",yyline,yycolumn);} /* $1F */

/*Instrucciones de control*/
("BSET" | "bset"){EspacioEnBlanco}\${DirSimple}\,\#{DirSimple} {return token(yytext(),"Inst_BSET_Dir",yyline,yycolumn);} /* $14 */
("BCLR" | "bclr"){EspacioEnBlanco}\${DirSimple}\,\#{DirSimple} {return token(yytext(),"Inst_BCLR_Dir",yyline,yycolumn);} /* $16 */
("BSET" | "bset"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex}\,\#{DirSimple} {return token(yytext(),"Inst_BSET_Index",yyline,yycolumn);} /* $1C */
("BCLR" | "bclr"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex}\,\#{DirSimple} {return token(yytext(),"Inst_BCLR_Index",yyline,yycolumn);} /* $1F */

/*Instrucciones logicas*/
/*A*/
("ORAA" | "oraa"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_ORAA_INMEDIATO",yyline,yycolumn);}      /* $8A */
("ANDA" | "anda"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_ANDA_INMEDIATO",yyline,yycolumn);}      /* $84 */
("EORA" | "eora"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_EORA_INMEDIATO",yyline,yycolumn);}      /* $88 */

("ORAA" | "oraa"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_ORAA_Dir",yyline,yycolumn);} /* $9A */
("ANDA" | "anda"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_ANDA_Dir",yyline,yycolumn);} /* $94 */
("EORA" | "eora"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_EORA_Dir",yyline,yycolumn);} /* $98 */

("ORAA" | "oraa"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_ORAA_Ext",yyline,yycolumn);} /* $BA */
("ANDA" | "anda"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_ANDA_Ext",yyline,yycolumn);} /* $B4 */
("EORA" | "eora"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_EORA_Ext",yyline,yycolumn);} /* $B8 */

("ORAA" | "oraa"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ORAA" | "oraa"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_ORAA_Index",yyline,yycolumn);} /* $AA */
("ANDA" | "anda"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ANDA" | "anda"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_ANDA_Index",yyline,yycolumn);} /* $A4 */
("EORA" | "eora"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("EORA" | "eora"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_EORA_Index",yyline,yycolumn);} /* $A8 */

/* B */
("ANDB" | "andb"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_ANDB_INMEDIATO",yyline,yycolumn);}      /* $C4 */
("EORB" | "eorb"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_EORB_INMEDIATO",yyline,yycolumn);}      /* $C8 */
("ORAB" | "orab"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_ORAB_INMEDIATO",yyline,yycolumn);}      /* $CA */

("ANDB" | "andb"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_ANDB_Dir",yyline,yycolumn);} /* $D4 */
("EORB" | "eorb"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_EORB_Dir",yyline,yycolumn);} /* $D8 */
("ORAB" | "orab"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_ORAB_Dir",yyline,yycolumn);} /* $DA */

("ORAB" | "orab"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ORAB" | "orab"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_ORAB_Index",yyline,yycolumn);} /* $EA */ /*18 EA*/
("ANDB" | "andb"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ANDB" | "andb"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_ANDB_Index",yyline,yycolumn);} /* $E4 */ /*18 E4*/
("EORB" | "eorb"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("EORB" | "eorb"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_EORB_Index",yyline,yycolumn);} /* $E8 */ /*18 E8*/

("EORB" | "eorb"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_EORB_Dir",yyline,yycolumn);} /* $F8 */
("ORAB" | "orab"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_ORAB_Ext",yyline,yycolumn);} /* $FA */
("ANDB" | "andb"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_ANDB_Ext",yyline,yycolumn);} /* $F4 */

/*Instrucciones de rotacion y desplazamiento*/

("LSRD" | "lsrd") {return token(yytext(),"Inst_LSRD",yyline,yycolumn);}      /* $04 */
("ASLD" | "asld")|("LSLD" | "lsld") {return token(yytext(),"Inst_ASLD",yyline,yycolumn);}      /* $05 */
("LSRA" | "lsra") {return token(yytext(),"Inst_LSRA",yyline,yycolumn);}      /* $44 */
("RORA" | "rora") {return token(yytext(),"Inst_RORA",yyline,yycolumn);}      /* $46 */
("ASRA" | "asra") {return token(yytext(),"Inst_ASRA",yyline,yycolumn);}      /* $47 */
("ASLA" | "asla")| ("LSLA" | "lsla") {return token(yytext(),"Inst_ASLA",yyline,yycolumn);}      /* $48 */
("ROLA" | "rola") {return token(yytext(),"Inst_ROLA",yyline,yycolumn);}      /* $49 */
("LSR" | "lsr") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LSR" | "lsr"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_LSR_Index",yyline,yycolumn);} /* $64 */ /*18 64*/
("ASR" | "asr") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ASR" | "asr"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_ASR_Index",yyline,yycolumn);} /* $A7 */
("ROR" | "ror") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ROR" | "ror"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_ROR_Index",yyline,yycolumn);} /* $66 */ /*18 66*/
("ROL" | "rol") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ROL" | "rol"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_ROL_Index",yyline,yycolumn);} /* $69 */ /*18 69*/
("JMP" | "jmp") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("JMP" | "jmp"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_JMP_Index",yyline,yycolumn);} /* $6E */ /*18 6E*/

("ASL" | "asl")| ("LSL" | "lsl"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ASL" | "asl")| ("LSL" | "lsl"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_EORA_Index",yyline,yycolumn);} /* $A8 */
("LSR" | "lsr") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_LSR_Ext",yyline,yycolumn);} /* $74 */
("ASR" | "asr") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_ASR_Ext",yyline,yycolumn);} /* $77 */
("ROR" | "ror") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_ROR_Ext",yyline,yycolumn);} /* $76 */
("ROL" | "rol") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_ROL_Ext",yyline,yycolumn);} /* $79 */

("ASL" | "asl")| ("LSL" | "lsl"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_ASL_Ext",yyline,yycolumn);} /* $78 */
/*B*/
("LSRB" | "lsrb") {return token(yytext(),"Inst_LSRB",yyline,yycolumn);}      /* $54 */
("RORB" | "rorb") {return token(yytext(),"Inst_RORB",yyline,yycolumn);}      /* $56 */
("ASRB" | "asrb") {return token(yytext(),"Inst_ASRB",yyline,yycolumn);}      /* $57 */
("ASLB" | "aslb")| ("LSLB" | "lslb") {return token(yytext(),"Inst_ASLB",yyline,yycolumn);}      /* $58 */
("ROLB" | "rolb") {return token(yytext(),"Inst_ROLB",yyline,yycolumn);}      /* $59 */

/*Instrucciones de transferencia*/

("JSR" | "jsr"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_JSR_Dir",yyline,yycolumn);} /* $9D */
("STS" | "sts"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_STS_Dir",yyline,yycolumn);} /* $9F */
("STX" | "stx"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_STX_Dir",yyline,yycolumn);} /* $DF */
("STY" | "sty"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_STY_Dir",yyline,yycolumn);} /* $18 DF */

("JSR" | "jsr") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("JSR" | "jsr"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_JSR_Index",yyline,yycolumn);} /* $AD */ /*18 AD*/
("STS" | "sts") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("STS" | "sts"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_STS_Index",yyline,yycolumn);} /* $AF */ /*18 AF*/
("LDX" | "ldx") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LDX" | "ldx"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_LDX_Index",yyline,yycolumn);} /* $EE */ /*CD EE*/
("STX" | "stx") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("STX" | "stx"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_STX_Index",yyline,yycolumn);} /* $EF */ /*CD EF*/
("STY" | "sty") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("STY" | "sty"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_STY_Index",yyline,yycolumn);} /* $1A EF */ /*18 EF*/

("JSR" | "jsr") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_JSR_Ext",yyline,yycolumn);} /* $BD */
("STS" | "sts") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_STS_Ext",yyline,yycolumn);} /* $BF */
("STX" | "stx") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_STX_Ext",yyline,yycolumn);} /* $FF */
("STY" | "sty") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_STY_Ext",yyline,yycolumn);} /* $18 FF */

("XGDY" | "xgdy") {return token(yytext(),"Inst_XGDY",yyline,yycolumn);}      /* $18 8F */
("XGDX" | "xgdx") {return token(yytext(),"Inst_XGDX",yyline,yycolumn);}      /* $8F */

("PSHX" | "pshx") {return token(yytext(),"Inst_PSHX",yyline,yycolumn);}      /* $3C */
("PULX" | "pulx") {return token(yytext(),"Inst_PULX",yyline,yycolumn);}      /* $38 */
("PULY" | "puly") {return token(yytext(),"Inst_PULY",yyline,yycolumn);}      /* $18 38 */
("PSHY" | "pshy") {return token(yytext(),"Inst_PSHY",yyline,yycolumn);}      /* $18 3C */
("TSX" | "tsx") {return token(yytext(),"Inst_TSX",yyline,yycolumn);}      /* $30 */
("TXS" | "txs") {return token(yytext(),"Inst_TXS",yyline,yycolumn);}      /* $35 */

("LDS" | "lds"){EspacioEnBlanco}\#\$({DirSimple}|{DirExt}) {return token(yytext(),"Inst_LDS_INMEDIATO",yyline,yycolumn);}  /* $8E */ 
("LDX" | "ldx"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_LDX_INMEDIATO",yyline,yycolumn);}  /* $CE */ 
("LDY" | "ldy"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_LDY_INMEDIATO",yyline,yycolumn);}  /* $18 CE */ 
("LDD" | "ldd"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_LDD_INMEDIATO",yyline,yycolumn);}  /* $CC */ 
("LDS" | "lds"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_LDS_Dir",yyline,yycolumn);} /* $9E */
("LDX" | "ldx"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_LDX_Dir",yyline,yycolumn);} /* $DE */
("LDY" | "ldy"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_LDY_Dir",yyline,yycolumn);} /* $18 DE */
("LDD" | "ldd"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_LDD_Dir",yyline,yycolumn);} /* $DC */
("STD" | "std"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_STD_Dir",yyline,yycolumn);} /* $DD */
("LDS" | "lds") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LDS" | "lds"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_LDS_Index",yyline,yycolumn);} /* $AE */ /*18 AE*/
("LDX" | "ldx") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LDX" | "ldx"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_LDX_Index",yyline,yycolumn);} /* $FE */ /*18 FE*/
("LDY" | "ldy") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LDY" | "ldy"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_LDY_Index",yyline,yycolumn);} /* $1A EE */ /*18 EC*/
("LDD" | "ldd") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LDD" | "ldd"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_LDD_Index",yyline,yycolumn);} /* $EC */ /*18 EC*/
("STD" | "std") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("STD" | "std"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_STD_Index",yyline,yycolumn);} /* $ED */ /*18 ED*/
("LDS" | "lds") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_LDS_Ext",yyline,yycolumn);} /* $BE */
("LDX" | "ldx") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_LDX_Ext",yyline,yycolumn);} /* $FE */
("LDY" | "ldy") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_LDY_Ext",yyline,yycolumn);} /* $18 FE */
("LDD" | "ldd") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_LDD_Ext",yyline,yycolumn);} /* $FC */
("STD" | "std") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_STD_Ext",yyline,yycolumn);} /* $FD */

/*A*/
("TAP" | "tap") {return token(yytext(),"Inst_TAP",yyline,yycolumn);}      /* $06 */
("TPA" | "tpa") {return token(yytext(),"Inst_TPA",yyline,yycolumn);}      /* $07 */
("TAB" | "tab") {return token(yytext(),"Inst_TAB",yyline,yycolumn);}      /* $16 */
("PULA" | "pula") {return token(yytext(),"Inst_PULA",yyline,yycolumn);}      /* $32 */
("PSHA" | "psha") {return token(yytext(),"Inst_PSHA",yyline,yycolumn);}      /* $36 */
("LDAA" | "ldaa"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_LDAA_INMEDIATO",yyline,yycolumn);}  /* $86 */ 
("LDAA" | "ldaa"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_LDAA_Dir",yyline,yycolumn);} /* $96 */
("STAA" | "staa"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_STAA_Dir",yyline,yycolumn);} /* $97 */
("LDAA" | "ldaa") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LDAA" | "ldaa"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_LDAA_Index",yyline,yycolumn);} /* $A6 */
("STAA" | "staa") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("STAA" | "staa"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_STAA_Index",yyline,yycolumn);} /* $A7 */
("LDAA" | "ldaa") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_LDAA_Ext",yyline,yycolumn);} /* $B6 */
("STAA" | "staa") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_STAA_Ext",yyline,yycolumn);} /* $B7 */

/*B*/
("TBA" | "tba") {return token(yytext(),"Inst_TBA",yyline,yycolumn);}      /* $17 */
("PULB" | "pulb") {return token(yytext(),"Inst_PULB",yyline,yycolumn);}      /* $33 */
("PSHB" | "pshb") {return token(yytext(),"Inst_PSHB",yyline,yycolumn);}      /* $37 */
("LDAB" | "ldab"){EspacioEnBlanco}\#\${DirSimple} {return token(yytext(),"Inst_LDAB_INMEDIATO",yyline,yycolumn);}  /* $C6 */
("LDAB" | "ldab"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_LDAB_Dir",yyline,yycolumn);} /* $D6 */
("STAB" | "stab"){EspacioEnBlanco}\${DirSimple} {return token(yytext(),"Inst_STAB_Dir",yyline,yycolumn);} /* $D7 */
("LDAB" | "ldab") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LDAB" | "ldab"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_LDAB_Index",yyline,yycolumn);} /* $E6 */
("STAB" | "stab") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("STAB" | "stab"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_STAB_Index",yyline,yycolumn);} /* $E7 */
("LDAB" | "ldab") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_LDAB_Ext",yyline,yycolumn);} /* $F6 */
("STAB" | "stab") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_STAB_Ext",yyline,yycolumn);} /* $F7 */

/* Other */

("TEST" | "test") {return token(yytext(),"Inst_TEST",yyline,yycolumn);}      /* $00 */
("NOP" | "nop") {return token(yytext(),"Inst_NOP",yyline,yycolumn);}         /* $01 */
("CLV" | "clv") {return token(yytext(),"Inst_CLV",yyline,yycolumn);}         /* $0A */
("SEV" | "sev") {return token(yytext(),"Inst_SEV",yyline,yycolumn);}         /* $0B */
("CLC" | "clc") {return token(yytext(),"Inst_CLC",yyline,yycolumn);}         /* $0C */
("SEC" | "sec") {return token(yytext(),"Inst_SEC",yyline,yycolumn);}         /* $0D */
("CLI" | "cli") {return token(yytext(),"Inst_CLI",yyline,yycolumn);}         /* $0E */
("SEI" | "sei") {return token(yytext(),"Inst_SEI",yyline,yycolumn);}         /* $0F */
("STOP" | "stop") {return token(yytext(),"Inst_STOP",yyline,yycolumn);}      /* $CF */
("CLR" | "clr") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("CLR" | "clr"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_CLR_Index",yyline,yycolumn);} /*$6F */ /*18 6F*/
("TST" | "tst") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("TST" | "tst"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"Inst_TST_Index",yyline,yycolumn);} /* $6D */
("TST" | "tst") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_TST_Ext",yyline,yycolumn);} /* $7D */
("JMP" | "jmp") {EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_JMP_Ext",yyline,yycolumn);} /* $7E */
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
("BSR" | "bsr") {return token(yytext(),"Inst_BLE",yyline,yycolumn);}         /* $8D */

/* interrupciones */
("RTS" | "rts") {return token(yytext(),"Inst_RTS",yyline,yycolumn);}         /* $39 */
("RTI" | "rti") {return token(yytext(),"Inst_RTI",yyline,yycolumn);}         /* $3B */
("WAI" | "wai") {return token(yytext(),"Inst_WAI",yyline,yycolumn);}         /* $3E */
("SWI" | "swi") {return token(yytext(),"Inst_SWI",yyline,yycolumn);}         /* $3F */

/*ERRORES*/

/* --------------------- ERROR 6 --------------------- */
("RTS" | "rts"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}         
("RTI" | "rti"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}        
("WAI" | "wai"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}         
("SWI" | "swi"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}

("BRA" | "bra"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);} 
("BRN" | "brn"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}   
("BHI" | "bhi"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}  
("BLS" | "bls"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}
("BNE" | "bne"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}
("BEQ" | "beq"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);} 
("BVC" | "bvc"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}
("BVS" | "bvs"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}
("BPL" | "bpl"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}
("BMI" | "bmi"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);} 
("BGE" | "bge"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);} 
("BLT" | "blt"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);} 
("BGT" | "bgt"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);} 
("BLE" | "ble"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);} 
("BSR" | "bsr"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}

("TEST" | "test"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}
("NOP" | "nop"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}         
("CLV" | "clv"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}        
("SEV" | "sev"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}       
("CLC" | "clc"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}        
("SEC" | "sec"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}       
("CLI" | "cli"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      
("SEI" | "sei"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}     
("STOP" | "stop"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}  

("TAP" | "tap"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $06 */
("TPA" | "tpa"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $07 */
("TAB" | "tab"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $16 */
("PULA" | "pula"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $32 */
("PSHA" | "psha"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $36 */
("TBA" | "tba"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $17 */
("PULB" | "pulb") {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $33 */
("PSHB" | "pshb") {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $37 */

("XGDY" | "xgdy"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $18 8F */
("XGDX" | "xgdx"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $8F */

("PSHX" | "pshx"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $3C */
("PULX" | "pulx"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $38 */
("PULY" | "puly"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $18 38 */
("PSHY" | "pshy"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $18 3C */
("TSX" | "tsx"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $30 */
("TXS" | "txs"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $35 */

("LSRD" | "lsrd"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $04 */
("ASLD" | "asld")|("LSLD" | "lsld"){EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $05 */
("LSRA" | "lsra") {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $44 */
("RORA" | "rora") {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $46 */
("ASRA" | "asra") {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $47 */
("ASLA" | "asla")| ("LSLA" | "lsla") {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $48 */
("ROLA" | "rola") {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $49 */
("LSRB" | "lsrb") {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $54 */
("RORB" | "rorb") {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $56 */
("ASRB" | "asrb") {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $57 */
("ASLB" | "aslb")| ("LSLB" | "lslb") {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $58 */
("ROLB" | "rolb") (EspacioEnBlanco) {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $59 */

("TSTB" | "tstb") {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $5D */
"NEGB" | "negb" {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}   /* $50 */
"COMB" | "comb" {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}   /* $53 */
"DECB"|"decb" {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}     /* $5A */
"INCB"|"incb" {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}     /* $5C */
"CLRB"|"clrb" {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}     /* $5F */

"IDIV" | "idiv" {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $02 */
"FDIV" | "fdiv" {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $03 */
"MUL" | "mul" {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $3D */

("CBA" | "cba") {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $11 */
("TSTA" | "tsta") {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $4D */

"INX" | "inx" {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $08 */
"DEX" | "dex" {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $09 */
"INY" | "iny" {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $18 08*/
"DEY" | "dey" {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $18 09*/
"DAA" | "daa" {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $19 */
"INS" | "ins" {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $31 */
"DES" | "des" {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $34 */
"NEGA" | "nega" {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}   /* $40 */
"COMA" | "coma" {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}   /* $43 */
"DECA"|"deca" {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}     /* $4A */
"INCA"|"inca" {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}     /* $4C */
"CLRA"|"clra" {EspacioEnBlanco}(\${DirExt}|\${DirSimple}|{LetraIndex}|\#|\,|\$|{Letra}|{Numero}) {return token(yytext(),"ERROR_6",yyline,yycolumn);}     /* $4F */

"SBA" | "sba" (EspacioEnBlanco) ((\$DirExt)|(\$DirSimple)|(LetraIndex)|\#|\,|\$|(Letra)|(Numero)) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $10 */
"ABA" | "aba" (EspacioEnBlanco) ((\$DirExt)|(\$DirSimple)|(LetraIndex)|\#|\,|\$|(Letra)|(Numero)) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $1B */
"ABY" | "aby" (EspacioEnBlanco) ((\$DirExt)|(\$DirSimple)|(LetraIndex)|\#|\,|\$|(Letra)|(Numero)) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $18 3A */
"ABX" | "abx" (EspacioEnBlanco) ((\$DirExt)|(\$DirSimple)|(LetraIndex)|\#|\,|\$|(Letra)|(Numero)) {return token(yytext(),"ERROR_6",yyline,yycolumn);}      /* $3A */

/* --------------------- ERROR 9 --------------------- */

("ORG" | "org") {DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);}

("SUBA" | "suba")\#\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);}         /* $80 */
("SBCA" | "sbca")\#\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);}      /* $82 */
("SUBD" | "subd")\#\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);}         /* $83 */
("ADCA" | "adca")\#\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);}      /* $89 */
("ADDA" | "adda")\#\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);}      /* $8B */
("ADDD" | "addd")\#\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);}         /* $C3 */

("SUBA" | "suba")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $90 */
("SBCA" | "sbca")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $92 */
("SUBD" | "subd")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $93 */
("ADCA" | "adca")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $99 */
("ADDA" | "adda")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $9B */
("ADDD" | "addd")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $D3 */

("SUBA" | "suba")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $A0 */
("SBCA" | "sbca")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $A2 */
("ADDA" | "adda")\${DirSimple}\,{LetraIndex} | ("ADDA" | "adda")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $AB */
("ADDD" | "addd")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $E3 */

("SUBA" | "suba")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $B0 */
("SBCA" | "sbca")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $B2 */
("SUBD" | "subd")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $B3 */
("ADCA" | "adca")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $B9 */
("ADDA" | "adda")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $BB */
("ADDD" | "addd")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $F3 */

("SUBB" | "subb")\#\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);}         /* $C0 */
("SBCB" | "sbcb")\#\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);}      /* $C2 */
("ADCB" | "adcb")\#\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);}      /* $C9 */
("ADDB" | "addb")\#\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);}      /* $CB */

("SUBB" | "subb")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $D0 */
("SBCB" | "sbcb")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $D2 */
("ADCB" | "adcb")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $D9 */
("ADDB" | "addb")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $DB */

("SUBB" | "subb")\${DirSimple}\,{LetraIndex} | ("SUBB" | "subb")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $E0 */
("SBCB" | "sbcb")\${DirSimple}\,{LetraIndex} | ("SBCB" | "sbcb")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $E2 */
("ADCB" | "adcb")\${DirSimple}\,{LetraIndex} | ("ADCB" | "adcb")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $E9 */
("ADDB" | "addb")\${DirSimple}\,{LetraIndex} | ("ADDB" | "addb")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $EB */

("SUBB" | "subb")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $F0 */
("SBCB" | "sbcb")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $F2 */
("ADCB" | "adcb")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $F9 */
("ADDB" | "addb")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $FB */

("NEG" | "neg")\${DirSimple}\,{LetraIndex} | ("NEG" | "neg")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $60 */
("COM" | "com")\${DirSimple}\,{LetraIndex} | ("COM" | "com")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $63 */
("DEC" | "dec")\${DirSimple}\,{LetraIndex} | ("DEC" | "dec")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $6A */
("INC" | "inc")\${DirSimple}\,{LetraIndex} | ("INC" | "inc")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $6C */
("CLR" | "clr")\${DirSimple}\,{LetraIndex} | ("CLR" | "clr")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $6F */
("NEG" | "neg")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $70 */
("COM" | "com")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $73 */
("DEC" | "dec")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $7A */
("INC" | "inc")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $7C */
("CLR" | "CLR")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $7C */

("CMPA" | "cmpa")\#\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);}      /* $81 */
("BITA" | "bita")\#\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);}      /* $85 */
("CPX" | "cpx")\#\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);}         /* $8C */
("CPY" | "cpy")\#\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);}         /* $18 8C */
("CPD" | "cpd")\#\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);}         /* $1A 83 */

("CMPA" | "cmpa")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $91 */
("BITA" | "bita")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $95 */
("CPX" | "cpx")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $9C */
("CPY" | "cpy")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $18 9C */
("CPD" | "cpd")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $1A 93 */

("CMPA" | "cmpa")\${DirSimple}\,{LetraIndex} | ("CMPA" | "cmpa")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $A2 */
("BITA" | "bita")\${DirSimple}\,{LetraIndex} | ("BITA" | "bita")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $A5 */
("CPX" | "cpx")\${DirSimple}\,{LetraIndex} | ("CPX" | "cpx")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $AC */
("CPY" | "cpy")\${DirSimple}\,{LetraIndex} | ("CTY" | "cty")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $1A AC */ /*18 AC*/
("CPD" | "cpd")\${DirSimple}\,{Letra} | ("CPD" | "cpd")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $1A A3 */

("CMPA" | "cmpa")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $B1 */
("BITA" | "bita")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $B5 */
("CPX" | "cpx")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $BC */
("CPY" | "cpy")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $18 BC */
("CPD" | "cpd")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $1A B3 */

("CMPB" | "cmpb")\#\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);}      /* $C1 */
("BITB" | "bitb")\#\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);}      /* $C5 */

("CMPB" | "cmpb")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $D1 */
("BITB" | "bitb")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $D5 */

("CMPB" | "cmpb")\${DirSimple}\,{LetraIndex} | ("CMPB" | "cmpb")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $E1 */
("BITB" | "bitb")\${DirSimple}\,{LetraIndex} | ("BITB" | "bitb")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $E5 */

("CMPB" | "cmpb")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $F1 */
("BITB" | "bitb")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $F5 */

/*Instrucciones de salto y bifurcacion*/
("BRSET" | "brset")\${DirSimple}\,\#{DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $12 */
("BRCLR" | "brclr")\${DirSimple}\,\#{DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $13 */
("BRSET" | "brset")\${DirSimple}\,{LetraIndex}\,\#{DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $1F */
("BRCLR" | "brclr")\${DirSimple}\,{LetraIndex}\,\#{DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $1F */

/*Instrucciones de control*/
("BSET" | "bset")\${DirSimple}\,\#{DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $14 */
("BCLR" | "bclr")\${DirSimple}\,\#{DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $16 */
("BSET" | "bset")\${DirSimple}\,{LetraIndex}\,\#{DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $1C */
("BCLR" | "bclr")\${DirSimple}\,{LetraIndex}\,\#{DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $1F */

/*Instrucciones logicas*/
/*A*/
("ORAA" | "oraa")\#\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);}      /* $8A */
("ANDA" | "anda")\#\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);}      /* $84 */
("EORA" | "eora")\#\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);}      /* $88 */

("ORAA" | "oraa")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $9A */
("ANDA" | "anda")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $94 */
("EORA" | "eora")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $98 */

("ORAA" | "oraa")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $BA */
("ANDA" | "anda")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $B4 */
("EORA" | "eora")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $B8 */

("ORAA" | "oraa")\${DirSimple}\,{LetraIndex} | ("ORAA" | "oraa")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $AA */
("ANDA" | "anda")\${DirSimple}\,{LetraIndex} | ("ANDA" | "anda")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $A4 */
("EORA" | "eora")\${DirSimple}\,{LetraIndex} | ("EORA" | "eora")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $A8 */

/* B */
("ANDB" | "andb")\#\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);}      /* $C4 */
("EORB" | "eorb")\#\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);}      /* $C8 */
("ORAB" | "orab")\#\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);}      /* $CA */

("ANDB" | "andb")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $D4 */
("EORB" | "eorb")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $D8 */
("ORAB" | "orab")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $DA */

("ORAB" | "orab")\${DirSimple}\,{LetraIndex} | ("ORAB" | "orab")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $EA */ /*18 EA*/
("ANDB" | "andb")\${DirSimple}\,{LetraIndex} | ("ANDB" | "andb")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $E4 */ /*18 E4*/
("EORB" | "eorb")\${DirSimple}\,{LetraIndex} | ("EORB" | "eorb")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $E8 */ /*18 E8*/

("EORB" | "eorb")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $F8 */
("ORAB" | "orab")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $FA */
("ANDB" | "andb")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $F4 */
("LSR" | "lsr") \${DirSimple}\,{LetraIndex} | ("LSR" | "lsr"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $64 */ /*18 64*/
("ASR" | "asr") \${DirSimple}\,{LetraIndex} | ("ASR" | "asr"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $A7 */
("ROR" | "ror") \${DirSimple}\,{LetraIndex} | ("ROR" | "ror"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $66 */ /*18 66*/
("ROL" | "rol") \${DirSimple}\,{LetraIndex} | ("ROL" | "rol"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $69 */ /*18 69*/
("JMP" | "jmp") \${DirSimple}\,{LetraIndex} | ("JMP" | "jmp"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $6E */ /*18 6E*/

("ASL" | "asl")| ("LSL" | "lsl")\${DirSimple}\,{LetraIndex} | ("ASL" | "asl")| ("LSL" | "lsl")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $A8 */
("LSR" | "lsr") \${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $74 */
("ASR" | "asr") \${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $77 */
("ROR" | "ror") \${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $76 */
("ROL" | "rol") \${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $79 */

("ASL" | "asl")| ("LSL" | "lsl")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $78 */

("JSR" | "jsr")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $9D */
("STS" | "sts")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $9F */
("STX" | "stx")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $DF */
("STY" | "sty")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $18 DF */

("JSR" | "jsr") \${DirSimple}\,{LetraIndex} | ("JSR" | "jsr")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $AD */ /*18 AD*/
("STS" | "sts") \${DirSimple}\,{LetraIndex} | ("STS" | "sts")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $AF */ /*18 AF*/
("LDX" | "ldx") \${DirSimple}\,{LetraIndex} | ("LDX" | "ldx")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $EE */ /*CD EE*/
("STX" | "stx") \${DirSimple}\,{LetraIndex} | ("STX" | "stx")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $EF */ /*CD EF*/
("STY" | "sty") \${DirSimple}\,{LetraIndex} | ("STY" | "sty")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $1A EF */ /*18 EF*/

("JSR" | "jsr") \${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $BD */
("STS" | "sts") \${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $BF */
("STX" | "stx") \${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $FF */
("STY" | "sty") \${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $18 FF */

("LDS" | "lds")\#\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);}  /* $8E */ 
("LDX" | "ldx")\#\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);}  /* $CE */ 
("LDY" | "ldy")\#\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);}  /* $18 CE */ 
("LDD" | "ldd")\#\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);}  /* $CC */ 
("LDS" | "lds")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $9E */
("LDX" | "ldx")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $DE */
("LDY" | "ldy")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $18 DE */
("LDD" | "ldd")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $DC */
("STD" | "std")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $DD */
("LDS" | "lds") \${DirSimple}\,{LetraIndex} | ("LDS" | "lds")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $AE */ /*18 AE*/
("LDX" | "ldx") \${DirSimple}\,{LetraIndex} | ("LDX" | "ldx")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $FE */ /*18 FE*/
("LDY" | "ldy") \${DirSimple}\,{LetraIndex} | ("LDY" | "ldy")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $1A EE */ /*18 EC*/
("LDD" | "ldd") \${DirSimple}\,{LetraIndex} | ("LDD" | "ldd")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $EC */ /*18 EC*/
("STD" | "std") \${DirSimple}\,{LetraIndex} | ("STD" | "std")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $ED */ /*18 ED*/
("LDS" | "lds")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $BE */
("LDX" | "ldx")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $FE */
("LDY" | "ldy")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $18 FE */
("LDD" | "ldd")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $FC */
("STD" | "std")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $FD */

("LDAA" | "ldaa")\#\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);}  /* $86 */ 
("LDAA" | "ldaa")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $96 */
("STAA" | "staa")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $97 */
("LDAA" | "ldaa")\${DirSimple}\,{LetraIndex} | ("LDAA" | "ldaa"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $A6 */
("STAA" | "staa")\${DirSimple}\,{LetraIndex} | ("STAA" | "staa"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $A7 */
("LDAA" | "ldaa")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $B6 */
("STAA" | "staa")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $B7 */
("LDAB" | "ldab")\#\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);}  /* $C6 */
("LDAB" | "ldab")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $D6 */
("STAB" | "stab")\${DirSimple} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $D7 */
("LDAB" | "ldab")\${DirSimple}\,{LetraIndex} | ("LDAB" | "ldab")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $E6 */
("STAB" | "stab")\${DirSimple}\,{LetraIndex} | ("STAB" | "stab")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $E7 */
("LDAB" | "ldab")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $F6 */
("STAB" | "stab")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $F7 */

("CLR" | "clr")\${DirSimple}\,{LetraIndex} | ("CLR" | "clr")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /*$6F */ /*18 6F*/
("TST" | "tst")\${DirSimple}\,{LetraIndex} | ("TST" | "tst")\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $6D */
("TST" | "tst")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $7D */
("JMP" | "jmp")\${DirExt} {return token(yytext(),"ERROR_9",yyline,yycolumn);} /* $7E */
