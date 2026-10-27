public class Caesar {
    public static  final int KEY=3;
	
	public static String encrypt(String txt){
	StringBuilder en=new StringBuilder();
	for(char ch:txt.toCharArray()){
		en.append((char)((ch+KEY)%256));
	}return en.toString();
	}

	
	public static String decrypt(String txt){
	StringBuilder de=new StringBuilder();
	for(char ch:txt.toCharArray()){
		int val=ch-KEY;
		if(val<0)val+=256;
		de.append((char)val);
	}return de.toString();
	}
}
