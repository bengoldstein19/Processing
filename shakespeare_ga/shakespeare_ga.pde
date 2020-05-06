float mutationRate = 0.01;    // Mutation rate
int totalPopulation = 150;      // Total Population

DNA[] population;             // Array to hold the current population
ArrayList<DNA> matingPool;    // ArrayList which we will use for our "mating pool"
String target;                // Target phrase

PFont f;

void setup() {
  size(800, 200);
  target = "to be or not to be";

  population = new DNA[totalPopulation];

  for (int i = 0; i < population.length; i++) {
    population[i] = new DNA(target.length());
  }
  
  f = createFont("Courier",12,true);
}

void draw() {
  for (int i = 0; i < population.length; i++) {
    population[i].calcFitness(target);
  }

  ArrayList<DNA> matingPool = new ArrayList<DNA>();  // ArrayList which we will use for our "mating pool"

  for (int i = 0; i < population.length; i++) {
    int nnnn = int(population[i].fitness * 100);  // Arbitrary multiplier, we can also use monte carlo method
    for (int j = 0; j <nnnn; j++) {              // and pick two random numbers
      matingPool.add(population[i]);
    }
  }

  for (int i = 0; i < population.length; i++) {
    int a = int(random(matingPool.size()));
    int b = int(random(matingPool.size()));
    DNA partnerA = matingPool.get(a);
    DNA partnerB = matingPool.get(b);
    DNA child = partnerA.crossover(partnerB);
    child.mutate(mutationRate);
    population[i] = child;
  }
  
  background(255);
  fill(0);
  String everything = "";
  for (int i = 0; i < population.length; i++) {
    everything += population[i].getPhrase() + "     ";
  }
  textFont(f,12);
  text(everything,10,10,width,height);

  
}

class DNA {

  // The genetic sequence
  char[] genes;
  
  float fitness;
  
  // Constructor (makes a random DNA)
  DNA(int num) {
    genes = new char[num];
    for (int i = 0; i < genes.length; i++) {
      genes[i] = (char) random(32,128);  // Pick from range of chars
    }
  }
  
  // Converts character array to a String
  String getPhrase() {
    return new String(genes);
  }
  
  // Fitness function (returns floating point % of "correct" characters)
  void calcFitness (String target) {
     int score = 0;
     for (int i = 0; i < genes.length; i++) {
        if (genes[i] == target.charAt(i)) {
          score++;
        }
     }
     fitness = (float)score / (float)target.length();
  }
  
  // Crossover
  DNA crossover(DNA partner) {
    // A new child
    DNA child = new DNA(genes.length);
    
    int midpoint = int(random(genes.length)); // Pick a midpoint
    
    // Half from one, half from the other
    for (int i = 0; i < genes.length; i++) {
      if (i > midpoint) child.genes[i] = genes[i];
      else              child.genes[i] = partner.genes[i];
    }
    return child;
  }
  
  // Based on a mutation probability, picks a new random character
  void mutate(float mutationRate) {
    for (int i = 0; i < genes.length; i++) {
      if (random(1) < mutationRate) {
        genes[i] = (char) random(32,128);
      }
    }
  }
}