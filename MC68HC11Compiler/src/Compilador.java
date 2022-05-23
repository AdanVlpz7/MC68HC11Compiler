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
        Functions.setLineNumberOnJTextComponent(jtpCode); //para que se numeren las lineas del codigo
        timerKeyReleased = new Timer(300,((e) -> {
            timerKeyReleased.stop();
            colorAnalysis(); // se colorean el texto cada 300 milisegundos
        }));
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
        gramatica.group("Variable","IDENTIFICADOR Directiva_EQU DirExt");
        gramatica.group("Variable","Directiva_EQU  DirExt",true,2,
                "error sintatico: falta el identificador en la variable [#,%]");
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
