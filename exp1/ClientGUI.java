import javax.swing.*;
import java.awt.*;
import java.net.*;
import java.io.*;

public class ClientGUI {

    public static void main(String[] args) {

        try {

            Socket socket = new Socket("localhost", 5000);

            BufferedReader in =
                    new BufferedReader(
                            new InputStreamReader(
                                    socket.getInputStream()));
            PrintWriter out =
                    new PrintWriter(
                            socket.getOutputStream(), true);

            JFrame frame = new JFrame("Client Chat");
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
            frame.add(panel, BorderLayout.SOUTH);

            frame.setVisible(true);

            send.addActionListener(e -> {
                String msg = input.getText(); //sends msgs to server
                out.println(msg);
                chatArea.append("Client : " + msg + "\n");//displays the msg sent
                input.setText("");
            });

            while (true) {
                String msg = in.readLine();  //reads msges from server
                if (msg == null)
                    break;
                chatArea.append("Server : " + msg + "\n");  //displays the received msges
                if (msg.equalsIgnoreCase("bye"))
                    break;
            }
            socket.close();

        } catch (Exception e) {
            System.out.println(e);
        }
    }
}