import java.net.*;
import java.io.*;
import java.util.*;

public class Server{
	public static void main(String[] args){
		try{
			ServerSocket server=new ServerSocket(5000);
			System.out.println("Server Started...");
			Socket socket=server.accept();
            System.out.println("Client Connected!");
			
			Scanner sc = new Scanner(System.in);
		
			BufferedReader in =new BufferedReader(new InputStreamReader(socket.getInputStream()));	
			PrintWriter out =new PrintWriter(socket.getOutputStream(),true);	
			while(true){
				String msg=in.readLine();
				System.out.println("Client: "+ msg);	
				if(msg.equalsIgnoreCase("bye")){
   					 break;
				}	
				String reply = sc.nextLine();
				out.println(reply);
				if(reply.equalsIgnoreCase("bye")){
 				   break;
				}
			}
			

			socket.close();
			server.close();
            sc.close();
		}
		catch(Exception e){
			System.out.println(e);
		}
	}	
}