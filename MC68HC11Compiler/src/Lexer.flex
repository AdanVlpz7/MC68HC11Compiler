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
("ORG" | "org") {return token(yytext(),"INICIO",yyline,yycolumn);}

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
