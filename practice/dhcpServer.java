import java.net.*;
import java.io.*;
import java.util.*;

public class dhcpServer{
	public static void main(String args[]) throws Exception{
		DatagramSocket s=new DatagramSocket(4900);
		String[] ips={"192.168.1.2","192.168.1.3","192.168.1.4"};
		int i=0;
		Map<String,String> map=new HashMap<>();

		System.out.println("DHCP Started");
		while(true){
			byte[] buf=new byte[1024];
			DatagramPacket p=new DatagramPacket(buf,buf.length);
			s.receive(p);
			String mac=new String(p.getData());
			mac=mac.trim();
			if(!map.containsKey(mac)){
				if(i<ips.length)
					map.put(mac,ips[i++]);
			}

			String reply=map.containsKey(mac)?"Allocated IP: "+map.get(mac):"No Available IP.";

			byte[] data=reply.getBytes();
			s.send(new DatagramPacket (buf,buf.length,p.getAddress(),p.getPort()));
			System.out.println(mac+"->"+reply);
		}
}
}