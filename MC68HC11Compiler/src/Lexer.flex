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

/*Instrucciones aritmeticas*/
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
"CLRA"|"clra" {return token(yytext(),"Inst_CLRA",yyline,yycolumn);}     /* $4F */
("NEG" | "neg"){EspacioEnBlanco}\${DirSimple}\,{Letra} | ("NEG" | "neg"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{Letra} {return token(yytext(),"Inst_NEG_Index",yyline,yycolumn);} /* $60 */
("COM" | "com"){EspacioEnBlanco}\${DirSimple}\,{Letra} | ("COM" | "com"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{Letra} {return token(yytext(),"Inst_COM_Index",yyline,yycolumn);} /* $63 */
("DEC" | "dec"){EspacioEnBlanco}\${DirSimple}\,{Letra} | ("DEC" | "dec"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{Letra} {return token(yytext(),"Inst_DEC_Index",yyline,yycolumn);} /* $6A */
("INC" | "inc"){EspacioEnBlanco}\${DirSimple}\,{Letra} | ("INC" | "inc"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{Letra} {return token(yytext(),"Inst_INC_Index",yyline,yycolumn);} /* $6C */
("CLR" | "clr"){EspacioEnBlanco}\${DirSimple}\,{Letra} | ("CLR" | "clr"){EspacioEnBlanco}\${DirSimple}\,{EspacioEnBlanco}{Letra} {return token(yytext(),"Inst_CLR_Index",yyline,yycolumn);} /* $6F */
("NEG" | "neg")\${DirExt} | ("NEG" | "neg"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_NEG_Ext",yyline,yycolumn);} /* $70 */
("COM" | "com")\${DirExt} | ("COM" | "com"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_INC_Ext",yyline,yycolumn);} /* $73 */
("DEC" | "dec")\${DirExt} | ("DEC" | "dec"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_DEC_Ext",yyline,yycolumn);} /* $7A */
("INC" | "inc")\${DirExt} | ("INC" | "inc"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_COM_Ext",yyline,yycolumn);} /* $7C */
("CLR" | "CLR")\${DirExt} | ("CLR" | "clr"){EspacioEnBlanco}\${DirExt} {return token(yytext(),"Inst_CLR_Ext",yyline,yycolumn);} /* $7C */
