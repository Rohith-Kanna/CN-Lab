
import java.net.*;

public class dhcpClient {
	public static void main(String args[]) throws Exception{
		DatagramSocket s=new DatagramSocket();

		String mac="00.11.22.33.44.55";
		byte[] data=mac.getBytes();

		InetAddress ip=InetAddress.getByName("127.0.0.1");
		s.send(new DatagramPacket(data,data.length,ip,4900));

		byte[] buf=new byte[1024];
        DatagramPacket p=new DatagramPacket(buf,buf.length);

        s.receive(p);

        String response=new String(p.getData());
		System.out.println(response.trim());

        s.close();
    }
		
}