import java.io.*;
import java.net.*;
import java.util.Scanner;

public class TCPClient {
	public static void main(String[] args){
		try{
			Socket socket=new Socket("localhost",5000);
			DataInputStream dis=new DataInputStream(socket.getInputStream());
			DataOutputStream dos=new DataOutputStream(socket.getOutputStream());
			Scanner sc=new Scanner(System.in);
			System.out.println("1.Upload");
			System.out.println("2.Download");
			System.out.println("3.Exit");
			while(true){
				System.out.println("Enter choice: ");
				int n=sc.nextInt();sc.nextLine();
				if(n==1){
					System.out.println("Enter file name: ");
					String fn=sc.nextLine();

					BufferedReader br=new BufferedReader(new FileReader(fn));
				
					String data=br.readLine();

					String en=Caesar.encrypt(data);
					dos.writeUTF("UPLOAD");
					dos.writeUTF(fn);
					dos.writeUTF(en);

				System.out.println("Upload Successful");
				}else if(n==2){
					System.out.println("Enter file name: ");
					String fn=sc.nextLine();
					
					dos.writeUTF("DOWNLOAD");
					dos.writeUTF(fn);

					String data=dis.readUTF();
					String de=Caesar.decrypt(data);
				
					FileWriter fw=new FileWriter(fn);
					fw.write(de);fw.close();
					System.out.println("Download Successful");
				}else{
						System.out.println("Exiting...");
						break;
				}
			}socket.close();
		}catch(Exception e){System.out.println(e);}
			
			
}
}
