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
ComentarioTradicional = "*" [^*] 
FinDeLineaComentario = "" {EntradaDeCaracter}* {TerminadorDeLinea}?
ContenidoComentario = ( [^*] | \*+ [^/*] )*
ComentarioDeDocumentacion = "*" {ContenidoComentario} 

/* Comentario */
Comentario = {ComentarioTradicional}

/* Identificador */
Letra = [A-Za-zÑñ_ÁÉÍÓÚáéíóúÜü]
Digito = [0-9]
Identificador = {Letra}({Letra}|{Digito})*

/* Número */
Numero = 0 | [1-9][0-9]*
%%

/* Comentarios o espacios en blanco */
{Comentario}|{EspacioEnBlanco} { /*Ignorar*/ }

/* Identificador */
\${Identificador} { return token(yytext(), "IDENTIFICADOR", yyline, yycolumn); }
. { return token(yytext(), "ERROR", yyline, yycolumn); }

/* Operadores de agrupacion */
"(" {return token(yytext(),"PARENTESIS_A",yyline,yycolumn);}
")" {return token(yytext(),"PARENTESIS_C",yyline,yycolumn);}
"{" {return token(yytext(),"LLAVE_A",yyline,yycolumn);}
"}" {return token(yytext(),"LLAVE_C",yyline,yycolumn);}

/* Signos de operacion */
"#" {return token(yytext(),"LLAVE_A",yyline,yycolumn);}
"$" {return token(yytext(),"LLAVE_C",yyline,yycolumn);}

/* Directivas */
"ORG" | "org" {return token(yytext(),"Directiva_ORG",yyline,yycolumn);}
"EQU" | "equ" {return token(yytext(),"Directiva_EQU",yyline,yycolumn);}
"FCB" | "fcb" {return token(yytext(),"Directiva_FCB",yyline,yycolumn);}
"END" | "end" {return token(yytext(),"Directiva_END",yyline,yycolumn);}
