
class Triangle {
  
  Point[] P;
  float dp;
  float R,G,B;
  
  Triangle () {
    
    dp = 0;
    
    P = new Point[3];
    
    R = 191; G = 191; B = 191;
    
    for (int i=0; i<3; i++) {
    
      P[i] = new Point();
    
    }
    
  }
  
}

ArrayList<Triangle> Triangle_ClipAgainstPlane(Point plane_p, Point plane_n, Triangle in_tri, Triangle out_tri1, Triangle out_tri2) {
  
  // make sure the plane is indeed normal
  
  plane_n = Vector_Normalise(plane_n);
  
  // Create two temporary storage arrays to classify points either side of plane
  // If distance sign is positive, point lies on "inside" of plane
  
  Point[] inside_points = new Point[3];  int nInsidePointCount = 0;
  Point[] outside_points = new Point[3];  int nOutsidePointCount = 0;
  
  // Get signed distance of each point in triangle to plane
  
  float d0 = Ndist(in_tri.P[0], plane_n, plane_p);
  float d1 = Ndist(in_tri.P[1], plane_n, plane_p);
  float d2 = Ndist(in_tri.P[2], plane_n, plane_p);
  
  
  if (d0 >= 0) { 
    inside_points[nInsidePointCount++] = in_tri.P[0]; 
  } else { 
    outside_points[nOutsidePointCount++] = in_tri.P[0]; 
  }

  if (d1 >= 0) { 
    inside_points[nInsidePointCount++] = in_tri.P[1]; 
  } else { 
    outside_points[nOutsidePointCount++] = in_tri.P[1]; 
  } 
  
  if (d2 >= 0) { 
    inside_points[nInsidePointCount++] = in_tri.P[2]; 
  } else { 
    outside_points[nOutsidePointCount++] = in_tri.P[2]; 
  }
  
  
  
  // Now classify triangle points, and break the input triangle into 
  // smaller output triangles if required. There are four possible
  // outcomes...

  int n = 0;
  ArrayList<Triangle> returnTriangle = new ArrayList<Triangle>();

  if (nInsidePointCount == 0) {

    // All points lie on the outside of plane, so clip whole triangle
    // It ceases to exist

      n = 0; // No returned triangles are valid
     
  }
  
 

  if (nInsidePointCount == 3) {

    // All points lie on the inside of plane, so do nothing
    // and allow the triangle to simply pass through
    
    returnTriangle.add(new Triangle());
    
    returnTriangle.get(returnTriangle.size()-1).P[0].x = in_tri.P[0].x;
    returnTriangle.get(returnTriangle.size()-1).P[0].y = in_tri.P[0].y;
    returnTriangle.get(returnTriangle.size()-1).P[0].z = in_tri.P[0].z;
    
    returnTriangle.get(returnTriangle.size()-1).P[1].x = in_tri.P[1].x;
    returnTriangle.get(returnTriangle.size()-1).P[1].y = in_tri.P[1].y;
    returnTriangle.get(returnTriangle.size()-1).P[1].z = in_tri.P[1].z;
    
    returnTriangle.get(returnTriangle.size()-1).P[2].x = in_tri.P[2].x;
    returnTriangle.get(returnTriangle.size()-1).P[2].y = in_tri.P[2].y;
    returnTriangle.get(returnTriangle.size()-1).P[2].z = in_tri.P[2].z;
    
    returnTriangle.get(returnTriangle.size()-1).R = in_tri.R;
    returnTriangle.get(returnTriangle.size()-1).G = in_tri.G;
    returnTriangle.get(returnTriangle.size()-1).B = in_tri.B;
    returnTriangle.get(returnTriangle.size()-1).dp = in_tri.dp;
    
//    out_tri1 = in_tri;

//    n = 1; // Just the one returned original triangle is valid

  }

  

  if (nInsidePointCount == 1 && nOutsidePointCount == 2) {

    // Triangle should be clipped. As two points lie outside
    // the plane, the triangle simply becomes a smaller triangle

    // Copy appearance info to new triangle
    
    returnTriangle.add(new Triangle());
    
    returnTriangle.get(returnTriangle.size()-1).dp = in_tri.dp;
    
    returnTriangle.get(returnTriangle.size()-1).G = 0;
    returnTriangle.get(returnTriangle.size()-1).B = 0;
    
//    out_tri1.dp =  in_tri.dp;
    
    // The inside point is valid, so keep that...

//    out_tri1.P[0] = inside_points[0];

    // but the two new points are at the locations where the 
    // original sides of the triangle (lines) intersect with the plane

//    out_tri1.P[1] = Vector_IntersectPlane(plane_p, plane_n, inside_points[0], outside_points[0]);
//    out_tri1.P[2] = Vector_IntersectPlane(plane_p, plane_n, inside_points[0], outside_points[1]);
    
    returnTriangle.get(returnTriangle.size()-1).P[0].x = inside_points[0].x;
    returnTriangle.get(returnTriangle.size()-1).P[0].y = inside_points[0].y;
    returnTriangle.get(returnTriangle.size()-1).P[0].z = inside_points[0].z;
    
    returnTriangle.get(returnTriangle.size()-1).P[1] = Vector_IntersectPlane(plane_p, plane_n, inside_points[0], outside_points[0]); 
    returnTriangle.get(returnTriangle.size()-1).P[2] = Vector_IntersectPlane(plane_p, plane_n, inside_points[0], outside_points[1]);


    n = 1; // Return the newly formed single triangle

  }
  
  

  if (nInsidePointCount == 2 && nOutsidePointCount == 1) {

    // Triangle should be clipped. As two points lie inside the plane,
    // the clipped triangle becomes a "quad". Fortunately, we can
    // represent a quad with two new triangles
    // Copy appearance info to new triangles

//    out_tri1.dp =  in_tri.dp;
//    out_tri2.dp =  in_tri.dp;

    returnTriangle.add(new Triangle());    
    returnTriangle.get(returnTriangle.size()-1).dp = in_tri.dp;
    returnTriangle.get(returnTriangle.size()-1).R = 0;
    returnTriangle.get(returnTriangle.size()-1).B = 0;
    
    returnTriangle.get(returnTriangle.size()-1).P[0].x = inside_points[0].x;
    returnTriangle.get(returnTriangle.size()-1).P[0].y = inside_points[0].y;
    returnTriangle.get(returnTriangle.size()-1).P[0].z = inside_points[0].z;
    
    returnTriangle.get(returnTriangle.size()-1).P[1].x = inside_points[1].x;
    returnTriangle.get(returnTriangle.size()-1).P[1].y = inside_points[1].y;
    returnTriangle.get(returnTriangle.size()-1).P[1].z = inside_points[1].z;
          
    returnTriangle.get(returnTriangle.size()-1).P[2] = Vector_IntersectPlane(plane_p, plane_n, inside_points[0], outside_points[0]);

    

    returnTriangle.add(new Triangle());    
    returnTriangle.get(returnTriangle.size()-1).dp = in_tri.dp;
    returnTriangle.get(returnTriangle.size()-1).R = 0;
    returnTriangle.get(returnTriangle.size()-1).G = 0;
    
    
    
    returnTriangle.get(returnTriangle.size()-1).P[0].x = inside_points[1].x;
    returnTriangle.get(returnTriangle.size()-1).P[0].y = inside_points[1].y;
    returnTriangle.get(returnTriangle.size()-1).P[0].z = inside_points[1].z;
    
    returnTriangle.get(returnTriangle.size()-1).P[1] = returnTriangle.get(returnTriangle.size()-2).P[2];
    
    returnTriangle.get(returnTriangle.size()-1).P[2] = Vector_IntersectPlane(plane_p, plane_n, inside_points[1], outside_points[0]);

    

    // The first triangle consists of the two inside points and a new
    // point determined by the location where one side of the triangle
    // intersects with the plane

//    out_tri1.P[0] = inside_points[0];
//    out_tri1.P[1] = inside_points[1];
//    out_tri1.P[2] = Vector_IntersectPlane(plane_p, plane_n, inside_points[0], outside_points[0]);

    // The second triangle is composed of one of he inside points, a
    // new point determined by the intersection of the other side of the 
    // triangle and the plane, and the newly created point above

//    out_tri2.P[0] = inside_points[1];
//    out_tri2.P[1] = out_tri1.P[2];
//    out_tri2.P[2] = Vector_IntersectPlane(plane_p, plane_n, inside_points[1], outside_points[0]);

    n = 2; // Return two newly formed triangles which form a quad

    }
    
    return returnTriangle;
   
}
