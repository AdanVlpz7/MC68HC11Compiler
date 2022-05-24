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
EspacioEnBlanco = {TerminadorDeLinea}
tab = [ \t\f]
ComentarioEspecial = "*" {EntradaDeCaracter}*{TerminadorDeLinea}?

/* Comentario */
Comentario = {ComentarioEspecial}

/* Identificador */

LetraIndex = [X | x] | [Y|y]
Letra = [A-Za-zÑñ_ÁÉÍÓÚáéíóúÜü]
Digito = [0-9]
Identificador = {Letra}({Letra}|{Digito})*
Identifier = [:jletter:] [:jletterdigit:]*
DirSimple = ({Letra}|{Digito})({Letra}|{Digito}) | ({Letra}|{Digito})  
DirExt = {DirSimple}{DirSimple} | {DirSimple}({Letra}|{Digito}) 

%%
/* Direccion */
\${DirSimple}|{DirSimple} { return token(yytext(), "DirSimple", yyline, yycolumn); }
\${DirExt} { return token(yytext(), "DirEXT", yyline, yycolumn); }
/* Comentarios o espacios en blanco */
{Comentario}|{EspacioEnBlanco} { /*Ignorar*/ }

/* Signos de operacion */
"#" {return token(yytext(),"GATO",yyline,yycolumn);}

"$" {return token(yytext(),"PESOS",yyline,yycolumn);}
"," {return token(yytext(),"COMA",yyline,yycolumn);}
{tab} {return token(yytext(),"TAB",yyline,yycolumn);}

/* Directivas */
("INICIO"|"inicio") {return token(yytext(),"INICIO",yyline,yycolumn);}
("ORG" | "org") {return token(yytext(),"Directiva_ORG",yyline,yycolumn);}

"EQU" | "equ" {return token(yytext(),"Directiva_EQU",yyline,yycolumn);}

"FCB" | "fcb" {return token(yytext(),"Directiva_FCB",yyline,yycolumn);}

/* FINAL */
"END" | "end" {return token(yytext(),"FINAL",yyline,yycolumn);}

/*INSTRUCCIONES*/

/*Instrucciones aritmeticas de suma y resta*/

("SBA" | "sba") {return token(yytext(),"Inst_SBA",yyline,yycolumn);} 
("ABA" | "aba") {return token(yytext(),"Inst_ABA",yyline,yycolumn);}     
("ABY" | "aby") {return token(yytext(),"Inst_ABY",yyline,yycolumn);}      
("ABX" | "abx") {return token(yytext(),"Inst_ABX",yyline,yycolumn);}     

("SUBA" | "suba") {return token(yytext(),"Inst_SUBA",yyline,yycolumn);}        
("SBCA" | "sbca") {return token(yytext(),"Inst_SBCA",yyline,yycolumn);}      
("SUBD" | "subd") {return token(yytext(),"Inst_SUBD",yyline,yycolumn);}        
("ADCA" | "adca") {return token(yytext(),"Inst_ADCA",yyline,yycolumn);}  
("ADDA" | "adda") {return token(yytext(),"Inst_ADDA",yyline,yycolumn);}     
("ADDD" | "addd") {return token(yytext(),"Inst_ADDD",yyline,yycolumn);}      

/* B */
("SUBB" | "subb") {return token(yytext(),"Inst_SUBB",yyline,yycolumn);}      
("SBCB" | "sbcb") {return token(yytext(),"Inst_SBCB",yyline,yycolumn);}     
("ADCB" | "adcb") {return token(yytext(),"Inst_ADCB",yyline,yycolumn);}     
("ADDB" | "addb") {return token(yytext(),"Inst_ADDB",yyline,yycolumn);}      

/*Instrucciones aritmeticas de incremento y decremento*/
"INX" | "inx" {return token(yytext(),"Inst_INX",yyline,yycolumn);}      
"DEX" | "dex" {return token(yytext(),"Inst_DEX",yyline,yycolumn);}   
"INY" | "iny" {return token(yytext(),"Inst_INY",yyline,yycolumn);}     
"DEY" | "dey" {return token(yytext(),"Inst_DEY",yyline,yycolumn);}     
"DAA" | "daa" {return token(yytext(),"Inst_DAA",yyline,yycolumn);}     
"INS" | "ins" {return token(yytext(),"Inst_INS",yyline,yycolumn);}     
"DES" | "des" {return token(yytext(),"Inst_DES",yyline,yycolumn);}     
"NEGA" | "nega" {return token(yytext(),"Inst_NEGA",yyline,yycolumn);}   
"COMA" | "coma" {return token(yytext(),"Inst_COMA",yyline,yycolumn);}   
"DECA"|"deca" {return token(yytext(),"Inst_DECA",yyline,yycolumn);}     
"INCA"|"inca" {return token(yytext(),"Inst_INCA",yyline,yycolumn);}     
"CLRA"|"clra" {return token(yytext(),"Inst_CLRA",yyline,yycolumn);}     

("NEG" | "neg") {return token(yytext(),"Inst_NEG",yyline,yycolumn);} 
("COM" | "com") {return token(yytext(),"Inst_COM",yyline,yycolumn);} 
("DEC" | "dec") {return token(yytext(),"Inst_DEC",yyline,yycolumn);} 
("INC" | "inc") {return token(yytext(),"Inst_INC",yyline,yycolumn);} 
("CLR" | "clr") {return token(yytext(),"Inst_CLR",yyline,yycolumn);} 

/*b*/
"NEGB" | "negb" {return token(yytext(),"Inst_NEGB",yyline,yycolumn);}   
"COMB" | "comb" {return token(yytext(),"Inst_COMB",yyline,yycolumn);}   
"DECB"|"decb" {return token(yytext(),"Inst_DECB",yyline,yycolumn);}    
"INCB"|"incb" {return token(yytext(),"Inst_INCB",yyline,yycolumn);}     
"CLRB"|"clrb" {return token(yytext(),"Inst_CLRB",yyline,yycolumn);}    

/*Instrucciones aritmeticas de multiplicacion y division*/
"IDIV" | "idiv" {return token(yytext(),"Inst_IDIV",yyline,yycolumn);}      
"FDIV" | "fdiv" {return token(yytext(),"Inst_FDIV",yyline,yycolumn);}      
"MUL" | "mul" {return token(yytext(),"Inst_MUL",yyline,yycolumn);}      

/*Instrucciones de comparacion */
("CBA" | "cba") {return token(yytext(),"Inst_CBA",yyline,yycolumn);}      
("TSTA" | "tsta") {return token(yytext(),"Inst_TSTA",yyline,yycolumn);}    

("CMPA" | "cmpa") {return token(yytext(),"Inst_CMPA",yyline,yycolumn);} 
("BITA" | "bita") {return token(yytext(),"Inst_BITA",yyline,yycolumn);}
("CPX" | "cpx") {return token(yytext(),"Inst_CPX",yyline,yycolumn);}  
("CPY" | "cpy") {return token(yytext(),"Inst_CPY",yyline,yycolumn);}  
("CPD" | "cpd") {return token(yytext(),"Inst_CPD",yyline,yycolumn);}   

/*B*/
("TSTB" | "tstb") {return token(yytext(),"Inst_TSTB",yyline,yycolumn);}      
("CMPB" | "cmpb") {return token(yytext(),"Inst_CMPB",yyline,yycolumn);}     
("BITB" | "bitb") {return token(yytext(),"Inst_BITB",yyline,yycolumn);}  


/*Instrucciones de salto y bifurcacion*/
("BRSET" | "brset") {return token(yytext(),"Inst_BRSET",yyline,yycolumn);} 
("BRCLR" | "brclr") {return token(yytext(),"Inst_BRCLR",yyline,yycolumn);} 

/*Instrucciones de control*/
("BSET" | "bset") {return token(yytext(),"Inst_BSET",yyline,yycolumn);} 
("BCLR" | "bclr") {return token(yytext(),"Inst_BCLR",yyline,yycolumn);} 

/*Instrucciones logicas*/
/*A*/
("ORAA" | "oraa") {return token(yytext(),"Inst_ORAA",yyline,yycolumn);}   
("ANDA" | "anda") {return token(yytext(),"Inst_ANDA",yyline,yycolumn);}     
("EORA" | "eora") {return token(yytext(),"Inst_EORA",yyline,yycolumn);}     

/* B */
("ANDB" | "andb") {return token(yytext(),"Inst_ANDB",yyline,yycolumn);}    
("EORB" | "eorb") {return token(yytext(),"Inst_EORB",yyline,yycolumn);}      
("ORAB" | "orab") {return token(yytext(),"Inst_ORAB",yyline,yycolumn);}  

/*Instrucciones de rotacion y desplazamiento*/

("LSRD" | "lsrd") {return token(yytext(),"Inst_LSRD",yyline,yycolumn);}      
("ASLA" | "asla")| ("LSLA" | "lsla") {return token(yytext(),"Inst_ASLA",yyline,yycolumn);}  
("ASLD" | "asld")|("LSLD" | "lsld") {return token(yytext(),"Inst_ASLD",yyline,yycolumn);}   
("LSRA" | "lsra") {return token(yytext(),"Inst_LSRA",yyline,yycolumn);}    
("RORA" | "rora") {return token(yytext(),"Inst_RORA",yyline,yycolumn);}    
("ASRA" | "asra") {return token(yytext(),"Inst_ASRA",yyline,yycolumn);}     
("ROLA" | "rola") {return token(yytext(),"Inst_ROLA",yyline,yycolumn);}    
("LSR" | "lsr")  {return token(yytext(),"Inst_LSR",yyline,yycolumn);} 
("ASR" | "asr")  {return token(yytext(),"Inst_ASR",yyline,yycolumn);} 
("ROR" | "ror")  {return token(yytext(),"Inst_ROR",yyline,yycolumn);} 
("ROL" | "rol")  {return token(yytext(),"Inst_ROL",yyline,yycolumn);} 
("JMP" | "jmp")  {return token(yytext(),"Inst_JMP",yyline,yycolumn);} 
("ASL" | "asl")| ("LSL" | "lsl") {return token(yytext(),"Inst_ASL",yyline,yycolumn);} 

/*B*/
("LSRB" | "lsrb") {return token(yytext(),"Inst_LSRB",yyline,yycolumn);}      /* $54 */
("RORB" | "rorb") {return token(yytext(),"Inst_RORB",yyline,yycolumn);}      /* $56 */
("ASRB" | "asrb") {return token(yytext(),"Inst_ASRB",yyline,yycolumn);}      /* $57 */
("ASLB" | "aslb")| ("LSLB" | "lslb") {return token(yytext(),"Inst_ASLB",yyline,yycolumn);}      /* $58 */
("ROLB" | "rolb") {return token(yytext(),"Inst_ROLB",yyline,yycolumn);}      /* $59 */

/*Instrucciones de transferencia*/

("JSR" | "jsr") {return token(yytext(),"Inst_JSR",yyline,yycolumn);} 
("STS" | "sts") {return token(yytext(),"Inst_STS",yyline,yycolumn);} 
("STX" | "stx") {return token(yytext(),"Inst_STX",yyline,yycolumn);} 
("STY" | "sty") {return token(yytext(),"Inst_STY",yyline,yycolumn);} 

("XGDY" | "xgdy") {return token(yytext(),"Inst_XGDY",yyline,yycolumn);}     
("XGDX" | "xgdx") {return token(yytext(),"Inst_XGDX",yyline,yycolumn);}     

("PSHX" | "pshx") {return token(yytext(),"Inst_PSHX",yyline,yycolumn);}     
("PULX" | "pulx") {return token(yytext(),"Inst_PULX",yyline,yycolumn);}     
("PULY" | "puly") {return token(yytext(),"Inst_PULY",yyline,yycolumn);}     
("PSHY" | "pshy") {return token(yytext(),"Inst_PSHY",yyline,yycolumn);}      
("TSX" | "tsx") {return token(yytext(),"Inst_TSX",yyline,yycolumn);}     
("TXS" | "txs") {return token(yytext(),"Inst_TXS",yyline,yycolumn);}      

("LDS" | "lds") {return token(yytext(),"Inst_LDS",yyline,yycolumn);}  /* $8E */ 
("LDX" | "ldx") {return token(yytext(),"Inst_LDX",yyline,yycolumn);}  /* $CE */ 
("LDY" | "ldy") {return token(yytext(),"Inst_LDY",yyline,yycolumn);}  /* $18 CE */ 
("LDD" | "ldd") {return token(yytext(),"Inst_LDD",yyline,yycolumn);}  /* $CC */ 
("STD" | "std") {return token(yytext(),"Inst_STD",yyline,yycolumn);} /* $DD */


/*A*/
("TAP" | "tap") {return token(yytext(),"Inst_TAP",yyline,yycolumn);}      /* $06 */
("TPA" | "tpa") {return token(yytext(),"Inst_TPA",yyline,yycolumn);}      /* $07 */
("TAB" | "tab") {return token(yytext(),"Inst_TAB",yyline,yycolumn);}      /* $16 */
("PULA" | "pula") {return token(yytext(),"Inst_PULA",yyline,yycolumn);}      /* $32 */
("PSHA" | "psha") {return token(yytext(),"Inst_PSHA",yyline,yycolumn);}      /* $36 */

("LDAA" | "ldaa") {return token(yytext(),"Inst_LDAA",yyline,yycolumn);} /* $96 */
("STAA" | "staa") {return token(yytext(),"Inst_STAA",yyline,yycolumn);} /* $97 */

/*B*/
("TBA" | "tba") {return token(yytext(),"Inst_TBA",yyline,yycolumn);}      /* $17 */
("PULB" | "pulb") {return token(yytext(),"Inst_PULB",yyline,yycolumn);}      /* $33 */
("PSHB" | "pshb") {return token(yytext(),"Inst_PSHB",yyline,yycolumn);}      /* $37 */
("LDAB" | "ldab") {return token(yytext(),"Inst_LDAB",yyline,yycolumn);} /* $D6 */
("STAB" | "stab") {return token(yytext(),"Inst_STAB",yyline,yycolumn);} /* $D7 */

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
("CLR" | "clr") {return token(yytext(),"Inst_CLR",yyline,yycolumn);} /*$6F */ /*18 6F*/
("TST" | "tst") {return token(yytext(),"Inst_TST",yyline,yycolumn);} /* $6D */
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

{Identificador} { return token(yytext(), "IDENTIFICADOR", yyline, yycolumn); }
