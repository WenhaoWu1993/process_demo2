ParticleSystem ps;
color backgroundColor = #030017;
PImage texts;

/* ------------------------------------------
kind 0: have not viewed the ad
kind 1: have viewed the ad but not clicked
kind 2: clicked the ad but not converted
kind 3: converted
--------------------------------------------- */
color[] colors = {#ffffff, #0057b9, #00a23f, #da7900};;
float[] destinations = {200, 350, 500, 695};

int[] kindPool = new int[100];
float[] props = {0.4, 0.1, 0.1, 0.4};
String[] titles = {""};

void setup() {
  size(500, 700);
  pixelDensity(2);
  ps = new ParticleSystem(50);
  
  for(int i = 0; i < 100; i++) {
    if(i < props[0] * 100) {
      kindPool[i] = 0;
    } else if(i < (props[0] + props[1]) * 100) {
      kindPool[i] = 1;
    } else if(i < (props[0] + props[1] + props[2]) * 100) {
      kindPool[i] = 2;
    } else {
      kindPool[i] = 3;
    }
  }
  
  //texts = loadImage("texts.png");
  //println(kindPool);
  //GUI();
}

void GUI() {
  
  noFill();
  //stroke(255, 50);
  
  //line(0, 45, width, 45);
  for(int i = 0; i < 4; i++) {
    stroke(255, 10);
    line(0, destinations[i], width, destinations[i]);
    
  }
  
  //image(texts, 0, 0);
}

void keyPressed() {
  saveFrame("screenShot.png");
}

void draw() {
  noStroke();
  fill(backgroundColor, 30);
  rect(0, 0, width, height);
  
  GUI();
  int i = floor(random(0, 100));
  ps.addParticle(kindPool[i]);
  ps.run();
  
  //println(ps.particles.size());
}

class ParticleSystem {
  ArrayList<Particle> particles = new ArrayList<Particle>();
  float y_height;
  
  ParticleSystem(float _y) {
    y_height = _y;
  }
  
  void addParticle(int _kind) {
    particles.add(new Particle(y_height, _kind));
  }
  
  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }    
  }
}

class Particle {
  PVector pos, vel, acc;
  float lifeSpan;
  int kind;
  color currentColor;
  
  Particle(float y, int _kind) {
    kind = _kind;
    float a = width;
    float b = width;
    for(int i = 0; i <= kind; i++) {
      a -= props[i] * width;
      b = a + props[i] * width;
    }
    float x = random(a, b);
    
    pos = new PVector(x, y);
    
    //float xs = map((width / 2) - x, -width / 2, width / 2, -0.8, 0.8);
    float xs = map(x, 2, width, 0, -1);
    xs = random(xs * 0.9, xs * 1.1);
    vel = new PVector(xs, 0);
    
    acc = new PVector(0, 0.01);
    lifeSpan = 255.0;
    currentColor = colors[0];
  }
  
  void run() {
    update();
    display();
  }
  
  void update() {
    vel.add(acc);
    pos.add(vel);
    
    //fading
    if(kind > 0) {
      if(pos.y > destinations[kind - 1]) {
        if(kind != 3) lifeSpan = map(pos.y - destinations[kind - 1], 0, 150, 255, -0.5);
        else lifeSpan = map(pos.y - destinations[kind - 1], 0, 200, 255, -0.5);
      }
    } else {
      lifeSpan = map(pos.y - 50, 0, 150, 255, -0.5);
    }
    
    if(vel.y > 0 && pos.y > destinations[0]) {
      int i = 2;
      while(pos.y < destinations[i]) {
        i--;
      }
      float amt = map(pos.y - destinations[i], 0, 100, 0, 1);
      currentColor = lerpColor(colors[i], colors[i + 1], amt);
    }
  }
  
  void display() {
    stroke(currentColor, lifeSpan);
    fill(currentColor, lifeSpan);
    ellipse(pos.x, pos.y, 3, 3);
  }
  
  boolean isDead() {
    return lifeSpan < 0.0;
  }
}