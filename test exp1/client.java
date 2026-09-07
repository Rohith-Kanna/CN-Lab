import java.net.*;
import java.io.*;

public class client{
	public static void main(String[] args){
		try{
			Socket s=new Socket("localhost",5000);

			BufferedReader in =new BufferedReader(new InputStreamReader(s.getInputStream()));

			PrintWriter out =new PrintWriter(s.getOutputStream(), true);
			out.println("Hello Client");
			String msg=in.readLine();
			System.out.println(msg);
			
			s.close();
					}
		catch(Exception e){
			System.out.println(e);
		}
	}	
}