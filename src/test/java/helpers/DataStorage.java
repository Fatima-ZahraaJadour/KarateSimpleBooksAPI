package helpers;

import java.io.*;
import java.util.*;

import static java.lang.Integer.parseInt;

public class DataStorage {
    Properties prop = new Properties();
    OutputStream output = null;
    InputStream input = null;
    private static String FILE_NAME = "config.properties";

    public void write(Map<String, Object> config) throws IOException {
        //System.out.println("fatixa x");
        String key = (String) config.keySet().toArray()[0];
        String value = config.get(key).toString();
        output = new FileOutputStream(FILE_NAME);
        prop.setProperty(key, value);
        prop.store(output, null);
    }

    public String read(String key) throws IOException {

        input = new FileInputStream(FILE_NAME);
        prop.load(input);
        //System.out.println("fatixa "+prop.getProperty(key));
        return prop.getProperty(key);
    }
    public Integer readInt(String key) throws IOException {
        input = new FileInputStream(FILE_NAME);
        prop.load(input);
        //System.out.println("fatixa "+prop.getProperty(key));
        if(prop.getProperty(key)!=null)
            return parseInt(prop.getProperty(key));
        else
            return 0;
    }
    public String generate() throws IOException{
        input = new FileInputStream(FILE_NAME);
        String email = "fatima"+ UUID.randomUUID()+ "@gmail.com";
        return email;
    }
}
