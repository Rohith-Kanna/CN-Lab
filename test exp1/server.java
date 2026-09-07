import java.net.*;
import java.io.*;

public class server{
	public static void main(String[] args){
		try{
			ServerSocket server=new ServerSocket(5000);
			System.out.println("Server Started...");
			Socket socket=server.accept();
			BufferedReader in=new BufferedReader(new InputStreamReader(socket.getInputStream()));
			PrintWriter out =new PrintWriter(socket.getOutputStream(), true);
			String msg=in.readLine();
			System.out.println(msg);
			out.println("Hello Client");
			socket.close();
			server.close();
		}
		catch(Exception e){
			System.out.println(e);
		}
	}	
}