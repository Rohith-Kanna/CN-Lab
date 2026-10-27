import javax.swing.*;
import java.awt.*;
import java.io.*;
import java.net.*;

public class ClientGUI{
    public static void main(String[] args){
        try{
        
        Socket socket=new Socket("localhost",5000);

        BufferedReader in = new BufferedReader(
            new InputStreamReader(socket.getInputStream()));
        PrintWriter out=new PrintWriter(socket.getOutputStream(),true);

        JFrame f=new JFrame("Client");
        f.setSize(400,400);

        JTextArea chat=new JTextArea();
        chat.setEditable(false);
        JTextField input=new JTextField();
        JButton send=new JButton("Send");

        JPanel p=new JPanel(new BorderLayout());
        p.add(input,BorderLayout.CENTER);
        p.add(send,BorderLayout.EAST);

        f.add(chat,BorderLayout.CENTER);
        f.add(p,BorderLayout.SOUTH);
    f.setVisible(true);
        send.addActionListener(e->{
            String msg=input.getText();
            out.println(msg);
            chat.append("Client: "+msg+"\n");
            input.setText("");
        });

        String msg;
        while((msg=in.readLine())!=null){
            chat.append("Server: "+msg+"\n");
            if(msg.equalsIgnoreCase("bye"))
                break;
        }

        socket.close();
       

    }catch(Exception e){
        System.out.println(e);
    }
    }
}