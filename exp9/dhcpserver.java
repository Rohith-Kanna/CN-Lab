import java.io.*;
import java.net.*;
import java.util.*;

public class dhcpserver {
    public static void main(String[] args) throws Exception {
        DatagramSocket s = new DatagramSocket(4900);

        String[] ips = {"192.168.1.2", "192.168.1.3", "192.168.1.4"};
        Map<String, String> map = new HashMap<>();
        int i = 0;

        System.out.println("DHCP Server Started");
        
        while (true) {
            //receive mac address from client
            byte[] buf = new byte[1024];
            DatagramPacket p = new DatagramPacket(buf, buf.length);
            s.receive(p);

            String mac = new String(p.getData());
            mac = mac.trim();

            if (!map.containsKey(mac)) {
                if (i < ips.length)
                    map.put(mac, ips[i++]);
            }

            String reply = map.containsKey(mac)
                    ? "Allocated IP: " + map.get(mac)
                    : "No IP Available";

            //send allocated ip to client
            byte[] data = reply.getBytes();
            s.send(new DatagramPacket(data, data.length,
                    p.getAddress(), p.getPort()));

            System.out.println(mac + " -> " + reply);
        }
    }
}
