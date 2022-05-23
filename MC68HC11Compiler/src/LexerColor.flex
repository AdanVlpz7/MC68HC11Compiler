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

("SUBA" | "suba") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $80 */
("SBCA" | "sbca") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $82 */
("SUBD" | "subd") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $83 */
("ADCA" | "adca") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }    /* $89 */
("ADDA" | "adda") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $8B */
("ADDD" | "addd") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $C3 */

/* B */
("SUBB" | "subb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }        /* $C0 */
("SBCB" | "sbcb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $C2 */
("ADCB" | "adcb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $C9 */
("ADDB" | "addb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $CB */


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

("NEG" | "neg") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $60 */
("COM" | "com") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $63 */
("DEC" | "dec") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $6A */
("INC" | "inc") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $6C */
("CLR" | "clr") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $6F */


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

("CMPA" | "cmpa") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $81 */
("BITA" | "bita") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $85 */
("CPX" | "cpx") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $8C */
("CPY" | "cpy") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $18 8C */
("CPD" | "cpd") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }         /* $1A 83 */

/*B*/
("TSTB" | "tstb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $5D */

("CMPB" | "cmpb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $C1 */
("BITB" | "bitb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $C5 */

/*Instrucciones de salto y bifurcacion*/
("BRSET" | "brset") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $12 */
("BRCLR" | "brclr") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $13 */

/*Instrucciones de control*/
("BSET" | "bset") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $14 */
("BCLR" | "bclr") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $16 */

/*Instrucciones logicas*/
/*A*/
("ORAA" | "oraa") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $8A */
("ANDA" | "anda") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $84 */
("EORA" | "eora") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $88 */

/* B */
("ANDB" | "andb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $C4 */
("EORB" | "eorb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $C8 */
("ORAB" | "orab") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $CA */

/*Instrucciones de rotacion y desplazamiento*/

("LSRD" | "lsrd") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $04 */
("ASLD" | "asld")|("LSLD" | "lsld") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $05 */
("LSRA" | "lsra") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $44 */
("RORA" | "rora") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $46 */
("ASRA" | "asra") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $47 */
("ASLA" | "asla")| ("LSLA" | "lsla") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $48 */
("ROLA" | "rola") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $49 */
("LSR" | "lsr") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $64 */ /*18 64*/
("ASR" | "asr") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $A7 */
("ROR" | "ror") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $66 */ /*18 66*/
("ROL" | "rol") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $69 */ /*18 69*/
("JMP" | "jmp") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $6E */ /*18 6E*/
("ASL" | "asl")| ("LSL" | "lsl") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $A8 */

/*B*/
("LSRB" | "lsrb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $54 */
("RORB" | "rorb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $56 */
("ASRB" | "asrb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $57 */
("ASLB" | "aslb")| ("LSLB" | "lslb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $58 */
("ROLB" | "rolb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $59 */

/*Instrucciones de transferencia*/

("JSR" | "jsr") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $9D */
("STS" | "sts") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $9F */
("STX" | "stx") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $DF */
("STY" | "sty") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $18 DF */
("LDX" | "ldx") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $EE */ /*CD EE*/

("XGDY" | "xgdy") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $18 8F */
("XGDX" | "xgdx") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $8F */

("PSHX" | "pshx") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $3C */
("PULX" | "pulx") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $38 */
("PULY" | "puly") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $18 38 */
("PSHY" | "pshy") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $18 3C */
("TSX" | "tsx") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $30 */
("TXS" | "txs") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $35 */

("LDS" | "lds") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }  /* $8E */ 
("LDY" | "ldy") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }  /* $18 CE */ 
("LDD" | "ldd") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }  /* $CC */ 
("STD" | "std") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }/* $DD */

/*A*/
("TAP" | "tap") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $06 */
("TPA" | "tpa") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $07 */
("TAB" | "tab") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $16 */
("PULA" | "pula") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $32 */
("PSHA" | "psha") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $36 */
("LDAA" | "ldaa") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }  /* $86 */ 
("STAA" | "staa") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $97 */

/*B*/
("TBA" | "tba") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $17 */
("PULB" | "pulb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $33 */
("PSHB" | "pshb") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }      /* $37 */
("LDAB" | "ldab") { return textColor(yychar, yylength(), new Color(255, 87, 51)); }  /* $C6 */
("STAB" | "stab") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $D7 */

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
("CLR" | "clr") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /*$6F */ /*18 6F*/
("TST" | "tst") { return textColor(yychar, yylength(), new Color(255, 87, 51)); } /* $6D */
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
