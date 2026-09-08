public class CaesarCipher {

    private static final int KEY = 3;

    public static String encrypt(String text) {
        StringBuilder encrypted = new StringBuilder();

        for (char ch : text.toCharArray()) {
            encrypted.append((char)((ch + KEY) % 256));
        }

        return encrypted.toString();
    }

    public static String decrypt(String text) {
        StringBuilder decrypted = new StringBuilder();

        for (char ch : text.toCharArray()) {
            int val = ch - KEY;

            if (val < 0)
                val += 256;

            decrypted.append((char)val);
        }

        return decrypted.toString();
    }
}