
class Object3D {
  
  ArrayList<Triangle> Mesh;
  
  Object3D () {
    
      Mesh = new ArrayList<Triangle>();
      
  }
  
  void loadObj(String file) {
    
    Mesh = parseFile(file);
    
  }
  
}
