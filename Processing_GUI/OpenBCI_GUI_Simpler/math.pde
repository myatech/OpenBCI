
//compute the standard deviation
float std(float[] data) {
  //calc mean
  float ave = mean(data);
  
  //calc sum of squares relative to mean
  float val = 0;
  for (int i=0; i < data.length; i++) {
    val += pow(data[i]-ave,2);
  }
  
  // divide by n to make it the average
  val /= data.length;
  
  //take square-root and return the standard
  return (float)Math.sqrt(val);
}


float mean(float[] data) {
  return mean(data,data.length);
}

//////////////////////////////////////////////////
//
// Some functions to implement some math and some filtering.  These functions
// probably already exist in Java somewhere, but it was easier for me to just
// recreate them myself as I needed them.
//
// Created: Chip Audette, Oct 2013
//
//////////////////////////////////////////////////

float mean(float[] data, int Nback) {
  return sum(data,Nback)/Nback;
}

float mean(float[] data, int[] inds) {
  return sum(data,inds) / (inds[1]-inds[0]+1);
}

float meanFFT(FFT data, float[] bounds_Hz) {
  float freq_Hz=0;
  float sum=0;
  int count=0;
  for (int i=0; i<data.specSize();i++) {
    freq_Hz = data.indexToFreq(i);
    if ((freq_Hz >= bounds_Hz[0]) & (freq_Hz <= bounds_Hz[1])) {
      sum += data.getBand(i);
      count++;
    }
  }
  return (sum/((float)count));
}

float sum(float[] data) {
  return sum(data, data.length);
}

float sum(float[] data, int[] inds) {
  float sum = 0;
  for (int i=min(inds[0],data.length-1); i < max(inds[1],data.length); i++) {
    sum+= data[i];
  }
  return sum;
}

float sum(float[] data, int Nback) {
  float sum = 0;
  if (Nback > 0) {
    for (int i=(data.length)-Nback; i < data.length; i++) {
      sum += data[i];
    }
  }
  return sum;
}

float log10(float val) {
  return (float)Math.log10(val);
}

float filterWEA_1stOrderIIR(float[] filty, float learn_fac, float filt_state) {
  float prev = filt_state;
  for (int i=0; i < filty.length; i++) {
    filty[i] = prev*(1-learn_fac) + filty[i]*learn_fac;
    prev = filty[i]; //save for next time
  }
  return prev;
}

void filterIIR(double[] filt_b, double[] filt_a, float[] data) {
  int Nback = filt_b.length;
  double[] prev_y = new double[Nback];
  double[] prev_x = new double[Nback];
  
  //step through data points
  for (int i = 0; i < data.length; i++) {   
    //shift the previous outputs
    for (int j = Nback-1; j > 0; j--) {
      prev_y[j] = prev_y[j-1];
      prev_x[j] = prev_x[j-1];
    }
    
    //add in the new point
    prev_x[0] = data[i];
    
    //compute the new data point
    double out = 0;
    for (int j = 0; j < Nback; j++) {
      out += filt_b[j]*prev_x[j];
      if (j > 0) {
        out -= filt_a[j]*prev_y[j];
      }
    }
    
    //save output value
    prev_y[0] = out;
    data[i] = (float)out;
  }
}
    

void removeMean(float[] filty, int Nback) {
  float meanVal = mean(filty,Nback);
  for (int i=0; i < filty.length; i++) {
    filty[i] -= meanVal;
  }
}


