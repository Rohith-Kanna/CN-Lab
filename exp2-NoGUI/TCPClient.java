import java.net.*;
import java.io.*;
import java.util.Scanner;

public class TCPClient {

    public static void main(String[] args) {

        try {
            Socket socket =
                new Socket("localhost", 5000);

            DataInputStream dis =
                new DataInputStream(socket.getInputStream());

            DataOutputStream dos =
                new DataOutputStream(socket.getOutputStream());

            Scanner sc = new Scanner(System.in);

            while (true) {

                System.out.println("\n1. Upload");
                System.out.println("2. Download");
                System.out.println("3. Exit");
                System.out.print("Enter choice: ");

                int choice = sc.nextInt();
                sc.nextLine();

                // UPLOAD
                if (choice == 1) {

                    System.out.print("Enter filename: ");
                    String filename = sc.nextLine();

                    BufferedReader br =
                        new BufferedReader(
                            new FileReader(filename)
                        );

                    StringBuilder data = new StringBuilder();

                    String line;

                    while ((line = br.readLine()) != null) {
                        data.append(line).append("\n");
                    }

                    br.close();

                    String encrypted =
                        CaesarCipher.encrypt(data.toString());

                    dos.writeUTF("UPLOAD");
                    dos.writeUTF(filename);
                    dos.writeUTF(encrypted);

                    System.out.println("Upload Successful");
                }

                // DOWNLOAD
                else if (choice == 2) {

                    System.out.print("Enter filename: ");
                    String filename = sc.nextLine();

                    dos.writeUTF("DOWNLOAD");
                    dos.writeUTF(filename);

                    String encrypted =
                        dis.readUTF();

                    String plain =
                        CaesarCipher.decrypt(encrypted);

                    FileWriter fw =
                        new FileWriter(filename);

                    fw.write(plain);
                    fw.close();

                    System.out.println("Download Successful");
                }

                // EXIT
                else if (choice == 3) {

                    dos.writeUTF("EXIT");
                    break;
                }
            }

            socket.close();
            sc.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}