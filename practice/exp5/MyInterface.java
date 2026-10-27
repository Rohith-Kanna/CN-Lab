import java.rmi.*;

interface MyInterface extends Remote{
	double add(double a,double b) throws RemoteException;
	}