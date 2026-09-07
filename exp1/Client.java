import java.util.*;
import java.net.*;
import java.util.Scanner;
import java.io.*;

public class Client{
	public static void main(String[] args){
		try{
			Socket socket=new Socket("localhost",5000);

			BufferedReader in =new BufferedReader(new InputStreamReader(socket.getInputStream()));

			PrintWriter out =new PrintWriter(socket.getOutputStream(), true);
			Scanner sc=new Scanner(System.in);
			while(true){
				String msg = sc.nextLine();
				out.println(msg);
				if(msg.equalsIgnoreCase("bye")){
 				   break;
				}

				String reply=in.readLine();
				System.out.println("Server: "+ reply);	
				if(reply.equalsIgnoreCase("bye")){
   					 break;
				}	
				

			}		
			socket.close();
					}
		catch(Exception e){
			System.out.println(e);
		}
	}	
}