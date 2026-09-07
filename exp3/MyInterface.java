import java.rmi.*; 
 
// This interface describes the method that can be called remotely by the client.
interface MyInterface extends Remote{ 
  // Every remote method must declare RemoteException because the call uses the network.
  double add(double a,double b) throws RemoteException; 
}