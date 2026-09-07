import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.net.*;
import javax.swing.*;

public class TCPClient extends JFrame implements ActionListener {

    JLabel title, fileLabel;
    JTextField fileField;
    JTextArea fileList;
    JButton upload, download;

    Socket socket;
    DataInputStream dis;
    DataOutputStream dos;

    public TCPClient() {
        setTitle("TCP CLIENT");
        setSize(600, 450);
        setLayout(null);
        setDefaultCloseOperation(EXIT_ON_CLOSE);

        title = new JLabel("TCP CLIENT");
        title.setFont(new Font("Arial", Font.BOLD, 30));
        title.setBounds(190, 20, 300, 40);
        add(title);

        JLabel listLabel = new JLabel("Files in Client Directory");
        listLabel.setBounds(210, 80, 200, 20);
        add(listLabel);

        fileList = new JTextArea();
        JScrollPane sp = new JScrollPane(fileList);
        sp.setBounds(170, 105, 250, 100);
        add(sp);

        fileLabel = new JLabel("Enter File Name");
        fileLabel.setBounds(70, 240, 120, 25);
        add(fileLabel);

        fileField = new JTextField();
        fileField.setBounds(190, 240, 250, 25);
        add(fileField);

        upload = new JButton("Upload");
        upload.setBounds(120, 300, 120, 35);
        upload.addActionListener(this);
        add(upload);

        download = new JButton("Download");
        download.setBounds(320, 300, 120, 35);
        download.addActionListener(this);
        add(download);

        loadFiles();

        try {
            socket = new Socket("localhost", 5000);
            dis = new DataInputStream(socket.getInputStream());
            dos = new DataOutputStream(socket.getOutputStream());
        } catch (Exception e) {
            JOptionPane.showMessageDialog(this, "Server Not Running");
        }

        setVisible(true);
    }

    public void loadFiles() {
        File folder = new File(".");
        File files[] = folder.listFiles();

        fileList.setText("");

        for (File f : files) {
            if (f.isFile()) {
                fileList.append(f.getName() + "\n");
            }
        }
    }

    public void uploadFile() {
        try {
            String filename = fileField.getText();

            BufferedReader br = new BufferedReader(new FileReader(filename));

            StringBuilder sb = new StringBuilder();
            String line;

            while ((line = br.readLine()) != null) {
                sb.append(line).append("\n");
            }

            br.close();

            String encrypted = CaesarCipher.encrypt(sb.toString());

            dos.writeUTF("UPLOAD");
            dos.writeUTF(filename);
            dos.writeUTF(encrypted);

            JOptionPane.showMessageDialog(this, "Upload Successful");

        } catch (Exception e) {
            JOptionPane.showMessageDialog(this, "Upload Failed");
        }
    }

    public void downloadFile() {
        try {
            String filename = fileField.getText();

            dos.writeUTF("DOWNLOAD");
            dos.writeUTF(filename);

            String encrypted = dis.readUTF();

            String plain = CaesarCipher.decrypt(encrypted);

            FileWriter fw = new FileWriter(filename);

            fw.write(plain);

            fw.close();

            JOptionPane.showMessageDialog(this, "Download Successful");

        } catch (Exception e) {
            JOptionPane.showMessageDialog(this, "Download Failed");
        }
    }

    public void actionPerformed(ActionEvent e) {

        if (e.getSource() == upload) {
            uploadFile();
        }

        if (e.getSource() == download) {
            downloadFile();
        }
    }

    public static void main(String args[]) {
        new TCPClient();
    }
}