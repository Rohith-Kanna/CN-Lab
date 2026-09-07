import java.rmi.*; 
import java.rmi.server.*; 
import java.rmi.registry.*; 
 
 
// This class contains the actual code that runs when the client calls add().
class MyImpl extends UnicastRemoteObject implements MyInterface { 
 
    public MyImpl() throws RemoteException { 
        super(); 
    } 
 
    public double add(double a, double b) throws RemoteException { 
        // The client sends the two values here, and the server returns their sum.
        return a + b; 
    } 
} 
 
// Starts the RMI server and makes the remote object available to clients.
public class MyServer { 
 
    public static void main(String args[]) { 
 
        try { 
 
            // Create the object whose methods can be called remotely.
            MyImpl obj = new MyImpl(); 
 
            // Register the object with a name so clients can find it using Naming.lookup().
            Naming.rebind("AddService", obj); 
 
            System.out.println("Server is Ready..."); 
        } 
        catch(Exception e) { 
            System.out.println(e); 
        } 
    } 
}