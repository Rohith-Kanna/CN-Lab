import java.rmi.*;
import java.rmi.server.*;

class MyImpl extends UnicastRemoteObject implements MyInterface{
	public MyImpl() throws RemoteException{
		super();
	}

	public double(double a,double b) throws RemoteException{
		return a+b;
	}
}

public class MyServer {
	public static void main(String[] args){
	try{
		MyImpl obj=new MyImpl();
		Naming.rebind("AddService",obj);
		System.out.println("Server Started");
	}catch(Exception e){System.out.println(e);}
}
}