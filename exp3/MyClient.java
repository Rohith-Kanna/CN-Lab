import java.rmi.*;

public class MyClient {

    public static void main(String args[]) {

        try {

            // Use the first command-line argument as the server name.
            // If it is missing, connect to the RMI server on this computer.
            String server = (args.length > 0) ? args[0] : "localhost";

            // Find the remote object that the server registered under this name.
            MyInterface obj = (MyInterface) Naming.lookup(
                    "rmi://" + server + "/AddService");

            // Read the three numbers that will be sent to the remote add method.
            double op1 = Double.parseDouble(args[1]);

            double op2 = Double.parseDouble(args[2]);
            double op3 = Double.parseDouble(args[3]);

            // Each call is executed by the server, even though it looks like a local method
            // call.
            System.out.println("Addition:" + obj.add(op1, op2));
            System.out.println("Addition:" + obj.add(op2, op3));
            System.out.println("Addition:" + obj.add(op3, op1));

        } catch (Exception e) {
            System.out.println(e);
        }
    }
}