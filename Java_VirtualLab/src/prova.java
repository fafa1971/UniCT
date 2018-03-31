import java.awt.*;

class prova {
    Frame myFrame;
    Graphics g;

    prova() {
        myFrame = new Frame("Superpollo");
        myFrame.reshape(100,100,200,200);
        myFrame.show();
//        g = myFrame.getGraphics();
        myFrame.drawLine(0,0,100,100);
    }

    public static void main(String args[]) {
        prova p = new prova();
    }
}
