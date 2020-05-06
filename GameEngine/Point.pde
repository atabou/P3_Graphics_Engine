
class Point {
 
  float x,y,z,w;
  
  Point() {
    x = 0;
    y = 0;
    z = 0;
    w = 1;
  }
  
  Point multMat(Matrix A) {
   
    Point M = new Point();
    
    M.x = x * A.m[0][0] + y * A.m[1][0] + z * A.m[2][0] + w * A.m[3][0];

    M.y = x * A.m[0][1] + y * A.m[1][1] + z * A.m[2][1] + w * A.m[3][1];

    M.z = x * A.m[0][2] + y * A.m[1][2] + z * A.m[2][2] + w * A.m[3][2];

    M.w = x * A.m[0][3] + y * A.m[1][3] + z * A.m[2][3] + w * A.m[3][3];
    
    return M;
    
  }
  
}

Point Vector_Add(Point v1, Point v2) {

  Point A = new Point();
  
  A.x = v1.x + v2.x;
  A.y = v1.y + v2.y;
  A.z = v1.z + v2.z;
  
  return A;

}


Point Vector_Sub(Point v1, Point v2) {

  Point A = new Point();
  
  A.x = v1.x - v2.x;
  A.y = v1.y - v2.y;
  A.z = v1.z - v2.z;
  
  return A;

}



Point Vector_Mul(float k, Point v) {

  Point A = new Point();
  
  A.x = k*v.x;
  A.y = k*v.y;
  A.z = k*v.z;
  
  return A;

}


Point Vector_Div(float k, Point v) {

  Point A = new Point();
  
  A.x = v.x/k;
  A.y = v.y/k;
  A.z = v.z/k;
  
  return A;

}


float Vector_DotProduct(Point v1, Point v2) {

  float dp = 0;
  
  dp = v1.x*v2.x + v1.y*v2.y + v1.z * v2.z;
  
  return dp;

}



float Vector_Length(Point v) {

    return sqrt(Vector_DotProduct(v, v));

}



Point Vector_Normalise(Point v) {

    Point A = new Point();
  
    float l = Vector_Length(v);
    A = Vector_Div(l, v);

    return A;

}



Point Vector_CrossProduct(Point v1, Point v2) {

    Point v = new Point();

    v.x = v1.y * v2.z - v1.z * v2.y;
    v.y = v1.z * v2.x - v1.x * v2.z;
    v.z = v1.x * v2.y - v1.y * v2.x;

    return v;

}

Point Vector_IntersectPlane(Point plane_p, Point plane_n, Point lineStart, Point lineEnd) {
  
  plane_n = Vector_Normalise(plane_n);
  
  float plane_d = - Vector_DotProduct(plane_n, plane_p);
  
  float ad = Vector_DotProduct(lineStart, plane_n);
  
  float bd = Vector_DotProduct(lineEnd, plane_n);
  
  float t = (-plane_d - ad) / (bd - ad);
  
  Point lineStartToEnd = Vector_Sub(lineEnd, lineStart);
  
  Point lineToIntersect = Vector_Mul(t, lineStartToEnd);
  
  return Vector_Add(lineStart, lineToIntersect);
  
}

// Return signed shortest distance from point to plane, plane normal must be normalised

float Ndist (Point p, Point plane_n, Point plane_p) {
 
  Point n = Vector_Normalise(p);
  return (plane_n.x * p.x + plane_n.y * p.y + plane_n.z * p.z - Vector_DotProduct(plane_n, plane_p));
  
}
