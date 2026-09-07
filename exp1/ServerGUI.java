import javax.swing.*;
import java.awt.*;
import java.net.*;
import java.io.*;

public class ServerGUI {

    public static void main(String[] args) {

        try {

            // ---------- Socket ----------
            ServerSocket server = new ServerSocket(5000);
            System.out.println("Server Started...");
            Socket socket = server.accept();
            System.out.println("Client Connected!");

            BufferedReader in =
                    new BufferedReader(
                            new InputStreamReader(
                                    socket.getInputStream()));

            PrintWriter out =
                    new PrintWriter(
                            socket.getOutputStream(), true);

            // ---------- GUI ----------
            JFrame frame = new JFrame("Server Chat");
            frame.setSize(500, 500);
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setLocationRelativeTo(null);

            JTextArea chatArea = new JTextArea();
            chatArea.setEditable(false);
            JScrollPane scroll = new JScrollPane(chatArea);

            JTextField input = new JTextField(25);
            JButton send = new JButton("Send");

            JPanel panel = new JPanel();
            panel.add(input);
            panel.add(send);

            frame.add(scroll, BorderLayout.CENTER);
            frame.add(panel, BorderLayout.SOUTH); //bottom panel

            frame.setVisible(true);

            // ---------- Send Button ----------
            send.addActionListener(e -> {

                String msg = input.getText();
                out.println(msg); //sends msges to  the client
                chatArea.append("Server : " + msg + "\n"); //displays the msg sent
                input.setText("");

            });

            // ---------- Receive ----------
            while (true) {

                String msg = in.readLine(); //reads msges from client
                if (msg == null)
                    break;
                chatArea.append("Client : " + msg + "\n"); //displays the received msges
                if (msg.equalsIgnoreCase("bye"))
                    break;

            }

            socket.close();
            server.close();

        } catch (Exception e) {

            System.out.println(e);

        }

    }

}