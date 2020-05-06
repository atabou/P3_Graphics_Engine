
// Initialize Global Variables ////////////////////////////////////////////////////////////////////////

Object3D Cube = new Object3D();
Matrix matProj = new Matrix();

float fTheta;

Point vCamera = new Point();

Point vLookDir = new Point();

float fYaw;

Boolean is_Up = false;
Boolean is_Down = false;
Boolean is_Left = false;
Boolean is_Right = false;

Boolean is_W = false;
Boolean is_A = false;
Boolean is_S = false;
Boolean is_D = false;

float ARROW_SPEED = 1;

float WS_SPEED = 0.5;
float AD_SPEED = 0.05;



// Setup Screen and world /////////////////////////////////////////////////////////////////////////////

void setup () {

    size(800, 800, P2D);
    
    frameRate(30);
    
    vCamera.y = 20;
    vCamera.z = 30;
    
    Cube.loadObj("3D_Assets/mountains.obj");
    
/*    for(int i=0; i< Cube.Mesh.size(); i++) {
     
      ( Cube.Mesh.get(i).P[0].x + ", " + Cube.Mesh.get(i).P[0].y + ", " + Cube.Mesh.get(i).P[0].z);
      ( Cube.Mesh.get(i).P[1].x + ", " + Cube.Mesh.get(i).P[1].y + ", " + Cube.Mesh.get(i).P[1].z);
      ( Cube.Mesh.get(i).P[2].x + ", " + Cube.Mesh.get(i).P[2].y + ", " + Cube.Mesh.get(i).P[2].z + "\n");
      
    }*/
    
//    Cube = readMesh("{{ 0.0f, 0.0f, 0.0f,    0.0f, 1.0f, 0.0f,    1.0f, 1.0f, 0.0f },{ 0.0f, 0.0f, 0.0f,    1.0f, 1.0f, 0.0f,    1.0f, 0.0f, 0.0f },{ 1.0f, 0.0f, 0.0f,    1.0f, 1.0f, 0.0f,    1.0f, 1.0f, 1.0f },{ 1.0f, 0.0f, 0.0f,    1.0f, 1.0f, 1.0f,    1.0f, 0.0f, 1.0f },{ 1.0f, 0.0f, 1.0f,    1.0f, 1.0f, 1.0f,    0.0f, 1.0f, 1.0f },{ 1.0f, 0.0f, 1.0f,    0.0f, 1.0f, 1.0f,    0.0f, 0.0f, 1.0f },{ 0.0f, 0.0f, 1.0f,    0.0f, 1.0f, 1.0f,    0.0f, 1.0f, 0.0f },{ 0.0f, 0.0f, 1.0f,    0.0f, 1.0f, 0.0f,    0.0f, 0.0f, 0.0f },{ 0.0f, 1.0f, 0.0f,    0.0f, 1.0f, 1.0f,    1.0f, 1.0f, 1.0f },{ 0.0f, 1.0f, 0.0f,    1.0f, 1.0f, 1.0f,    1.0f, 1.0f, 0.0f },{ 1.0f, 0.0f, 1.0f,    0.0f, 0.0f, 1.0f,    0.0f, 0.0f, 0.0f },{ 1.0f, 0.0f, 1.0f,    0.0f, 0.0f, 0.0f,    1.0f, 0.0f, 0.0f },}");

    // Projection Matrix
    
    matProj.Matrix_MakeProjection(90.0, (float) height / (float) width, 0.1, 1000.0);

}

// Refresh Screen and world ///////////////////////////////////////////////////////////////////////////

void draw () {
    
  background( 135, 206, 235 );
  
  // Update Camera Position
  
  // Control for Arrow Keys
  
  if (is_Up) {
    vCamera.y += ARROW_SPEED;
  }
  
  if (is_Down) {
      vCamera.y -= ARROW_SPEED;  
  }
  
  if (is_Left) {
      vCamera.x += ARROW_SPEED;
  }
  
  if (is_Right) {
      vCamera.x -= ARROW_SPEED;      
  }
   
  // Control for AWSD 
  
  // Determine in which direction the camera is pointing
  
  Point vForward = Vector_Mul(WS_SPEED, vLookDir);
   
  if (is_W) {
      vCamera = Vector_Add(vCamera,vForward);
  } 
  
  if (is_S) {
      vCamera = Vector_Sub(vCamera,vForward);
  }
  
  if (is_A) {
      fYaw -= AD_SPEED;
  }
  
  if (is_D) {
      fYaw += AD_SPEED;
  }
  
  Matrix matRotZ = new Matrix();
  Matrix matRotX = new Matrix();
  
  // Rotation Z X

  matRotZ.Matrix_MakeRotationZ(fTheta);
  matRotX.Matrix_MakeRotationX(fTheta);
    
  Matrix matTrans = new Matrix();
  matTrans.Identity();
  matTrans.Matrix_MakeTranslation(0,0,16);
  
  Matrix matWorld = new Matrix();
  matWorld.Identity();
  matWorld = Matrix_Multiplication(matRotZ, matRotX);
  matWorld = Matrix_Multiplication(matWorld, matTrans);
  
  Point vUp = new Point();
  vUp.x = 0;
  vUp.y = 1;
  vUp.z = 0;
  
  Point vTarget = Vector_Add(vCamera, vLookDir);
  
  vTarget.x = 0;
  vTarget.y = 0;
  vTarget.z = 1;
  
  Matrix matCameraRot = new Matrix();
  matCameraRot.Matrix_MakeRotationY(fYaw);
  
  vLookDir = vTarget.multMat(matCameraRot);
  
  vTarget = Vector_Add(vCamera, vLookDir);
  
  Matrix matCamera = Matrix_PointAt(vCamera, vTarget, vUp);
  
  Matrix matView = Matrix_QuickInverse(matCamera);
  
  ArrayList<Triangle> vecTrianglesToRaster = new ArrayList<Triangle>();
    
  for (int i=0; i<Cube.Mesh.size(); i++) {
      
      Triangle triTransformed = new Triangle();
      
      triTransformed.P[0] = Cube.Mesh.get(i).P[0].multMat(matWorld);
      triTransformed.P[1] = Cube.Mesh.get(i).P[1].multMat(matWorld);
      triTransformed.P[2] = Cube.Mesh.get(i).P[2].multMat(matWorld);      
      
      // cross Product to get surface normal
      
      Point normal = new Point();
      Point line1 = new Point();
      Point line2 = new Point();
      
      line1 = Vector_Sub(triTransformed.P[1], triTransformed.P[0]);
      line2 = Vector_Sub(triTransformed.P[2], triTransformed.P[0]);
      
      normal = Vector_CrossProduct(line1, line2);
      
      // It's normally normal to normalise the normal
      
      normal = Vector_Normalise(normal);
      
      // Get Ray from triangle to camera
      
      Point vCameraRay = Vector_Sub(triTransformed.P[0], vCamera);
      
      // If ray is aligned with camera
      
      if( Vector_DotProduct(normal, vCameraRay) < 0.0 ) {        
        
        Point light_direction = new Point();
        light_direction.x = 0;
        light_direction.y = 1;
        light_direction.z = -1;       
        
        float dp = Vector_DotProduct(light_direction, normal);

        Triangle triViewed = new Triangle();
        triViewed.P[0] = triTransformed.P[0].multMat(matView);
        triViewed.P[1] = triTransformed.P[1].multMat(matView);
        triViewed.P[2] = triTransformed.P[2].multMat(matView);
        

        ArrayList<Triangle> nClippedTriangles = new ArrayList<Triangle>();
        Triangle[] clipped = new Triangle[2];
        
        clipped[0] = new Triangle();
        clipped[1] = new Triangle();
        
        Point p = new Point();
        Point n = new Point();
        
        p.z = 0.1;
        n.z = 1.0;
        
        nClippedTriangles = Triangle_ClipAgainstPlane(p, n, triViewed, clipped[0], clipped[1]);
        
        if (nClippedTriangles.isEmpty() != true) {
        
          for(int k=0; k<nClippedTriangles.size(); k++) {

            // Project Triangles from 3D to 2D
           
            Triangle triProjected = new Triangle();
      
            triProjected.P[0] = nClippedTriangles.get(k).P[0].multMat(matProj);
            triProjected.P[1] = nClippedTriangles.get(k).P[1].multMat(matProj);
            triProjected.P[2] = nClippedTriangles.get(k).P[2].multMat(matProj);
            
            triProjected.R = nClippedTriangles.get(k).R;
            triProjected.G = nClippedTriangles.get(k).G;
            triProjected.B = nClippedTriangles.get(k).B;
            
            triProjected.P[0] = Vector_Div(triProjected.P[0].w, triProjected.P[0]);
            triProjected.P[1] = Vector_Div(triProjected.P[1].w, triProjected.P[1]);
            triProjected.P[2] = Vector_Div(triProjected.P[2].w, triProjected.P[2]);
      
            triProjected.dp = dp;

            // Scale into view
        
            triProjected.P[0].x *= -1.0;
            triProjected.P[1].x *= -1.0;
            triProjected.P[2].x *= -1.0;
            triProjected.P[0].y *= -1.0;
            triProjected.P[1].y *= -1.0;
            triProjected.P[2].y *= -1.0;

            Point vOffsetView = new Point();
            vOffsetView.x = 1;
            vOffsetView.y = 1;
            vOffsetView.z = 0;
        
            triProjected.P[0] = Vector_Add(triProjected.P[0], vOffsetView);
            triProjected.P[1] = Vector_Add(triProjected.P[1], vOffsetView);
            triProjected.P[2] = Vector_Add(triProjected.P[2], vOffsetView);
 
            triProjected.P[0].x *= 0.5 * (float) width;
            triProjected.P[0].y *= 0.5 * (float) height;

            triProjected.P[1].x *= 0.5 * (float)width;
            triProjected.P[1].y *= 0.5 * (float)height;

            triProjected.P[2].x *= 0.5 * (float)width;
            triProjected.P[2].y *= 0.5 * (float)height;
         
            vecTrianglesToRaster.add(triProjected);
         
          }
        }
      }
  } 
     
     // Sort Triangles to draw the furthust back first then the closest so that depth is accounted for better
     
     for(int i=0; i<vecTrianglesToRaster.size(); i++) {
      
       for(int j=0; j<vecTrianglesToRaster.size()-i-1; j++) {
        
         float z1 = (vecTrianglesToRaster.get(j).P[0].z + vecTrianglesToRaster.get(j).P[1].z + vecTrianglesToRaster.get(j).P[2].z)/3;
         float z2 = (vecTrianglesToRaster.get(j+1).P[0].z + vecTrianglesToRaster.get(j+1).P[1].z + vecTrianglesToRaster.get(j+1).P[2].z)/3;
         
         if(z1 < z2) {

           Triangle temp = vecTrianglesToRaster.get(j);
           vecTrianglesToRaster.set(j,vecTrianglesToRaster.get(j+1));
           vecTrianglesToRaster.set(j+1,temp);
           
         }
         
       }
       
     }
    
    // Rasterize triangle
    
    for(int i=0; i< vecTrianglesToRaster.size(); i++) {
     
      Triangle[] clipped = new Triangle[2];
      
      clipped[0] = new Triangle();
      clipped[1] = new Triangle();
      
      ArrayList<Triangle> intermediary = new ArrayList<Triangle>();
      ArrayList<Triangle> triToRaster = new ArrayList<Triangle>();
      
      triToRaster.add(vecTrianglesToRaster.get(i));
//      println(vecTrianglesToRaster.get(i).R + " " + vecTrianglesToRaster.get(i).G + " " + vecTrianglesToRaster.get(i).B);
      int nNewTriangles = 1;
      
      for(int p=0; p<4; p++) {
       
        while(nNewTriangles > 0) {
         
          Triangle Test = triToRaster.get(triToRaster.size()-1);
          triToRaster.remove(triToRaster.size()-1);
          nNewTriangles--;
          
          // Use if statement
          // clear intermediary after adding the triangles to raster
          
          if (p == 0) {
             
            Point p0 = new Point();
            Point n0 = new Point();
              
            n0.y = 1;
              
            intermediary = Triangle_ClipAgainstPlane(p0, n0, Test,clipped[0],clipped[1]);
            
          } else if(p == 1) {
           
              Point p1 = new Point();
              Point n1 = new Point();
              
              p1.y = (float)height - 1;
              n1.y = -1.0;
              
              intermediary = Triangle_ClipAgainstPlane(p1, n1, Test,clipped[0],clipped[1]);
            
            
          } else if (p == 2) {
           
              Point p2 = new Point();
              Point n2 = new Point();
              
              n2.x = 1;
              
              intermediary = Triangle_ClipAgainstPlane(p2, n2, Test,clipped[0],clipped[1]);
            
            
          } else if (p == 3) {
           
              Point p3 = new Point();
              Point n3 = new Point();
              
              p3.x = (float)width - 1;
              n3.x = -1.0;
              
              intermediary = Triangle_ClipAgainstPlane(p3, n3, Test,clipped[0],clipped[1]);
              
          }
          
          for(int u=0; u<intermediary.size(); u++ ) {
           
            triToRaster.add(intermediary.get(u));
            
/*            triToRaster.get(triToRaster.size() - 1).P[0] = intermediary.get(u).P[0];
            triToRaster.get(triToRaster.size() - 1 ).P[1] = intermediary.get(u).P[1];
            triToRaster.get(triToRaster.size() - 1 ).P[2] = intermediary.get(u).P[2];
            
            triToRaster.get(triToRaster.size() - 1 ).R = intermediary.get(u).R;
            triToRaster.get(triToRaster.size() - 1 ).G = intermediary.get(u).G;
            triToRaster.get(triToRaster.size() - 1 ).B = intermediary.get(u).B;
            triToRaster.get(triToRaster.size() - 1 ).dp = intermediary.get(u).dp;
*/            
            
          }     
        }
        
        nNewTriangles = triToRaster.size();
        
      }
      
      for(int k=0; k<triToRaster.size(); k++) {
        
//        println(triToRaster.get(k).R + " " + triToRaster.get(k).G + " " + triToRaster.get(k).B);
        
        fill(triToRaster.get(k).dp*triToRaster.get(k).R+64,triToRaster.get(k).dp*triToRaster.get(k).G+64,triToRaster.get(k).dp*triToRaster.get(k).B+64);
        strokeWeight(1);
        stroke(triToRaster.get(k).dp*triToRaster.get(k).R+64,triToRaster.get(k).dp*triToRaster.get(k).G+64,triToRaster.get(k).dp*triToRaster.get(k).B+64);
      
        beginShape();
        vertex(triToRaster.get(k).P[0].x,triToRaster.get(k).P[0].y);
        vertex(triToRaster.get(k).P[1].x,triToRaster.get(k).P[1].y);
        vertex(triToRaster.get(k).P[2].x,triToRaster.get(k).P[2].y);
        endShape(CLOSE);
      
      
/*        stroke(0);
        line(triToRaster.get(k).P[0].x,triToRaster.get(k).P[0].y, triToRaster.get(k).P[1].x,triToRaster.get(k).P[1].y);
        line(triToRaster.get(k).P[1].x,triToRaster.get(k).P[1].y, triToRaster.get(k).P[2].x,triToRaster.get(k).P[2].y);
        line(triToRaster.get(k).P[2].x,triToRaster.get(k).P[2].y, triToRaster.get(k).P[0].x,triToRaster.get(k).P[0].y);*/

      
        }
    
    }
    
     println(frameRate);
}

void keyPressed() {
 
  if (keyCode == UP) {
      is_Up = true;
  } else if (keyCode == DOWN) {
      is_Down = true;  
  }
  
  if (keyCode == LEFT) {
      is_Left = true;
  } else if (keyCode == RIGHT) {
      is_Right = true;      
  }
 
  if (keyCode == 'W') {
      is_W = true;
  } else if (keyCode == 'S') {
      is_S = true;
  }
  
  if (keyCode == 'A') {
      is_A = true;
  } else if (keyCode == 'D') {
      is_D = true;
  }
  
}


void keyReleased() {
  
  if (keyCode == UP) {
      is_Up = false;
  } else if (keyCode == DOWN) {
      is_Down = false;  
  }
  
  if (keyCode == LEFT) {
      is_Left = false;
  } else if (keyCode == RIGHT) {
      is_Right = false;    
  }
 
  if (keyCode == 'W') {
      is_W = false;
  } else if (keyCode == 'S') {
      is_S = false;
  }
  
  if (keyCode == 'A') {
      is_A = false;
  } else if (keyCode == 'D') {
      is_D = false;
  }
  
}
