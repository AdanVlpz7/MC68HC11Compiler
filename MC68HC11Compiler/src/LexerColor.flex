import compilerTools.TextColor;
import java.awt.Color;

%%
%class LexerColor
%type TextColor
%char
%{
    private TextColor textColor(long start, int size, Color color){
        return new TextColor((int) start, size, color);
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
\${DirSimple} { return textColor(yychar, yylength(), new Color(254, 164, 160)); }
\${DirExt} { return textColor(yychar, yylength(), new Color(254, 164, 160)); }

/* Signos de operacion */
"#" { return textColor(yychar, yylength(), new Color(167, 97, 94)); }
"$" { return textColor(yychar, yylength(), new Color(167, 97, 94)); }
"," { return textColor(yychar, yylength(), new Color(167, 97, 94)); }

/* Directivas */
("ORG" | "org") { return textColor(yychar, yylength(), new Color(138, 14, 146)); }

"EQU" | "equ" { return textColor(yychar, yylength(), new Color(138, 14, 146)); }

"FCB" | "fcb" { return textColor(yychar, yylength(), new Color(138, 14, 146)); }

/* FINAL */
"END" | "end" { return textColor(yychar, yylength(), new Color(138, 14, 146)); }

/*INSTRUCCIONES*/

{Comentario} { return textColor(yychar, yylength(), new Color(146, 146, 146)); } //comentarios en gris
{EspacioEnBlanco} { /*Ignorar*/ }

("SBA" | "sba") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $10 */
("ABA" | "aba") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $1B */
("ABY" | "aby") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $18 3A */
("ABX" | "abx") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $3A */

("SUBA" | "suba"){EspacioEnBlanco}\#\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $80 */
("SBCA" | "sbca"){EspacioEnBlanco}\#\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $82 */
("SUBD" | "subd"){EspacioEnBlanco}\#\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $83 */
("ADCA" | "adca"){EspacioEnBlanco}\#\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }    /* $89 */
("ADDA" | "adda"){EspacioEnBlanco}\#\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $8B */
("ADDD" | "addd"){EspacioEnBlanco}\#\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $C3 */

("SUBA" | "suba"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $90 */
("SBCA" | "sbca"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $92 */
("SUBD" | "subd"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $93 */
("ADCA" | "adca"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $99 */
("ADDA" | "adda"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $9B */
("ADDD" | "addd"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $D3 */

("SUBA" | "suba"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $A0 */
("SBCA" | "sbca"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $A2 */
("ADDA" | "adda"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ADDA" | "adda"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $AB */
("ADDD" | "addd"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $E3 */

("SUBA" | "suba"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $B0 */
("SBCA" | "sbca"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $B2 */
("SUBD" | "subd"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $B3 */
("ADCA" | "adca"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $B9 */
("ADDA" | "adda"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $BB */
("ADDD" | "addd"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $F3 */

/* B */
("SUBB" | "subb"){EspacioEnBlanco}\#\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }        /* $C0 */
("SBCB" | "sbcb"){EspacioEnBlanco}\#\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $C2 */
("ADCB" | "adcb"){EspacioEnBlanco}\#\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $C9 */
("ADDB" | "addb"){EspacioEnBlanco}\#\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $CB */

("SUBB" | "subb")\${DirSimple} | ("SUBB" | "subb"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $D0 */
("SBCB" | "sbcb")\${DirSimple} | ("SBCB" | "sbcb"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $D2 */
("ADCB" | "adcb")\${DirSimple} | ("ADCB" | "adcb"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $D9 */
("ADDB" | "addb")\${DirSimple} | ("ADDB" | "addb"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $DB */

("SUBB" | "subb"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("SUBB" | "subb"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $E0 */
("SBCB" | "sbcb"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("SBCB" | "sbcb"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $E2 */
("ADCB" | "adcb"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ADCB" | "adcb"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $E9 */
("ADDB" | "addb"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ADDB" | "addb"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $EB */

("SUBB" | "subb")\${DirExt} | ("SUBB" | "subb"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $F0 */
("SBCB" | "sbcb")\${DirExt} | ("SBCB" | "sbcb"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $F2 */
("ADCB" | "adcb")\${DirExt} | ("ADCB" | "adcb"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $F9 */
("ADDB" | "addb")\${DirExt} | ("ADDB" | "addb"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $FB */

/*Instrucciones aritmeticas de incremento y decremento*/
"INX" | "inx" { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $08 */
"DEX" | "dex" { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $09 */
"INY" | "iny" { return textColor(yychar, yylength(), new Color(255, 87, 51)); }     /* $18 08*/
"DEY" | "dey" { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $18 09*/
"DAA" | "daa" { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $19 */
"INS" | "ins" { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $31 */
"DES" | "des" { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $34 */
"NEGA" | "nega" { return textColor(yychar, yylength(), new Color(255, 87, 51)); }   /* $40 */
"COMA" | "coma" { return textColor(yychar, yylength(), new Color(255, 87, 51)); }  /* $43 */
"DECA"|"deca" { return textColor(yychar, yylength(), new Color(255, 87, 51)); }     /* $4A */
"INCA"|"inca" { return textColor(yychar, yylength(), new Color(255, 87, 51)); }     /* $4C */
"CLRA"|"clra" { return textColor(yychar, yylength(), new Color(255, 87, 51)); }     /* $4F */
("NEG" | "neg"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("NEG" | "neg"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $60 */
("COM" | "com"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("COM" | "com"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $63 */
("DEC" | "dec"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("DEC" | "dec"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $6A */
("INC" | "inc"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("INC" | "inc"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $6C */
("CLR" | "clr"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("CLR" | "clr"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $6F */
("NEG" | "neg"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $70 */
("COM" | "com"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $73 */
("DEC" | "dec"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $7A */
("INC" | "inc"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $7C */
("CLR" | "clr"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $7C */


/*b*/
"NEGB" | "negb" { return textColor(yychar, yylength(), new Color(255, 87, 51)); }  /* $50 */
"COMB" | "comb" { return textColor(yychar, yylength(), new Color(255, 87, 51)); }   /* $53 */
"DECB"|"decb" { return textColor(yychar, yylength(), new Color(255, 87, 51)); }     /* $5A */
"INCB"|"incb" { return textColor(yychar, yylength(), new Color(255, 87, 51)); }     /* $5C */
"CLRB"|"clrb" { return textColor(yychar, yylength(), new Color(255, 87, 51)); }     /* $5F */

/*Instrucciones aritmeticas de multiplicacion y division*/
"IDIV" | "idiv" { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $02 */
"FDIV" | "fdiv" { return textColor(yychar, yylength(), new Color(255, 87, 51)); }    /* $03 */
"MUL" | "mul" { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $3D */

/*Instrucciones de comparacion */
("CBA" | "cba") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $11 */
("TSTA" | "tsta") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $4D */

("CMPA" | "cmpa"){EspacioEnBlanco}\#\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $81 */
("BITA" | "bita"){EspacioEnBlanco}\#\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $85 */
("CPX" | "cpx"){EspacioEnBlanco}\#\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $8C */
("CPY" | "cpy"){EspacioEnBlanco}\#\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $18 8C */
("CPD" | "cpd"){EspacioEnBlanco}\#\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $1A 83 */

("CMPA" | "cmpa"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $91 */
("BITA" | "bita"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $95 */
("CPX" | "cpx"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $9C */
("CPY" | "cpy"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $18 9C */
("CPD" | "cpd"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $1A 93 */

("CMPA" | "cmpa"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("CMPA" | "cmpa"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $A2 */
("BITA" | "bita"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("BITA" | "bita"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $A5 */
("CPX" | "cpx"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("CPX" | "cpx"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $AC */
("CPY" | "cpy") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("CTY" | "cty"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $1A AC */ /*18 AC*/
("CPD" | "cpd"){EspacioEnBlanco}\${DirSimple}\,{Letra} | ("CPD" | "cpd"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $1A A3 */

("CMPA" | "cmpa"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $B1 */
("BITA" | "bita"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $B5 */
("CPX" | "cpx"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $BC */
("CPY" | "cpy"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $18 BC */
("CPD" | "cpd"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $1A B3 */

/*B*/
("TSTB" | "tstb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $5D */

("CMPB" | "cmpb"){EspacioEnBlanco}\#\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $C1 */
("BITB" | "bitb"){EspacioEnBlanco}\#\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $C5 */

("CMPB" | "cmpb"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $D1 */
("BITB" | "bitb"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $D5 */

("CMPB" | "cmpb"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("CMPB" | "cmpb"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $E1 */
("BITB" | "bitb"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("BITB" | "bitb"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $E5 */

("CMPB" | "cmpb"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $F1 */
("BITB" | "bitb"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $F5 */


/*Instrucciones de salto y bifurcacion*/
("BRSET" | "brset"){EspacioEnBlanco}\${DirSimple}\,\#{DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $12 */
("BRCLR" | "brclr"){EspacioEnBlanco}\${DirSimple}\,\#{DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $13 */
("BRSET" | "brset"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex}\,\#{DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $1F */
("BRCLR" | "brclr"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex}\,\#{DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $1F */

/*Instrucciones de control*/
("BSET" | "bset"){EspacioEnBlanco}\${DirSimple}\,\#{DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $14 */
("BCLR" | "bclr"){EspacioEnBlanco}\${DirSimple}\,\#{DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $16 */
("BSET" | "bset"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex}\,\#{DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $1C */
("BCLR" | "bclr"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex}\,\#{DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $1F */

/*Instrucciones logicas*/
/*A*/
("ORAA" | "oraa"){EspacioEnBlanco}\#\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $8A */
("ANDA" | "anda"){EspacioEnBlanco}\#\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $84 */
("EORA" | "eora"){EspacioEnBlanco}\#\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $88 */

("ORAA" | "oraa"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $9A */
("ANDA" | "anda"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $94 */
("EORA" | "eora"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $98 */

("ORAA" | "oraa"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $BA */
("ANDA" | "anda"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $B4 */
("EORA" | "eora"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $B8 */

("ORAA" | "oraa"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ORAA" | "oraa"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $AA */
("ANDA" | "anda"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ANDA" | "anda"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $A4 */
("EORA" | "eora"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("EORA" | "eora"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $A8 */

/* B */
("ANDB" | "andb"){EspacioEnBlanco}\#\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $C4 */
("EORB" | "eorb"){EspacioEnBlanco}\#\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $C8 */
("ORAB" | "orab"){EspacioEnBlanco}\#\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $CA */

("ANDB" | "andb"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $D4 */
("EORB" | "eorb"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $D8 */
("ORAB" | "orab"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $DA */

("ORAB" | "orab"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ORAB" | "orab"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $EA */ /*18 EA*/
("ANDB" | "andb"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ANDB" | "andb"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $E4 */ /*18 E4*/
("EORB" | "eorb"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("EORB" | "eorb"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $E8 */ /*18 E8*/

("EORB" | "eorb"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $F8 */
("ORAB" | "orab"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $FA */
("ANDB" | "andb"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $F4 */

/*Instrucciones de rotacion y desplazamiento*/

("LSRD" | "lsrd") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $04 */
("ASLD" | "asld")|("LSLD" | "lsld") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $05 */
("LSRA" | "lsra") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $44 */
("RORA" | "rora") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $46 */
("ASRA" | "asra") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $47 */
("ASLA" | "asla")| ("LSLA" | "lsla") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $48 */
("ROLA" | "rola") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $49 */
("LSR" | "lsr") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LSR" | "lsr"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $64 */ /*18 64*/
("ASR" | "asr") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ASR" | "asr"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $A7 */
("ROR" | "ror") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ROR" | "ror"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $66 */ /*18 66*/
("ROL" | "rol") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ROL" | "rol"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $69 */ /*18 69*/
("JMP" | "jmp") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("JMP" | "jmp"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $6E */ /*18 6E*/

("ASL" | "asl")| ("LSL" | "lsl"){EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("ASL" | "asl")| ("LSL" | "lsl"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $A8 */
("LSR" | "lsr") {EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $74 */
("ASR" | "asr") {EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $77 */
("ROR" | "ror") {EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $76 */
("ROL" | "rol") {EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $79 */

("ASL" | "asl")| ("LSL" | "lsl"){EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $78 */
/*B*/
("LSRB" | "lsrb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $54 */
("RORB" | "rorb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $56 */
("ASRB" | "asrb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $57 */
("ASLB" | "aslb")| ("LSLB" | "lslb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $58 */
("ROLB" | "rolb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $59 */

/*Instrucciones de transferencia*/

("JSR" | "jsr"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $9D */
("STS" | "sts"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $9F */
("STX" | "stx"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $DF */
("STY" | "sty"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $18 DF */

("JSR" | "jsr") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("JSR" | "jsr"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $AD */ /*18 AD*/
("STS" | "sts") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("STS" | "sts"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $AF */ /*18 AF*/
("LDX" | "ldx") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LDX" | "ldx"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $EE */ /*CD EE*/
("STX" | "stx") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("STX" | "stx"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $EF */ /*CD EF*/
("STY" | "sty") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("STY" | "sty"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $1A EF */ /*18 EF*/

("JSR" | "jsr") {EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $BD */
("STS" | "sts") {EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $BF */
("STX" | "stx") {EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $FF */
("STY" | "sty") {EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $18 FF */

("XGDY" | "xgdy") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $18 8F */
("XGDX" | "xgdx") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $8F */

("PSHX" | "pshx") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $3C */
("PULX" | "pulx") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $38 */
("PULY" | "puly") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $18 38 */
("PSHY" | "pshy") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $18 3C */
("TSX" | "tsx") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $30 */
("TXS" | "txs") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $35 */

("LDS" | "lds"){EspacioEnBlanco}\#\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }  /* $8E */ 
("LDX" | "ldx"){EspacioEnBlanco}\#\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }  /* $CE */ 
("LDY" | "ldy"){EspacioEnBlanco}\#\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }  /* $18 CE */ 
("LDD" | "ldd"){EspacioEnBlanco}\#\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }  /* $CC */ 
("LDS" | "lds"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $9E */
("LDX" | "ldx"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $DE */
("LDY" | "ldy"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $18 DE */
("LDD" | "ldd"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $DC */
("STD" | "std"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }/* $DD */
("LDS" | "lds") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LDS" | "lds"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $AE */ /*18 AE*/
("LDX" | "ldx") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LDX" | "ldx"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $FE */ /*18 FE*/
("LDY" | "ldy") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LDY" | "ldy"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $1A EE */ /*18 EC*/
("LDD" | "ldd") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LDD" | "ldd"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $EC */ /*18 EC*/
("STD" | "std") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("STD" | "std"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $ED */ /*18 ED*/
("LDS" | "lds") {EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $BE */
("LDX" | "ldx") {EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $FE */
("LDY" | "ldy") {EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $18 FE */
("LDD" | "ldd") {EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $FC */
("STD" | "std") {EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $FD */

/*A*/
("TAP" | "tap") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $06 */
("TPA" | "tpa") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $07 */
("TAB" | "tab") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $16 */
("PULA" | "pula") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $32 */
("PSHA" | "psha") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $36 */
("LDAA" | "ldaa"){EspacioEnBlanco}\#\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }  /* $86 */ 
("LDAA" | "ldaa"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $96 */
("STAA" | "staa"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $97 */
("LDAA" | "ldaa") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LDAA" | "ldaa"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $A6 */
("STAA" | "staa") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("STAA" | "staa"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $A7 */
("LDAA" | "ldaa") {EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $B6 */
("STAA" | "staa") {EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $B7 */

/*B*/
("TBA" | "tba") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $17 */
("PULB" | "pulb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $33 */
("PSHB" | "pshb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $37 */
("LDAB" | "ldab"){EspacioEnBlanco}\#\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); }  /* $C6 */
("LDAB" | "ldab"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $D6 */
("STAB" | "stab"){EspacioEnBlanco}\${DirSimple} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $D7 */
("LDAB" | "ldab") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("LDAB" | "ldab"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $E6 */
("STAB" | "stab") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("STAB" | "stab"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $E7 */
("LDAB" | "ldab") {EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $F6 */
("STAB" | "stab") {EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $F7 */

/* Other */

("TEST" | "test") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $00 */
("NOP" | "nop") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $01 */
("CLV" | "clv") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $0A */
("SEV" | "sev") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $0B */
("CLC" | "clc") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $0C */
("SEC" | "sec") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $0D */
("CLI" | "cli") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $0E */
("SEI" | "sei") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $0F */
("STOP" | "stop") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $CF */
("CLR" | "clr") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("CLR" | "clr"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /*$6F */ /*18 6F*/
("TST" | "tst") {EspacioEnBlanco}\${DirSimple}\,{LetraIndex} | ("TST" | "tst"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{LetraIndex} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $6D */
("TST" | "tst") {EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $7D */
("JMP" | "jmp") {EspacioEnBlanco}\${DirExt} { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $7E */
/* Branches */

("BRA" | "bra") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $20 */
("BRN" | "brn") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $21 */
("BHI" | "bhi") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $22 */
("BLS" | "bls") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $23 */
("BCC" | "bcc") |("BHS" | "bhs")  { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $24 */
("BCS" | "bcs") |("BLO" | "blo")  { return textColor(yychar, yylength(), new Color(255, 87, 51)); }        /* $25 */

("BNE" | "bne") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $26 */
("BEQ" | "beq") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $27 */
("BVC" | "bvc") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $28 */
("BVS" | "bvs") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $29 */
("BPL" | "bpl") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }        /* $2A */
("BMI" | "bmi") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $2B */
("BGE" | "bge") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }        /* $2C */
("BLT" | "blt") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }        /* $2D */
("BGT" | "bgt") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }        /* $2E */
("BLE" | "ble") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }        /* $2F */
("BSR" | "bsr") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $8D */

/* interrupciones */
("RTS" | "rts") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $39 */
("RTI" | "rti") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $3B */
("WAI" | "wai") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }        /* $3E */
("SWI" | "swi") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $3F */
