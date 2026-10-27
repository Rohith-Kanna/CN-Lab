import java.io.*;
import java.net.*;

public class TCPServer {
    public static void main(String [] args){
        try{
            ServerSocket server=new ServerSocket(5000);
            System.out.println("Server Started");
            Socket socket= server.accept();
            System.out.println("Client Connected");
            DataInputStream dis=new DataInputStream(socket.getInputStream());
            DataOutputStream dos=new DataOutputStream(socket.getOutputStream());
            while(true){
                String cmd=dis.readUTF();
                if(cmd.equals("UPLOAD")){
                    String filename=dis.readUTF();
                    String filedata=dis.readUTF();

                    FileWriter fw=new FileWriter(filename);
                    fw.write(filedata);fw.close();
                    System.out.println("Uploaded");
                }
                else if(cmd.equals("DOWNLOAD")){
                    String filename=dis.readUTF();
                    BufferedReader br=new BufferedReader(new FileReader(filename));
                    String data=br.readLine();
                    dos.writeUTF(data);
                    System.out.println("Downloaded");
                }else{
                System.out.println("Exit..");break;}
            }
            socket.close();
            server.close();
        }catch(Exception e){System.out.println(e);}
}
    
}
