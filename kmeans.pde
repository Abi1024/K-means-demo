/* Copyrighted 2016 by Abiyaz Chowdhury
Welcome to my K-means clustering tutorial. This algorithm generates clusters of data from Gaussians with random parameters, and then performs the k-means algorithm on them. You may specify the number of points 
from each Gaussian, as well the number of Gaussians used. Hit the step button to step through the algorithm's iterations.
*/ 

// tunable parameters
int point_size = 8;
int num_points = 50;
int num_clusters = 3;
float std = 25;

//non-tunable parameters
int x_origin = 200;
int y_origin = 700;
int phase = 0;
ArrayList<ArrayList<Point>> mixture = new ArrayList<ArrayList<Point>>();
ArrayList<ArrayList<Point>> clusters = new ArrayList<ArrayList<Point>>();
ArrayList<Point> centroids = new ArrayList<Point>();
ArrayList<ArrayList<Integer>> colors = new ArrayList<ArrayList<Integer>>();
PFont myFont;
import java.util.*;

void setup() {
  strokeWeight(1);
  size(1000, 800);
  myFont = createFont("Verdana", 12);
  textFont(myFont, 12);
  for (int i = 0; i < num_clusters; i++) {
    float mean_x = randrange(30, 470);
    float mean_y = randrange(30, 470);
    //println("cluster: " + i + " mean_x: " + mean_x + " mean_y: " + mean_y);

    ArrayList<Point> points = new ArrayList();
    ArrayList<Integer> rgb = new ArrayList();
    rgb.add((int)random(255));
    rgb.add((int)random(255));
    rgb.add((int)random(255));
    for (int j = 0; j < num_points; j ++) { 
      float x = randomGaussian()*std+mean_x;
      float y = randomGaussian()*std+mean_y;
      points.add(new Point(x, y));
    }
    mixture.add(points);
    colors.add(rgb);
  }
}

void draw() {
  background(0);
  stroke(255);
  fill(0);
  rect(800, 200, 100, 50);
  fill(255);
  textFont(myFont, 12);
  text("STEP", 830, 225);
  line(x_origin, y_origin, x_origin+500, y_origin); //x-axis
  line(x_origin, y_origin-500, x_origin+500, y_origin-500); //x-axis
  line(x_origin, y_origin, x_origin, y_origin-500); //y-axis
  line(x_origin+500, y_origin, x_origin+500, y_origin-500); //y-axis
  if (phase == 0) {
    for (int i = 0; i < num_clusters; i++) {
      fill(255);
      //fill(colors.get(i).get(0), colors.get(i).get(1), colors.get(i).get(2));
      for (int j = 0; j < num_points; j ++) { 
        mixture.get(i).get(j).display_Point();
      }
    }
  } else {
    for (int i = 0; i < num_clusters; i++) {
      stroke(255);
      strokeWeight(1);
      fill(colors.get(i).get(0), colors.get(i).get(1), colors.get(i).get(2));
      for (int j = 0; j < clusters.get(i).size(); j ++) { 
        clusters.get(i).get(j).display_Point();
      }
      stroke(colors.get(i).get(0), colors.get(i).get(1), colors.get(i).get(2));
      strokeWeight(4);
      centroids.get(i).display_Point2();
      strokeWeight(1);
    }
  }
  textFont(myFont, 40);
  fill(255);
  text("Abi's K-means clustering", 100,100);
}

class Point {
  float x;
  float y;
  public Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
  public void display_Point() {
    if (inside_boundary()) {
      ellipse(x_origin+x, y_origin-y, point_size, point_size);
    }
  }
  public void display_Point2() {
    if (inside_boundary()) {
      line(x_origin+x-point_size, y_origin-y-point_size, x_origin+x+point_size, y_origin-y+point_size);
      line(x_origin+x-point_size, y_origin-y+point_size, x_origin+x+point_size, y_origin-y-point_size);
    }
  }
  public boolean inside_boundary() {
    if (x > 500-point_size) {
      return false;
    }
    if (x < point_size) {
      return false;
    }
    if (y > 500-point_size) {

      return false;
    }
    if (y < point_size) {
      return false;
    }
    return true;
  }
}

float distance(Point p1, Point p2) { //returns squared Euclidean distance
  return sqrt((p1.x-p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y));
}

float randrange(float x, float y) {
  return random(y-x)+x;
}

void step() {
  if (phase == 0) {
    for (int i = 0; i < num_clusters; i++) {
      float centroid_x = randrange(30, 470);
      float centroid_y = randrange(30, 470);
      centroids.add(new Point(centroid_x, centroid_y));
      clusters.add(new ArrayList<Point>());
    }
    //println("Centroids initialized");
    for (int i = 0; i < num_clusters; i++) {
      //println("Cluster: " + i);
      for (int j = 0; j < num_points; j++) {
        float minimum = 9999;
        int index = -1;
        //println("Point: " + mixture.get(i).get(j).x + " " + mixture.get(i).get(j).y);
        for (int k = 0; k < num_clusters; k++) {
          //println("distance from cluster " + k + " : " + distance(mixture.get(i).get(j), centroids.get(k)) + " minimum: " + minimum +  " centroid " + k + " : " + centroids.get(k).x + " " + centroids.get(k).y);
          if (distance(mixture.get(i).get(j), centroids.get(k)) < minimum) {
            minimum = distance(mixture.get(i).get(j), centroids.get(k));
            index = k;
          }
        }
        //println("index: " + index);
        //now assign to the kth cluster
        clusters.get(index).add(mixture.get(i).get(j));
      }
    }
    phase = 1;
  } else if (phase == 1) { //recompute centroids
    for (int i = 0; i < num_clusters; i++) {
      float x_total = 0;
      float y_total = 0;
      if (clusters.get(i).size() == 0) {
        float centroid_x = randrange(30, 470);
        float centroid_y = randrange(30, 470);
        centroids.set(i,new Point(centroid_x, centroid_y));
      } else {
        for (int j = 0; j < clusters.get(i).size(); j++) {
          x_total += clusters.get(i).get(j).x; 
          y_total += clusters.get(i).get(j).y;
        }
        x_total /= clusters.get(i).size();
        y_total /= clusters.get(i).size();
        centroids.set(i, new Point(x_total, y_total));
      }
    }
    phase = -1;
  } else { //=========================================
    for (int i = 0; i < num_clusters; i++){
       mixture.get(i).clear(); 
    }
    for (int i = 0; i < num_clusters; i++) { //we wish to assign each point again using the centroid. the points will come from clusters and be assigned to mixture
      for (int j = 0; j < clusters.get(i).size(); j++) {
        float minimum = 9999;
        int index = -1;
        //println("Point: " + mixture.get(i).get(j).x + " " + mixture.get(i).get(j).y);
        for (int k = 0; k < num_clusters; k++) {
          //println("distance from cluster " + k + " : " + distance(mixture.get(i).get(j), centroids.get(k)) + " minimum: " + minimum +  " centroid " + k + " : " + centroids.get(k).x + " " + centroids.get(k).y);
          if (distance(clusters.get(i).get(j), centroids.get(k)) < minimum) {
            minimum = distance(clusters.get(i).get(j), centroids.get(k));
            index = k;
          }
        }
        //println("index: " + index);
        //now assign to the kth cluster
        mixture.get(index).add(clusters.get(i).get(j));
      }
    }
    for (int i = 0; i < num_clusters; i++){
        clusters.get(i).clear();
        for (int j = 0; j < mixture.get(i).size(); j++){
           clusters.get(i).add(mixture.get(i).get(j)); 
        }
    }
    phase = 1;
  }
}//===============================
void mousePressed() {
  int x = mouseX - x_origin;
  int y = y_origin - mouseY ;
  //println(x+" " + y);
  if ((mouseX > 800) && (mouseX < 900) && (mouseY > 200) && (mouseY < 250)) {
    step();
    //println("phase: " + phase);
  }
}