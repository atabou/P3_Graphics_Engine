
ArrayList<Triangle> parseFile(String file) {

  BufferedReader rd = createReader(file);
  String line = null;
  
  ArrayList<String> parsedFile = new ArrayList<String>();
    
  try {
    
    while ( (line = rd.readLine()) != null) {
      
      parsedFile.add(line);
            
    }    
    
  } catch (IOException e) { e.printStackTrace(); }
  
  
  ArrayList<Point> verts = new ArrayList<Point>();
  String[] splited = new String[1];

  for(int i=0; i<parsedFile.size(); i++) {
    
    splited = split(parsedFile.get(i), ' ');
    
    if( splited[0].equals("v") ) {
      
      verts.add(new Point());
      
      verts.get(verts.size()-1).x = Float.parseFloat(splited[1]);
      verts.get(verts.size()-1).y = Float.parseFloat(splited[2]);
      verts.get(verts.size()-1).z = Float.parseFloat(splited[3]);
      
    }  
  }
  
  ArrayList<Triangle> obj = new ArrayList<Triangle>();
  
  for(int i=0; i<parsedFile.size(); i++) {
  
    splited = split(parsedFile.get(i), ' ');
    
    if( splited[0].equals("f") ) {
      
      obj.add( new Triangle() );
      
      obj.get(obj.size()-1).P[0].x = verts.get( int(splited[1]) -1 ).x;
      obj.get(obj.size()-1).P[0].y = verts.get( int(splited[1]) -1 ).y;
      obj.get(obj.size()-1).P[0].z = verts.get( int(splited[1]) -1 ).z;
      obj.get(obj.size()-1).P[1].x = verts.get( int(splited[2]) -1 ).x;
      obj.get(obj.size()-1).P[1].y = verts.get( int(splited[2]) -1 ).y;
      obj.get(obj.size()-1).P[1].z = verts.get( int(splited[2]) -1 ).z;
      obj.get(obj.size()-1).P[2].x = verts.get( int(splited[3]) -1 ).x;
      obj.get(obj.size()-1).P[2].y = verts.get( int(splited[3]) -1 ).y;
      obj.get(obj.size()-1).P[2].z = verts.get( int(splited[3]) -1 ).z;
      
      
    }
  }

  return obj;
  
}

Object3D readMesh(String s) {
  
    ArrayList<String> numbers = new ArrayList<String>();
    Object3D obj = new Object3D();
  
    boolean flag = false;
    boolean flag1 = false;
    
    char rd = ' ';
    String nmb = "";
  
   for (int i=0; i<s.length(); i++) {
     
     rd = s.charAt(i);
     
     if (rd == '{') {
       if (flag == false) {
         flag = true;  
       } else {
         flag1 = true;
       }
       
     } else if (rd == '}') {
       
       if(flag1 == true) {
          flag1 = false;
       } else {
          flag = false; 
       }
     }
     
     if(flag == true && flag1 == true) {
       
       if( (rd <= '9' && rd >= '0') || rd == '.') {
       
         nmb = nmb + rd;
         
       }
       
       if (rd == 'f') {
         numbers.add(nmb);
         nmb = "";
       }
       
     }

   }
   
   float[] number = new float[numbers.size()];
  
   for (int i=0; i<numbers.size(); i++) {
     
     number[i] = Float.parseFloat(numbers.get(i));
     
   }
   
   int Counter = 0;
   
   Triangle Holder = new Triangle();
   
   for (int i=0; i<number.length; i=i+3) {
     
     Point A = new Point();
     
     A.x = number[i];
     A.y = number[i+1];
     A.z = number[i+2];
     
     
     if(Counter == 2) {
      
       Holder.P[Counter] = A;
       
       obj.Mesh.add(new Triangle());
       
       obj.Mesh.get(obj.Mesh.size()-1).P[0] = Holder.P[0];
       obj.Mesh.get(obj.Mesh.size()-1).P[1] = Holder.P[1];
       obj.Mesh.get(obj.Mesh.size()-1).P[2] = Holder.P[2];
       
       Counter = 0;
       
     } else {
      
       Holder.P[Counter] = A;
       Counter++;
       
     }
     
   }
   
   
   return obj;
   
}
