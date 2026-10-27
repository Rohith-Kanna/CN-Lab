import java.rmi.*;

public class MyClient{
	public static void main(String[] args){
		try{
			String server=(args.length>0)?args[0]:"localhost";
			MyInterface obj=(MyInterface)Naming.lookup("rmi://"+server+"/Addservice");
			
			double o1=Double.parseDouble(args[1]);
			double o2=Double.parseDouble(args[2]);
			double o3=Double.parseDouble(args[3]);

			System.out.println("O1 + O2="+obj.add(o1,o2));
			System.out.println("O2 + O3="+obj.add(o2,o3));
			System.out.println("O1 + O3="+obj.add(o1,o3));

		}catch(Exception e){System.out.println(e);}
	}
}