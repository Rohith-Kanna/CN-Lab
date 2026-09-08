import java.net.*;
import java.io.*;

public class TCPServer {

    public static void main(String[] args) {

        try {
            ServerSocket server = new ServerSocket(5000);

            System.out.println("Server Started...");
            System.out.println("Waiting for Client...");

            Socket socket = server.accept();

            System.out.println("Client Connected!");

            DataInputStream dis =
                new DataInputStream(socket.getInputStream());

            DataOutputStream dos =
                new DataOutputStream(socket.getOutputStream());

            while (true) {

                String command = dis.readUTF();

                // UPLOAD
                if (command.equals("UPLOAD")) {

                    String filename = dis.readUTF();
                    String fileData = dis.readUTF();

                    FileWriter fw = new FileWriter(filename);
                    fw.write(fileData); //writing the encrypted data to the file
                    fw.close();

                    System.out.println(
                        "Upload Completed : " + filename
                    );
                }

                // DOWNLOAD
                else if (command.equals("DOWNLOAD")) {

                    String filename = dis.readUTF();

                    BufferedReader br =
                        new BufferedReader(new FileReader(filename));

                    StringBuilder data = new StringBuilder();

                    String line;    

                    while ((line = br.readLine()) != null) {
                        data.append(line).append("\n");
                    }

                    br.close();

                    // String encrypted =
                    //     CaesarCipher.encrypt(data.toString());

                    dos.writeUTF(data.toString());

                    System.out.println(
                        "Download Completed : " + filename
                    );
                }

                // EXIT
                else if (command.equals("EXIT")) {
                    break;
                }
            }

            socket.close();
            server.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}