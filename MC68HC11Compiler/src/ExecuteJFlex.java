import jflex.exceptions.SilentExit;

/**
 *
 * @author adan_
 */
public class ExecuteJFlex {

    public static void main(String omega[]) {
        String lexerFile = System.getProperty("user.dir") + "/src/Lexer.flex",
                lexerFileColor = System.getProperty("user.dir") + "/src/LexerColor.flex";
        //para obtener el directorio
        try {
            jflex.Main.generate(new String[]{lexerFile, lexerFileColor});
        } catch (SilentExit ex) {
            System.out.println("Error al compilar/generar el archivo flex: " + ex);
        }
    }
}
