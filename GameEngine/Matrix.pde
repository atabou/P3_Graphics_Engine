
class Matrix {
  
  float m[][];
  
  Matrix () {
    m = new float[4][4];
  }
  
  void Identity() {
    
    m[0][0] = 1;
    m[1][1] = 1;
    m[2][2] = 1;
    m[3][3] = 1;
    
  }
  
  void Matrix_MakeRotationX(float fAngleRad) {
    
    m[0][0] = 1;
    m[1][1] = cos(fAngleRad);
    m[1][2] = sin(fAngleRad);
    m[2][1] = -sin(fAngleRad);
    m[2][2] = cos(fAngleRad);
    m[3][3] = 1;
    
  }
  
  void Matrix_MakeRotationY(float fAngleRad) {
    
    m[0][0] = cos(fAngleRad);
    m[0][2] = sin(fAngleRad);
    m[2][0] = -sin(fAngleRad);
    m[1][1] = 1;
    m[2][2] = cos(fAngleRad);
    m[3][3] = 1;
    
  }
  
  void Matrix_MakeRotationZ(float fAngleRad) {
    
    m[0][0] = cos(fAngleRad);
    m[0][1] = sin(fAngleRad);
    m[1][0] = -sin(fAngleRad);
    m[1][1] = cos(fAngleRad);
    m[2][2] = 1;
    m[3][3] = 1;
    
  }
  
  void Matrix_MakeTranslation(float x, float y, float z) {

    m[0][0] = 1.0;
    m[1][1] = 1.0;
    m[2][2] = 1.0;
    m[3][3] = 1.0;
    m[3][0] = x;
    m[3][1] = y;
    m[3][2] = z;

  }
  
  void Matrix_MakeProjection(float fFovDegrees, float fAspectRatio, float fNear, float fFar) {

    float fFovRad = 1.0f / tan(fFovDegrees * 0.5f / 180.0f * PI);

    m[0][0] = fAspectRatio * fFovRad;
    m[1][1] = fFovRad;
    m[2][2] = fFar / (fFar - fNear);
    m[3][2] = (-fFar * fNear) / (fFar - fNear);
    m[2][3] = 1.0;
    m[3][3] = 0.0;

  }
  
  
}


Matrix Matrix_Multiplication(Matrix m1, Matrix m2) {

    Matrix matrix = new Matrix();

    for (int c = 0; c < 4; c++) {

      for (int r = 0; r < 4; r++) {

        matrix.m[r][c] = m1.m[r][0] * m2.m[0][c] + m1.m[r][1] * m2.m[1][c] + m1.m[r][2] * m2.m[2][c] + m1.m[r][3] * m2.m[3][c];
      }
    }
    
    return matrix;

}

Matrix Matrix_QuickInverse(Matrix m) { // Only for Rotation/Translation Matrices

    Matrix matrix = new Matrix();

    matrix.m[0][0] = m.m[0][0]; 
    matrix.m[0][1] = m.m[1][0]; 
    matrix.m[0][2] = m.m[2][0]; 
    matrix.m[0][3] = 0.0;

    matrix.m[1][0] = m.m[0][1];
    matrix.m[1][1] = m.m[1][1]; 
    matrix.m[1][2] = m.m[2][1]; 
    matrix.m[1][3] = 0.0;

    matrix.m[2][0] = m.m[0][2]; 
    matrix.m[2][1] = m.m[1][2]; 
    matrix.m[2][2] = m.m[2][2]; 
    matrix.m[2][3] = 0.0;

    matrix.m[3][0] = -(m.m[3][0] * matrix.m[0][0] + m.m[3][1] * matrix.m[1][0] + m.m[3][2] * matrix.m[2][0]);
    matrix.m[3][1] = -(m.m[3][0] * matrix.m[0][1] + m.m[3][1] * matrix.m[1][1] + m.m[3][2] * matrix.m[2][1]);
    matrix.m[3][2] = -(m.m[3][0] * matrix.m[0][2] + m.m[3][1] * matrix.m[1][2] + m.m[3][2] * matrix.m[2][2]);
    matrix.m[3][3] = 1.0;

    return matrix;

}

Matrix Matrix_PointAt(Point pos, Point target, Point up) {
  
  // Calculate the forward direction
  
  Point newForward = Vector_Sub(target, pos);
  newForward = Vector_Normalise(newForward);
  
  // Calculate new Up direction

  Point a = Vector_Mul(Vector_DotProduct(up, newForward), newForward);
  Point newUp = Vector_Sub(up, a);
  newUp = Vector_Normalise(newUp);
  
  // New Right direction is easy, its just cross product
  
  Point newRight = Vector_CrossProduct(newUp, newForward);
  
  // Construct Dimensioning and Translation Matrix  

    Matrix matrix = new Matrix();

    matrix.m[0][0] = newRight.x;  
    matrix.m[0][1] = newRight.y;  
    matrix.m[0][2] = newRight.z;  
    matrix.m[0][3] = 0.0f;

    matrix.m[1][0] = newUp.x;    
    matrix.m[1][1] = newUp.y;    
    matrix.m[1][2] = newUp.z;    
    matrix.m[1][3] = 0.0;

    matrix.m[2][0] = newForward.x;  
    matrix.m[2][1] = newForward.y;  
    matrix.m[2][2] = newForward.z;  
    matrix.m[2][3] = 0.0;

    matrix.m[3][0] = pos.x;      
    matrix.m[3][1] = pos.y;      
    matrix.m[3][2] = pos.z;      
    matrix.m[3][3] = 1.0;

    return matrix;
  
}
