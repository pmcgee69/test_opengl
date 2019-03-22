unit Tri;
interface
uses
  OpenGL, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;
type
  TForm1 = class(TForm)
    Timer1 :  TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    procedure Draw;   //Draws an OpenGL scene on request
    procedure Draw2;
    procedure Draw3;
  public
    class var angle : single;
  end;
var
  Form1 : TForm1;

implementation
{$R *.DFM}

procedure setupPixelFormat(DC:HDC);
const
  pfd: TPIXELFORMATDESCRIPTOR = (nSize: sizeof(TPIXELFORMATDESCRIPTOR); // size
    nVersion: 1;                                           // version
    dwFlags: PFD_SUPPORT_OPENGL or PFD_DRAW_TO_WINDOW or PFD_DOUBLEBUFFER;
                                                           // support double-buffering
    iPixelType: PFD_TYPE_RGBA;                             // color type
    cColorBits: 24;                                        // preferred color depth
    cRedBits: 0; cRedShift: 0;                             // color bits (ignored)
    cGreenBits: 0; cGreenShift: 0; cBlueBits: 0; cBlueShift: 0; cAlphaBits: 0;
    cAlphaShift: 0;                                        // no alpha buffer
    cAccumBits: 0; cAccumRedBits: 0;                       // no accumulation buffer,
    cAccumGreenBits: 0;                                    // accum bits (ignored)
    cAccumBlueBits: 0; cAccumAlphaBits: 0; cDepthBits: 16; // depth buffer
    cStencilBits: 0;                                       // no stencil buffer
    cAuxBuffers: 0;                                        // no auxiliary buffers
    iLayerType: PFD_MAIN_PLANE;                            // main layer
    bReserved: 0; dwLayerMask: 0; dwVisibleMask: 0; dwDamageMask: 0;
                                                           // no layer, visible, damage masks
  );
var pixelFormat:integer;

begin
   pixelFormat := ChoosePixelFormat(DC, @pfd);
   if (pixelFormat = 0) then
        exit;
   if (SetPixelFormat(DC, pixelFormat, @pfd) <> TRUE) then
        exit;
end;

procedure GLInit;
begin  {
   // set viewing projection
   glMatrixMode(GL_PROJECTION);
   glFrustum(-0.1, 0.1, -0.1, 0.1, 0.3, 25.0);
   // position viewer
   glMatrixMode(GL_MODELVIEW);
   glEnable(GL_DEPTH_TEST);  }
end;

procedure GLInit2;
const
   light0_position: TGLArrayf4 = ( -8.0, 8.0, -16.0, 0.0);
   ambient        : TGLArrayf4 = (  0.3, 0.3,   0.3, 0.3);
begin
   // set viewing projection
   glMatrixMode(GL_PROJECTION);
   glFrustum(-0.1, 0.1, -0.1, 0.1, 0.3, 25.0);
   // position viewer */
   glMatrixMode(GL_MODELVIEW);
   glEnable(GL_DEPTH_TEST);
   // set lights
   glEnable(GL_LIGHTING);
   glLightfv(GL_LIGHT0, GL_POSITION, @light0_position);
   glLightfv(GL_LIGHT0, GL_AMBIENT, @ambient);
   glEnable(GL_LIGHT0);
end;

procedure TForm1.FormCreate(Sender: TObject);
var DC:HDC;
    RC:HGLRC;
    i:integer;
begin
   DC:=GetDC(Handle);        //Actually, you can use any windowed control here
   SetupPixelFormat(DC);
   RC:=wglCreateContext(DC); //makes OpenGL window out of DC
   wglMakeCurrent(DC, RC);   //makes OpenGL window active
   //GLInit;                   //initialize OpenGL
   GLInit2;
   angle := 0.0;
end;

function getNormal(p1,p2,p3:TGLArrayf3):TGLArrayf3;
var a,b:TGLArrayf3;
begin
   //make two vectors
   a[0]:=p2[0]-p1[0]; a[1]:=p2[1]-p1[1]; a[2]:=p2[2]-p1[2];
   b[0]:=p3[0]-p1[0]; b[1]:=p3[1]-p1[1]; b[2]:=p3[2]-p1[2];
   //calculate cross-product
   result[0]:=a[1]*b[2]-a[2]*b[1];
   result[1]:=a[2]*b[0]-a[0]*b[2];
   result[2]:=a[0]*b[1]-a[1]*b[0];
end;

procedure TForm1.Draw;
const S=1.0; D=5.0;
begin       {
   glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
   glLoadIdentity;
   glTranslatef(0.0, 0.0, -12.0);
   glBegin(GL_TRIANGLES);
   glVertex3f( -S, 0, D); glVertex3f(S, 0, D); glVertex3f(0, S, D);
   glEnd;
   SwapBuffers(wglGetCurrentDC);  }
end;

procedure TForm1.Draw2;
const D=1.5;
   H1=D/1.732;
   H2=D*1.732-H1; // D/H = tg(30) = 1/sqrt(3)
   HY=3.0;
const //vertexes
   a1:TGLArrayf3=(-D, 0, -H1); //bootom left
   a2:TGLArrayf3=( D, 0, -H1); //bootom right
   a3:TGLArrayf3=( 0, 0,  H2); //bootom back
   a4:TGLArrayf3=( 0, HY, 0);  //top
begin {
   glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
      glLoadIdentity;
      glTranslatef(0.0, 0.0, -12.0);
      glBegin(GL_TRIANGLES);
      glVertex3fv(@a1); glVertex3fv(@a3); glVertex3fv(@a2);
      glVertex3fv(@a1); glVertex3fv(@a2); glVertex3fv(@a4);
      glVertex3fv(@a2); glVertex3fv(@a3); glVertex3fv(@a4);
      glVertex3fv(@a3); glVertex3fv(@a1); glVertex3fv(@a4);
   glEnd;
   SwapBuffers(wglGetCurrentDC);  }
end;

procedure TForm1.Draw3;
const D=1.5;
      H1=D/1.732;
      H2=D*1.732-H1; // D/H = tg(30) = 1/sqrt(3)
      HY=3.0;
const //vertexes
      a1:TGLArrayf3=(-D, 0, -H1);
      a2:TGLArrayf3=(D, 0, -H1);
      a3:TGLArrayf3=(0, 0, H2);
      a4:TGLArrayf3=(0, HY, 0);
var   n1, n2, n3, n4: TGLArrayf3;   //normals
      rot, x, y, z  : single;
begin
   n1 := getNormal(a1,a3,a2);
   n2 := getNormal(a1,a2,a4);
   n3 := getNormal(a2,a3,a4);
   n4 := getNormal(a3,a1,a4);
   glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
   glEnable(GL_NORMALIZE);
   glShadeModel(GL_SMOOTH);
   glCullFace(GL_BACK);
   glLoadIdentity;
   glTranslatef(0.0, -1.0, -10.0);
   glRotatef(angle, 0.5, 1.0, 0.5);

   // pyramid
   glBegin(GL_TRIANGLES);
     glNormal3fv(@n1);
     glVertex3fv(@a1); glVertex3fv(@a2); glVertex3fv(@a3);
     glNormal3fv(@n2);
     glVertex3fv(@a1); glVertex3fv(@a2); glVertex3fv(@a4);
     glNormal3fv(@n3);
     glVertex3fv(@a2); glVertex3fv(@a3); glVertex3fv(@a4);
     glNormal3fv(@n4);
     glVertex3fv(@a3); glVertex3fv(@a1); glVertex3fv(@a4);
   glEnd;

   // a couple of lines
   glLineWidth(16.0);
   glBegin(GL_LINES);
     glVertex3f(-1.5, 1.0, 0.0); // start at -1,0,0 (x,y,z)
     glVertex3f( 1.5, 1.0, 0.0); // and draw to 1,0,0
     glVertex3f(-1.5, 1.0, 1.0); // start at -1,0,0 (x,y,z)
     glVertex3f( 1.5, 1.0, 0.0); // and draw to 1,0,0
   glEnd;
   {
   // starburst       // All lines lie in the xy plane.
   glLineWidth(2.0);
   glBegin(GL_LINES);
     z   := 0.0;
     rot := 0.0;
     while rot <= pi do begin
       x := 2.0 * sin(rot);        y := 2.0 * cos(rot);        // First endpoint of line
       glVertex3f(x, y, z);
       x := 2.0 * sin(rot + pi);   y := 2.0 * cos(rot + pi);   // Second endpoint of line
       glVertex3f(x, y, z);
       rot := rot + (pi/20);                                   // next line
     end;
   glEnd();
   }
   SwapBuffers(wglGetCurrentDC);
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
   //Draw;
   //Draw2;
   Draw3;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 angle:=angle+1.0;
 Draw3;
end;

end.
