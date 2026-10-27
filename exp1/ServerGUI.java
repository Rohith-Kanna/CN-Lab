
import javax.swing.*;
import java.awt.*;
import java.net.*;
import java.io.*;

public class ServerGUI {
    public static void main(String[] args) {
        try {
            ServerSocket server = new ServerSocket(5000);
            System.out.println("Server Started");
            Socket socket = server.accept();

            BufferedReader in = new BufferedReader(
                new InputStreamReader(socket.getInputStream()));
            PrintWriter out = new PrintWriter(
                socket.getOutputStream(), true);

            JFrame f = new JFrame("Server");
            f.setSize(400, 400);
            f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

            JTextArea chat = new JTextArea();
            chat.setEditable(false);
            JTextField input = new JTextField();
            JButton send = new JButton("Send");

            JPanel p = new JPanel(new BorderLayout());
            p.add(input, BorderLayout.CENTER);
            p.add(send, BorderLayout.EAST);

            f.add(chat, BorderLayout.CENTER);
            f.add(p, BorderLayout.SOUTH);
            f.setVisible(true);

            send.addActionListener(e -> {
                String msg = input.getText();
                out.println(msg);
                chat.append("Server: " + msg + "\n");
                input.setText("");
            });

            String msg;
            while ((msg = in.readLine()) != null) {
                chat.append("Client: " + msg + "\n");
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
