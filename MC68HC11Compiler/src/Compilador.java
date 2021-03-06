import com.formdev.flatlaf.FlatIntelliJLaf;
import compilerTools.CodeBlock;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;
import compilerTools.Directory;
import compilerTools.ErrorLSSL;
import compilerTools.Functions;
import compilerTools.Grammar;
import compilerTools.Production;
import compilerTools.TextColor;
import compilerTools.Token;
import java.awt.Color;
import java.awt.event.ActionEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JOptionPane;
import javax.swing.Timer;
/**
 *
 * @author adan_
 */
public class Compilador extends javax.swing.JFrame {
    private String title; // titulo del compilador
    private Directory Directorio; 
    private ArrayList<Token> tokens; //lista donde se guardaran los tokens
    private ArrayList<ErrorLSSL> errores; //lista para guardar todo tipo de errores posobles
    private ArrayList<TextColor> textsColor; //lista de colores para palabras reservadas
    private Timer timerKeyReleased; //para ejecutar una función que coloreara las palabras
    private ArrayList<Production> identProd; //para extraer los identificadores en el analisis sintatico
    private HashMap<String, String> identificadores; //donde guardaremos los identificadores
    private boolean codeHasBeenCompiled = false;

    public Compilador() {
        initComponents();
        init();
    }
    
    private void init(){
        title = "Compilador para MC68HC11";
        setLocationRelativeTo(null); //para centrar ventana
        setTitle(title);
        Directorio = new Directory(this, jtpCode, title, ".asc");
        addWindowListener(new WindowAdapter(){
            @Override
            //para preguntar si se quiere guardar el codigo
            public void windowClosing(WindowEvent e){
                Directorio.Exit();
                System.exit(0);
            }
        });
        Functions.setLineNumberOnJTextComponent(jtpCode); //Pone los numeros de linea
        timerKeyReleased = new Timer((int) (1000 * 0.3), (ActionEvent e) -> {
            timerKeyReleased.stop();
            
            int posicion = jtpCode.getCaretPosition();
            jtpCode.setText(jtpCode.getText().replaceAll("[\r]+", ""));
            jtpCode.setCaretPosition(posicion);
            
            colorAnalysis();
            
        });
        Functions.insertAsteriskInName(this, jtpCode, ()->{
            timerKeyReleased.restart(); //para poner un asteristico cuando se edite
        });
        tokens = new ArrayList<>();
        errores = new ArrayList<>();
        textsColor = new ArrayList<>();
        identProd = new ArrayList<>();
   
        identificadores = new HashMap<>();
        //autocompletar algunas palabras
        //funciona con CTRL+SPACE
        Functions.setAutocompleterJTextComponent(new String[]{"ORG","org","EQU","equ","END","end","EQU","FCB","fcb",
        "SBA","sba","ABA","aba","ABY","aby","ABX","abx","SUBA","suba","SBCA","SBCA","sbca","SUBD","subd","ADCA",
        "adca","ADDA","adda","ADDD","addd","SUBB","subb","SBCB","sbcb","ADCB","adcb","ADDB","addb","INX","inx","DEX",
        "dex","INY","iny","DEY","dey","DAA","daa","INS","ins","DES","des","NEGA","nega","COMA","coma","DECA","deca",
        "INCA","inca","CLRA","clra","NEG","neg","COM","com","DEC","dec","INC","inc","CLR","clr","NEGB","negb","COMP",
        "comb","DECB","decb","INCB","incb","CLRB","clrb","IDIV","idiv","FDIV","fdiv","MUL","mul","CBA","cba","TSTA",
        "tsta","CMPA","cmpa","BITA","bita","CPX","cpx","CPY","cpy","CPD","cpd","TSTB","tstb","CMPB","cmpb","BITB","bitb",
        "BRSET","brset","BRCLR","brclr","BSET","bset","BCLR","bclr","ORAA","oraa","ANDA","anda","EORA","eora","ANDB","andb",
        "EORB","eorb","ORAB","orab","LSRD","lsrd","ASLD","asld","LSRA","lsra","RORA","rora","ASRA","asra","ASLA","asla",
        "ROLA","rola","LSR","lsr","ASR","asr","ROR","ror","ROL","rol","JMP","jmp","ASL","asl","LSL","lsl","LSRB","lsrb",
        "RORB","rorb","ASRB","asrb","ASLB","aslb","ROLB","rolb","JSR","jsr","STS","sts","STX","stx","STY","sty","LDX","ldx",
        "XGDY","xgdy","XGDX","xgdx","PSHX","pshx","PULX","pulx","PULY","puly","PSHY","pshy","TSX","tsx","TXS","txs","LDS","lds",
        "LDY","ldy","LDD","ldd","STD","std","TAP","tap","TPA","tpa","TAB","tab","PULA","pula","PSHA","psha","LDAA","ldaa","STAA",
        "staa","TBA","tba","PULB","pulb","PSHB","pshb","LDAB","ldab","STAB","stab","TEST","test","NOP","nop","CLV","clv",
        "SEV","sev","CLC","clc","SEC","sec","CLI","cli","SEI","sei","STOP","stop","CLR","clr","TST","tst","BRA","bra",
        "BRN","brn","BHI","bhi","BLS","bls","BCC","bcc","BHS","bhs","BCS","bcs","BLO","blo","BNE","bne",
        "BEQ","beq","BVC","bvc","BVS","bvs","BPL","bpl","BMI","bmi","BGE","bge","BLT","blt","BGT","bgt","BLE","ble",
        "BSR","bsr","RTS","rts","RTI","rti","WAI","wai","SWI","swi"}, jtpCode, ()->{
            timerKeyReleased.restart();
        });
        
    }
    
    private void colorAnalysis(){
        textsColor.clear();
        LexerColor lexer;
        try {
            
            File codigo = new File("color.encrypto");
            FileOutputStream output = new FileOutputStream(codigo);
            byte[] bytesText = jtpCode.getText().getBytes();
            output.write(bytesText);
            BufferedReader entrada = new BufferedReader(new InputStreamReader(new FileInputStream(codigo),"UTF-8"));
            lexer = new LexerColor(entrada);
            while(true){
                TextColor textColor = lexer.yylex();
                if(textColor == null){
                    break;
                }
                textsColor.add(textColor);
            }
        } catch (FileNotFoundException ex) {
            Logger.getLogger(Compilador.class.getName()).log(Level.SEVERE, null, ex);
        }
        catch(IOException ex){
            Logger.getLogger(Compilador.class.getName()).log(Level.SEVERE, null, ex);
        }
        Functions.colorTextPane(textsColor,jtpCode,new Color(40,40,40));
    }
    private void clearFields(){
        Functions.clearDataInTable(tblTokens);
        jtaOutputConsole.setText("");
        tokens.clear();
        errores.clear();
        identProd.clear();
        identificadores.clear();
        codeHasBeenCompiled = false;
    }
    
    private void compile(){
        clearFields();
        lexicalAnalysis();
        fillTableTokens();
        syntaticAnalysis();
        semanticAnalysis();
        printConsole();
        codeHasBeenCompiled = true;
    }
    
    private void lexicalAnalysis(){
        Lexer lexer;
        try {
            
            File codigo = new File("code.encrypto");
            FileOutputStream output = new FileOutputStream(codigo);
            byte[] bytesText = jtpCode.getText().getBytes();
            output.write(bytesText);
            BufferedReader entrada = new BufferedReader(new InputStreamReader(new FileInputStream(codigo),"UTF-8"));
            lexer = new Lexer(entrada);
            while(true){
                Token token = lexer.yylex();
                if(token == null){
                    break;
                }
                tokens.add(token);
            }
        } catch (FileNotFoundException ex) {
            Logger.getLogger(Compilador.class.getName()).log(Level.SEVERE, null, ex);
        }
        catch(IOException ex){
            Logger.getLogger(Compilador.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }
    
    private void fillTableTokens(){
        tokens.forEach(token ->{
            Object[] data = new Object[]{token.getLexicalComp(), token.getLexeme(), "["+token.getLine()+","+token.getColumn()+"]"};
            Functions.addRowDataInTable(tblTokens, data);
        
        });
    }
    
    private void syntaticAnalysis(){
        Grammar gramatica = new Grammar(tokens,errores);
        /*ELIMINACION DE ERRORES*/
        gramatica.delete(new String[]{"Error","Error1","Error2","Error3","Error4","Error5","Error6","Error7","Error8","Error9"},1);
        
        gramatica.group("Variable","IDENTIFICADOR TAB Directiva_EQU TAB DirEXT");
        gramatica.group("Variable","Directiva_EQU TAB DirEXT",true,2,
                "error sintatico: falta el identificador en la variable [#,%]");
        gramatica.finalLineColumn();
        gramatica.group("Variable","IDENTIFICADOR Directiva_EQU",true,2,
                "error sintatico: falta el valor asignado a la variable [#,%]");
        gramatica.initialLineColumn();
        gramatica.delete("Directiva_EQU",4,
                "Error sintatico{}: La directiva EQU no fue establecida en la declaracion");
        gramatica.group("DirEXT","IDENTIFICADOR",true);
        
        gramatica.group("Funcion","IDENTIFICADOR TAB",true);
        
        gramatica.group("INSTRUCCIONES_INHERENTES","TAB (Inst_TEST|Inst_NOP|Inst_IDIV|Inst_FDIV|Inst_LSRD|Inst_ASLD|Inst_TAP|Inst_TPA|Inst_INX|Inst_DEX|Inst_CLV|Inst_SEV|Inst_CLC|Inst_SEC"+
            "Inst_CLI|Inst_SEI|Inst_SBA|Inst_CBA|Inst_TAB|Inst_TBA|Inst_INY|Inst_DEY|Inst_TSY|Inst_TYS|Inst_PULY|Inst_ABY|Inst_PSHY|Inst_XGDY|Inst_DAA|Inst_ABA|Inst_BRA|Inst_BRN|Inst_BHI"+
            "Inst_BLS|Inst_BCC|Inst_BCS|Inst_BNE|Inst_BEQ|Inst_BVQ|Inst_BVS|Inst_BPL|Inst_BMI|Inst_BGE|Inst_BLT|Inst_BGT|Inst_BLE|Inst_TSX|Inst_INS|Inst_PULA|Inst_PULB|Inst_DES|Inst_TXS|Inst_PSHA"+
            "Inst_PSHB|Inst_PULX|Inst_RTS|Inst_ABX|Inst_RTI|Inst_PSHX|Inst_MUL|Inst_WAI|Inst_SWI|Inst_NEGA|Inst_COMA|Inst_LSRA|Inst_RORA|Inst_ASRA|Inst_ASLA|Inst_ROLA|Inst_DECA|Inst_INCA|Inst_TSTA|Inst_CLRA|Inst_NEGB|Inst_COMB|Inst_LSRB|Inst_RORB"+
            "Inst_ASRB|Inst_ASLB|Inst_ROLB|Inst_DECB|Inst_INCB|Inst_TSTB|Inst_CLRB|Inst_BSR|Inst_XGDX|Inst_STOP)",true);        
        gramatica.group("INSTRUCCIONES_INHERENTES_ERR6","TAB (Inst_TEST|Inst_NOP|Inst_IDIV|Inst_FDIV|Inst_LSRD|Inst_ASLD|Inst_TAP|Inst_TPA|Inst_INX|Inst_DEX|Inst_CLV|Inst_SEV|Inst_CLC|Inst_SEC"+
            "Inst_CLI|Inst_SEI|Inst_SBA|Inst_CBA|Inst_TAB|Inst_TBA|Inst_INY|Inst_DEY|Inst_TSY|Inst_TYS|Inst_PULY|Inst_ABY|Inst_PSHY|Inst_XGDY|Inst_DAA|Inst_ABA|Inst_BRA|Inst_BRN|Inst_BHI"+
            "Inst_BLS|Inst_BCC|Inst_BCS|Inst_BNE|Inst_BEQ|Inst_BVQ|Inst_BVS|Inst_BPL|Inst_BMI|Inst_BGE|Inst_BLT|Inst_BGT|Inst_BLE|Inst_TSX|Inst_INS|Inst_PULA|Inst_PULB|Inst_DES|Inst_TXS|Inst_PSHA"+
            "Inst_PSHB|Inst_PULX|Inst_RTS|Inst_ABX|Inst_RTI|Inst_PSHX|Inst_MUL|Inst_WAI|Inst_SWI|Inst_NEGA|Inst_COMA|Inst_LSRA|Inst_RORA|Inst_ASRA|Inst_ASLA|Inst_ROLA|Inst_DECA|Inst_INCA|Inst_TSTA|Inst_CLRA|Inst_NEGB|Inst_COMB|Inst_LSRB|Inst_RORB"+
            "Inst_ASRB|Inst_ASLB|Inst_ROLB|Inst_DECB|Inst_INCB|Inst_TSTB|Inst_CLRB|Inst_BSR|Inst_XGDX|Inst_STOP) DirEXT|DirSimple" ,true,6,
                "error sintatico (006) : esta instruccion no lleva operandos [#,%]");
        gramatica.group("INSTRUCCIONES_INHERENTES_ERR9"," (Inst_TEST|Inst_NOP|Inst_IDIV|Inst_FDIV|Inst_LSRD|Inst_ASLD|Inst_TAP|Inst_TPA|Inst_INX|Inst_DEX|Inst_CLV|Inst_SEV|Inst_CLC|Inst_SEC"+
            "Inst_CLI|Inst_SEI|Inst_SBA|Inst_CBA|Inst_TAB|Inst_TBA|Inst_INY|Inst_DEY|Inst_TSY|Inst_TYS|Inst_PULY|Inst_ABY|Inst_PSHY|Inst_XGDY|Inst_DAA|Inst_ABA|Inst_BRA|Inst_BRN|Inst_BHI"+
            "Inst_BLS|Inst_BCC|Inst_BCS|Inst_BNE|Inst_BEQ|Inst_BVQ|Inst_BVS|Inst_BPL|Inst_BMI|Inst_BGE|Inst_BLT|Inst_BGT|Inst_BLE|Inst_TSX|Inst_INS|Inst_PULA|Inst_PULB|Inst_DES|Inst_TXS|Inst_PSHA"+
            "Inst_PSHB|Inst_PULX|Inst_RTS|Inst_ABX|Inst_RTI|Inst_PSHX|Inst_MUL|Inst_WAI|Inst_SWI|Inst_NEGA|Inst_COMA|Inst_LSRA|Inst_RORA|Inst_ASRA|Inst_ASLA|Inst_ROLA|Inst_DECA|Inst_INCA|Inst_TSTA|Inst_CLRA|Inst_NEGB|Inst_COMB|Inst_LSRB|Inst_RORB"+
            "Inst_ASRB|Inst_ASLB|Inst_ROLB|Inst_DECB|Inst_INCB|Inst_TSTB|Inst_CLRB|Inst_BSR|Inst_XGDX|Inst_STOP)",true,9,
                "error sintatico (009) : INSTRUCCIÓN CARECE DE ALMENOS UN ESPACIO RELATIVO AL MARGEN [#,%]");
        
        /* INSTRUCCIONES INMEDIATAS */
        gramatica.group("INSTRUCCIONES_INMEDIATAS","TAB (Inst_SUBA|Inst_SBCA|Inst_SUBD|Inst_ADDA|Inst_ADDD|Inst_SUBB|Inst_CPY|Inst_CPD|Inst_CMPB|Inst_BITB|Inst_CMPA|"+
            "Inst_BITA|Inst_ANDA|Inst_EORA|Inst_ANDB|Inst_EORB|Inst_ORAB|Inst_ORAA|Inst_LDX|Inst_LDY|Inst_LDD|Inst_LDAA|Inst_LDAB) TAB GATO DirEXT|DirSimple",true);
        
        gramatica.group("INSTRUCCIONES_INMEDIATAS_ERR6","TAB (Inst_SUBA|Inst_SBCA|Inst_SUBD|Inst_ADDA|Inst_ADDD|Inst_SUBB|Inst_CPY|Inst_CPD|Inst_CMPB|Inst_BITB|Inst_CMPA|"+
            "Inst_BITA|Inst_ANDA|Inst_EORA|Inst_ANDB|Inst_EORB|Inst_ORAB|Inst_ORAA|Inst_LDX|Inst_LDY|Inst_LDD|Inst_LDAA|Inst_LDAB) TAB GATO",true,6,
            "error sintatico (006) : Instruccion carece de comandos [#,%]");
        
        gramatica.group("INSTRUCCIONES_INMEDIATAS_ERR9"," (Inst_SUBA|Inst_SBCA|Inst_SUBD|Inst_ADDA|Inst_ADDD|Inst_SUBB|Inst_CPY|Inst_CPD|Inst_CMPB|Inst_BITB|Inst_CMPA|"+
            "Inst_BITA|Inst_ANDA|Inst_EORA|Inst_ANDB|Inst_EORB|Inst_ORAB|Inst_ORAA|Inst_LDX|Inst_LDY|Inst_LDD|Inst_LDAA|Inst_LDAB) TAB GATO DirExt|DirSimple",true,9,
            "error sintatico (009) : INSTRUCCIÓN CARECE DE ALMENOS UN ESPACIO RELATIVO AL MARGEN [#,%]");
                
        gramatica.group("INSTRUCCIONES_INMEDIATAS_ERR11","TAB (Inst_SUBA|Inst_SBCA|Inst_SUBD|Inst_ADDA|Inst_ADDD|Inst_SUBB|Inst_CPY|Inst_CPD|Inst_CMPB|Inst_BITB|Inst_CMPA|"+
            "Inst_BITA|Inst_ANDA|Inst_EORA|Inst_ANDB|Inst_EORB|Inst_ORAB|Inst_ORAA|Inst_LDX|Inst_LDY|Inst_LDD|Inst_LDAA|Inst_LDAB) GATO DirEXT|DirSimple",true,11,
            "error sintatico (011) : esta instruccion requiere un espacio considerable entre el nombre de la instruccion y sus operandos (TAB) [#,%]");
        
        /* INSTRUCCIONES DIRECTAS */        
        gramatica.group("INSTRUCCIONES_DIRECTAS","TAB (INST_BRSET|INST_BRCLR|INST_BSET|INST_BCLR|INST_LDY|INST_STY|INST_CPD|INST_SUBA|INST_CMPA|INST_SBCA|INST_SUBD|INST_ANDA|INST_BITA|INST_LDAA|"+
            "INST_STAA|INST_EORA|INST_ADCA|INST_ORAA|INST_ADDA|INST_CPX|INST_JSR|INST_LDS|INST_STS|INST_SUBB|INST_CMPB|INST_SBCB|INST_ANDB|INST_BITB|INST_LDAB|"+
            "INST_STAB|INST_EORB|INST_ADCB|INST_ORAB|INST_ADDB|INST_LDD|INST_STD|INST_LDX|INST_STX)TAB DirSimple ",true);
        gramatica.group("INSTRUCCIONES_DIRECTAS_ERR5","TAB (INST_BRSET|INST_BRCLR|INST_BSET|INST_BCLR|INST_LDY|INST_STY|INST_CPD|INST_SUBA|INST_CMPA|INST_SBCA|INST_SUBD|INST_ANDA|INST_BITA|INST_LDAA|"+
            "INST_STAA|INST_EORA|INST_ADCA|INST_ORAA|INST_ADDA|INST_CPX|INST_JSR|INST_LDS|INST_STS|INST_SUBB|INST_CMPB|INST_SBCB|INST_ANDB|INST_BITB|INST_LDAB|"+
            "INST_STAB|INST_EORB|INST_ADCB|INST_ORAB|INST_ADDB|INST_LDD|INST_STD|INST_LDX|INST_STX)TAB ",true,5,
            "error sintatico (005) : Instruccion carece de comandos [#,%]");
        gramatica.group("INSTRUCCIONES_DIRECTAS_ERR7","TAB (INST_BRSET|INST_BRCLR|INST_BSET|INST_BCLR)TAB DirEXT ",true,7,
            "error sintatico (007) : Magnitud de operando erronea [#,%]");
        gramatica.group("INSTRUCCIONES_DIRECTAS_ERR9"," (INST_BRSET|INST_BRCLR|INST_BSET|INST_BCLR|INST_LDY|INST_STY|INST_CPD|INST_SUBA|INST_CMPA|INST_SBCA|INST_SUBD|INST_ANDA|INST_BITA|INST_LDAA|"+
            "INST_STAA|INST_EORA|INST_ADCA|INST_ORAA|INST_ADDA|INST_CPX|INST_JSR|INST_LDS|INST_STS|INST_SUBB|INST_CMPB|INST_SBCB|INST_ANDB|INST_BITB|INST_LDAB|"+
            "INST_STAB|INST_EORB|INST_ADCB|INST_ORAB|INST_ADDB|INST_LDD|INST_STD|INST_LDX|INST_STX)TAB DirSimple ",true,9,
            "error sintatico (009) : INSTRUCCIÓN CARECE DE ALMENOS UN ESPACIO RELATIVO AL MARGEN [#,%]");
        gramatica.group("INSTRUCCIONES_DIRECTAS_ERR11","TAB (INST_BRSET|INST_BRCLR|INST_BSET|INST_BCLR|INST_LDY|INST_STY|INST_CPD|INST_SUBA|INST_CMPA|INST_SBCA|INST_SUBD|INST_ANDA|INST_BITA|INST_LDAA|"+
            "INST_STAA|INST_EORA|INST_ADCA|INST_ORAA|INST_ADDA|INST_CPX|INST_JSR|INST_LDS|INST_STS|INST_SUBB|INST_CMPB|INST_SBCB|INST_ANDB|INST_BITB|INST_LDAB|"+
            "INST_STAB|INST_EORB|INST_ADCB|INST_ORAB|INST_ADDB|INST_LDD|INST_STD|INST_LDX|INST_STX)TAB DirSimple",true,11,
            "error sintatico (011) : esta instruccion requiere un espacio considerable entre el nombre de la instruccion y sus operandos(TAB) [#,%]");
        
        /* INSTRUCCIONES INDEX */
        gramatica.group("INSTRUCCIONES_INDEX","TAB (INST_CPD|INST_CPY|INST_LDY|INST_STY|INST_BSET|INST_BCLR|INST_BRSET|INST_BRCLR|INST_NEG|INST_COM|INST_LSR|INST_ROR|INST_ASR|INST_ASL|INST_ROL|INST_DEC|INST_INC|INST_TST|INST_JMP|INST_CLR|"+
            "INST_SUBA|INST_CMPA|INST_SBCA|INST_SUBD|INST_ANDA|INST_BITA|INST_LDAA"+
            "INST_STAA|INST_EORA|INST_ADCA|INST_ORAA|INST_ADDA|INST_CPX|INST_JSR|INST_LDS|INST_STS|INST_SUBB|INST_CMPB|INST_SBCB|INST_ANDB|INST_BITB|INST_LDAB|"+
            "INST_STAB|INST_EORB|INST_ADCB|INST_ORAB|INST_ADDB|INST_LDD|INST_STD|INST_LDX|INST_STX|INST_STY|INST_LDY) TAB DirSimple TAB COMA ('X'|'x'|'Y'|'y')",true);
        gramatica.group("INSTRUCCIONES_INDEX_ERR5","TAB (INST_CPD|INST_CPY|INST_LDY|INST_STY|INST_BSET|INST_BCLR|INST_BRSET|INST_BRCLR|INST_NEG|INST_COM|INST_LSR|INST_ROR|INST_ASR|INST_ASL|INST_ROL|INST_DEC|INST_INC|INST_TST|INST_JMP|INST_CLR|"+
            "INST_SUBA|INST_CMPA|INST_SBCA|INST_SUBD|INST_ANDA|INST_BITA|INST_LDAA"+
            "INST_STAA|INST_EORA|INST_ADCA|INST_ORAA|INST_ADDA|INST_CPX|INST_JSR|INST_LDS|INST_STS|INST_SUBB|INST_CMPB|INST_SBCB|INST_ANDB|INST_BITB|INST_LDAB|"+
            "INST_STAB|INST_EORB|INST_ADCB|INST_ORAB|INST_ADDB|INST_LDD|INST_STD|INST_LDX|INST_STX|INST_STY|INST_LDY) ((TAB DirSimple TAB COMA)|(TAB COMA ('X'|'x'|'Y'|'y')))",true,5,
            "error sintatico (005) : Instruccion carece de comandos [#,%]");
        gramatica.group("INSTRUCCIONES_INDEX_ERR9"," (INST_CPD|INST_CPY|INST_LDY|INST_STY|INST_BSET|INST_BCLR|INST_BRSET|INST_BRCLR|INST_NEG|INST_COM|INST_LSR|INST_ROR|INST_ASR|INST_ASL|INST_ROL|INST_DEC|INST_INC|INST_TST|INST_JMP|INST_CLR|"+
            "INST_SUBA|INST_CMPA|INST_SBCA|INST_SUBD|INST_ANDA|INST_BITA|INST_LDAA"+
            "INST_STAA|INST_EORA|INST_ADCA|INST_ORAA|INST_ADDA|INST_CPX|INST_JSR|INST_LDS|INST_STS|INST_SUBB|INST_CMPB|INST_SBCB|INST_ANDB|INST_BITB|INST_LDAB|"+
            "INST_STAB|INST_EORB|INST_ADCB|INST_ORAB|INST_ADDB|INST_LDD|INST_STD|INST_LDX|INST_STX|INST_STY|INST_LDY) TAB DirSimple TAB COMA ('X'|'x'|'Y'|'y')",true,9,
             "error sintatico (009) : INSTRUCCIÓN CARECE DE ALMENOS UN ESPACIO RELATIVO AL MARGEN [#,%]");
        gramatica.group("INSTRUCCIONES_INDEX_ERR11"," TAB (INST_CPD|INST_CPY|INST_LDY|INST_STY|INST_BSET|INST_BCLR|INST_BRSET|INST_BRCLR|INST_NEG|INST_COM|INST_LSR|INST_ROR|INST_ASR|INST_ASL|INST_ROL|INST_DEC|INST_INC|INST_TST|INST_JMP|INST_CLR|"+
            "INST_SUBA|INST_CMPA|INST_SBCA|INST_SUBD|INST_ANDA|INST_BITA|INST_LDAA"+
            "INST_STAA|INST_EORA|INST_ADCA|INST_ORAA|INST_ADDA|INST_CPX|INST_JSR|INST_LDS|INST_STS|INST_SUBB|INST_CMPB|INST_SBCB|INST_ANDB|INST_BITB|INST_LDAB|"+
            "INST_STAB|INST_EORB|INST_ADCB|INST_ORAB|INST_ADDB|INST_LDD|INST_STD|INST_LDX|INST_STX|INST_STY|INST_LDY) DirSimple TAB COMA ('X'|'x'|'Y'|'y')",true,11,
            "error sintatico (011) : esta instruccion requiere un espacio considerable entre el nombre de la instruccion y sus operandos(TAB) [#,%]");

        
        /* INSTRUCCIONES EXT */
        gramatica.group("INSTRUCCIONES_EXT","TAB (INST_CPY|INST_LDY|INST_NEG|INST_COM|INST_LSR|INST_ROR|INST_ASR|INST_ASL|INST_ROL|INST_DEC|INST_INC|INST_TST|INST_JMP|INST_CLR|INST_STY|INST_CPD|INST_SUBA|INST_CMPA|INST_SBCA|INST_SUBD|INST_ANDA|INST_BITA|INST_LDAA|"+
            "INST_STAA|INST_EORA|INST_ADCA|INST_ORAA|INST_ADDA|INST_CPX|INST_JSR|INST_LDS|INST_STS| INST_SUBB|INST_CMPB|INST_SBCB|INST_ANDB|INST_BITB|INST_LDAB|"+
            "INST_STAB|INST_EORB|INST_ADCB|INST_ORAB|INST_ADDB|INST_LDD|INST_STD|INST_LDX|INST_STX)TAB DirEXT ",true);        
        gramatica.group("INSTRUCCIONES_EXT_ERR5","TAB (INST_CPY|INST_LDY|INST_STY|INST_CPD|INST_SUBA|INST_CMPA|INST_SBCA|INST_SUBD|INST_ANDA|INST_BITA|INST_LDAA|"+
            "INST_STAA|INST_EORA|INST_ADCA|INST_ORAA|INST_ADDA|INST_CPX|INST_JSR|INST_LDS|INST_STS| INST_SUBB|INST_CMPB|INST_SBCB|INST_ANDB|INST_BITB|INST_LDAB|"+
            "INST_STAB|INST_EORB|INST_ADCB|INST_ORAB|INST_ADDB|INST_LDD|INST_STD|INST_LDX|INST_STX)TAB ",true,5,
            "error sintatico (005) : Instruccion carece de comandos [#,%]");    
        gramatica.group("INSTRUCCIONES_EXT_ERR7","TAB (INST_NEG|INST_COM|INST_LSR|INST_ROR|INST_ASR|INST_ASL|INST_ROL|INST_DEC|INST_INC|INST_TST|INST_JMP|INST_CLR)TAB DirSimple ",true,11,
                "error sintatico (007) : Magnitud de operando erronea [#,%]");
        gramatica.group("INSTRUCCIONES_EXT_ERR9","(INST_CPY|INST_LDY|INST_NEG|INST_COM|INST_LSR|INST_ROR|INST_ASR|INST_ASL|INST_ROL|INST_DEC|INST_INC|INST_TST|INST_JMP|INST_CLR|INST_STY|INST_CPD|INST_SUBA|INST_CMPA|INST_SBCA|INST_SUBD|INST_ANDA|INST_BITA|INST_LDAA|"+
            "INST_STAA|INST_EORA|INST_ADCA|INST_ORAA|INST_ADDA|INST_CPX|INST_JSR|INST_LDS|INST_STS| INST_SUBB|INST_CMPB|INST_SBCB|INST_ANDB|INST_BITB|INST_LDAB|"+
            "INST_STAB|INST_EORB|INST_ADCB|INST_ORAB|INST_ADDB|INST_LDD|INST_STD|INST_LDX|INST_STX)TAB DirEXT ",true,9,
            "error sintatico (009) : INSTRUCCIÓN CARECE DE ALMENOS UN ESPACIO RELATIVO AL MARGEN [#,%]");                        
        gramatica.group("INSTRUCCIONES_EXT_ERR11","TAB (INST_CPY|INST_LDY|INST_STY|INST_CPD|INST_SUBA|INST_CMPA|INST_SBCA|INST_SUBD|INST_ANDA|INST_BITA|INST_LDAA|"+
            "INST_STAA|INST_EORA|INST_ADCA|INST_ORAA|INST_ADDA|INST_CPX|INST_JSR|INST_LDS|INST_STS| INST_SUBB|INST_CMPB|INST_SBCB|INST_ANDB|INST_BITB|INST_LDAB|"+
            "INST_STAB|INST_EORB|INST_ADCB|INST_ORAB|INST_ADDB|INST_LDD|INST_STD|INST_LDX|INST_STX) DirEXT ",true,11,
            "error sintatico (011) : esta instruccion requiere un espacio considerable entre el nombre de la instruccion y sus operandos(TAB) [#,%]");
 
        gramatica.show();
    }
    
    private void semanticAnalysis(){
        
    }
    
    private void printConsole(){
        int sizeErrors = errores.size();
        if(sizeErrors > 0){
            Functions.sortErrorsByLineAndColumn(errores);
            String strErrors = "\n";
            for(ErrorLSSL error: errores){
                String strError = String.valueOf(error);
                strErrors += strError + "\n";
            }
            jtaOutputConsole.setText("Compilacion terminada .... \n"+ strErrors + "\nLa compilación termino con errores.");
        }
        else{
            jtaOutputConsole.setText("Compilacion terminada");
        }
    }
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLayeredPane1 = new javax.swing.JLayeredPane();
        jScrollPane2 = new javax.swing.JScrollPane();
        jtaOutputConsole = new javax.swing.JTextArea();
        jScrollPane4 = new javax.swing.JScrollPane();
        jtpCode = new javax.swing.JTextPane();
        jScrollPane3 = new javax.swing.JScrollPane();
        tblTokens = new javax.swing.JTable();
        jLayeredPane2 = new javax.swing.JLayeredPane();
        btnGuardar = new javax.swing.JButton();
        btnAbrir = new javax.swing.JButton();
        btnGuardarC = new javax.swing.JButton();
        btnNuevo = new javax.swing.JButton();
        btnEjecutar = new javax.swing.JButton();
        btnCompilar = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setBackground(new java.awt.Color(51, 51, 51));
        setForeground(java.awt.Color.black);
        setResizable(false);

        jtaOutputConsole.setColumns(20);
        jtaOutputConsole.setRows(5);
        jScrollPane2.setViewportView(jtaOutputConsole);

        jScrollPane4.setViewportView(jtpCode);

        tblTokens.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null}
            },
            new String [] {
                "Componente lexico", "Lexema", "[linea,columna]"
            }
        ));
        jScrollPane3.setViewportView(tblTokens);

        jLayeredPane1.setLayer(jScrollPane2, javax.swing.JLayeredPane.DEFAULT_LAYER);
        jLayeredPane1.setLayer(jScrollPane4, javax.swing.JLayeredPane.DEFAULT_LAYER);
        jLayeredPane1.setLayer(jScrollPane3, javax.swing.JLayeredPane.DEFAULT_LAYER);

        javax.swing.GroupLayout jLayeredPane1Layout = new javax.swing.GroupLayout(jLayeredPane1);
        jLayeredPane1.setLayout(jLayeredPane1Layout);
        jLayeredPane1Layout.setHorizontalGroup(
            jLayeredPane1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jLayeredPane1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jLayeredPane1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jScrollPane2)
                    .addComponent(jScrollPane4, javax.swing.GroupLayout.PREFERRED_SIZE, 522, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jScrollPane3, javax.swing.GroupLayout.PREFERRED_SIZE, 215, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );
        jLayeredPane1Layout.setVerticalGroup(
            jLayeredPane1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jLayeredPane1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jLayeredPane1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 360, Short.MAX_VALUE)
                    .addGroup(jLayeredPane1Layout.createSequentialGroup()
                        .addComponent(jScrollPane4)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 94, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap())
        );

        btnGuardar.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Iconos/Icon/icons8_save_48px.png"))); // NOI18N
        btnGuardar.setText("Guardar");
        btnGuardar.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        btnGuardar.setPressedIcon(new javax.swing.ImageIcon(getClass().getResource("/Iconos/pressed/icons8_save_48px_p.png"))); // NOI18N
        btnGuardar.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        btnGuardar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnGuardarActionPerformed(evt);
            }
        });

        btnAbrir.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Iconos/Icon/icons8_opened_folder_48px.png"))); // NOI18N
        btnAbrir.setText("Abrir");
        btnAbrir.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        btnAbrir.setPressedIcon(new javax.swing.ImageIcon(getClass().getResource("/Iconos/pressed/icons8_opened_folder_48px_P.png"))); // NOI18N
        btnAbrir.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        btnAbrir.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnAbrirActionPerformed(evt);
            }
        });

        btnGuardarC.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Iconos/Icon/icons8_save_as_48px.png"))); // NOI18N
        btnGuardarC.setText("Guardar como");
        btnGuardarC.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        btnGuardarC.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        btnGuardarC.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnGuardarCActionPerformed(evt);
            }
        });

        btnNuevo.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Iconos/Icon/icons8_code_file_48px.png"))); // NOI18N
        btnNuevo.setText("Nuevo");
        btnNuevo.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        btnNuevo.setPressedIcon(new javax.swing.ImageIcon(getClass().getResource("/Iconos/pressed/icons8_code_file_48px_p.png"))); // NOI18N
        btnNuevo.setSelectedIcon(new javax.swing.ImageIcon(getClass().getResource("/Iconos/pressed/icons8_code_file_48px_p.png"))); // NOI18N
        btnNuevo.setVerticalAlignment(javax.swing.SwingConstants.BOTTOM);
        btnNuevo.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        btnNuevo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnNuevoActionPerformed(evt);
            }
        });

        btnEjecutar.setText("Ejecutar");
        btnEjecutar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnEjecutarActionPerformed(evt);
            }
        });

        btnCompilar.setText("Compilar");
        btnCompilar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnCompilarActionPerformed(evt);
            }
        });

        jLayeredPane2.setLayer(btnGuardar, javax.swing.JLayeredPane.DEFAULT_LAYER);
        jLayeredPane2.setLayer(btnAbrir, javax.swing.JLayeredPane.DEFAULT_LAYER);
        jLayeredPane2.setLayer(btnGuardarC, javax.swing.JLayeredPane.DEFAULT_LAYER);
        jLayeredPane2.setLayer(btnNuevo, javax.swing.JLayeredPane.DEFAULT_LAYER);
        jLayeredPane2.setLayer(btnEjecutar, javax.swing.JLayeredPane.DEFAULT_LAYER);
        jLayeredPane2.setLayer(btnCompilar, javax.swing.JLayeredPane.DEFAULT_LAYER);

        javax.swing.GroupLayout jLayeredPane2Layout = new javax.swing.GroupLayout(jLayeredPane2);
        jLayeredPane2.setLayout(jLayeredPane2Layout);
        jLayeredPane2Layout.setHorizontalGroup(
            jLayeredPane2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jLayeredPane2Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(btnNuevo)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(btnAbrir)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(btnGuardar)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(btnGuardarC)
                .addGap(127, 127, 127)
                .addComponent(btnCompilar)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(btnEjecutar)
                .addContainerGap())
        );
        jLayeredPane2Layout.setVerticalGroup(
            jLayeredPane2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jLayeredPane2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jLayeredPane2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(btnNuevo)
                    .addComponent(btnAbrir)
                    .addComponent(btnGuardar)
                    .addComponent(btnGuardarC)
                    .addComponent(btnCompilar)
                    .addComponent(btnEjecutar))
                .addContainerGap())
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jLayeredPane1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
            .addGroup(layout.createSequentialGroup()
                .addGap(21, 21, 21)
                .addComponent(jLayeredPane2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(30, 30, 30)
                .addComponent(jLayeredPane2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jLayeredPane1)
                .addContainerGap())
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void btnNuevoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnNuevoActionPerformed
        Directorio.New();
        clearFields();
    }//GEN-LAST:event_btnNuevoActionPerformed

    private void btnGuardarCActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnGuardarCActionPerformed
        if(Directorio.SaveAs()){
            colorAnalysis();
            clearFields();
        }
    }//GEN-LAST:event_btnGuardarCActionPerformed

    private void btnGuardarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnGuardarActionPerformed
        if(Directorio.Save()){
            colorAnalysis();
            clearFields();
        }
        
    }//GEN-LAST:event_btnGuardarActionPerformed

    private void btnAbrirActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnAbrirActionPerformed
        if(Directorio.Open()){
            colorAnalysis();
            clearFields();
        }
    }//GEN-LAST:event_btnAbrirActionPerformed

    private void btnCompilarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnCompilarActionPerformed
        //si todavia no se ha guardado el codigo
        if(getTitle().contains("*") || getTitle().equals(title)){
            if(Directorio.Save()){
                compile();
            }
        }
        else{
            compile();
        }
    }//GEN-LAST:event_btnCompilarActionPerformed

    private void btnEjecutarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnEjecutarActionPerformed
        btnCompilar.doClick();
        if(codeHasBeenCompiled){
            if(!errores.isEmpty()){
                JOptionPane.showMessageDialog(null, "no se puede ejecutar el codigo, ya que se encontraron errores");
            }
            else{
                
            }
        }
    }//GEN-LAST:event_btnEjecutarActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(Compilador.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(Compilador.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(Compilador.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(Compilador.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(() -> {
            try {
                UIManager.setLookAndFeel(new FlatIntelliJLaf());
                new Compilador().setVisible(true);
            } catch (UnsupportedLookAndFeelException ex) {
                Logger.getLogger(Compilador.class.getName()).log(Level.SEVERE, null, ex);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton btnAbrir;
    private javax.swing.JButton btnCompilar;
    private javax.swing.JButton btnEjecutar;
    private javax.swing.JButton btnGuardar;
    private javax.swing.JButton btnGuardarC;
    private javax.swing.JButton btnNuevo;
    private javax.swing.JLayeredPane jLayeredPane1;
    private javax.swing.JLayeredPane jLayeredPane2;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JScrollPane jScrollPane4;
    private javax.swing.JTextArea jtaOutputConsole;
    private javax.swing.JTextPane jtpCode;
    private javax.swing.JTable tblTokens;
    // End of variables declaration//GEN-END:variables
}
