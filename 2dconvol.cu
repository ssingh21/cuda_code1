#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <cuda.h>
#include <fstream>
#include <string>
#include <cstdlib>
#include <math.h>
#include <algorithm>
#include <bitset>
#include <iomanip>
 
using namespace std;

__global__ void twodimconvol(float *a, float *h, float *c, int kY, int kX, int dY, int dX,int newx,int newy)
{	
	//Launching X and Y threadIDS for computation
	int x=blockIdx.x*blockDim.x + threadIdx.x;
	int y=blockIdx.y*blockDim.y + threadIdx.y;

	int i,j;
	//Sum variable used for final result convolution at (i,j)
	float sum = 0.0;                            
	//IF Statement used because I have by default 16 by 16 blksize incase op is small thenfor that case it is used
	if(x < newx){
	   if(y < newy){
           for(i=0;i < kY; ++i)      
           {
                for(j=0; j < kX; ++j)  
                {
			
                        sum += h[kX * i + j]*a[((y-i+kY-1)*(dX))+(x-j + kX-1)];
                }
            }
            c[(dX-(kX-1)) * y + x] = sum;
	}
      }
        
}


int main (int argc, char* argv[])
{
	int dY, dX,kY, kX;
	ifstream infile;
  	int stat1 = 0,stat2 = 0,col1 = 0,col2 = 0;
 	 infile.open(argv[1]); // open a file
	ifstream file2;
	file2.open(argv[1]);
	 string A;
   while (!file2.eof())
  {
   char buffer[512];
   file2.getline(buffer,512);
    if(strcmp(buffer,"") == 0){
	break;
    }	
    else{
	int n = 0;
    		// array to store memory addresses of the tokens in buf
    		const char* token[250] = {}; // initialize to 0
    
   		 // parse the line
   		 token[0] = strtok(buffer," "); // first token
   		 if (token[0]) // zero if line is blank
   		 {
    		  for (n = 1; n < 250; n++)
    		  {
    	 	   token[n] = strtok(0, " "); // subsequent tokens
    	    	   if (!token[n]) break; // no more tokens
    	  	  }
    	 	 col2 = n;
    		}
    	// process (print) the tokens
    		for (int i = 0; i < n; i++){ // n = #of tokens
	
      			//cout << "Token[" << i << "] = " << token[i] << endl;
       			stat2++;
    		}
		//cout << endl;
	}
    }
   while (!file2.eof())
  {
   char buffer[512];
   file2.getline(buffer,512);
		int n = 0;
    		// array to store memory addresses of the tokens in buf
    		const char* token[250] = {}; // initialize to 0
    
   		 // parse the line
   		 token[0] = strtok(buffer," "); // first token
   		 if (token[0]) // zero if line is blank
   		 {
    		  for (n = 1; n < 250; n++)
    		  {
    	 	   token[n] = strtok(0, " "); // subsequent tokens
    	    	   if (!token[n]) break; // no more tokens
    	  	  }
    	 	 col1 = n;
    		}
    	// process (print) the tokens
    		for (int i = 0; i < n; i++){ // n = #of tokens
	
      			//cout << "Token[" << i << "] = " << token[i] << endl;
       			//check1[stat1] = atof(token[i]);
			//cout << check1[stat1] << endl;
       			stat1++;
    		}
		//cout << endl;
		if(file2.eof())
			break;
    }
    //cout << stat1 << " " << stat2 << " " << col1 << " " << col2 << endl;
    //Allocating matrix a1 and a2 based on file parsed above which gives us dimension
    float *a1,*a2;
    a1 = new float [stat2];
    a2 = new float [stat1];
    for(int i = 0;i < stat2 ;i++)
	a1[i] = 0.0;
    for(int i = 0;i < stat1;i++)
	a2[i] = 0.0;
    int dum1=0,dum2=0;

  
   //Actual read of matrices a1 and a2
   while (!infile.eof())
  {
   char buffer[512];
   infile.getline(buffer,512);
    if(strcmp(buffer,"") == 0){
	break;
    }	
    else{
	int n = 0;
    		// array to store memory addresses of the tokens in buf
    		const char* token[250] = {}; // initialize to 0
    
   		 // parse the line
   		 token[0] = strtok(buffer," "); // first token
   		 if (token[0]) // zero if line is blank
   		 {
    		  for (n = 1; n < 250; n++)
    		  {
    	 	   token[n] = strtok(0, " "); // subsequent tokens
    	    	   if (!token[n]) break; // no more tokens
    	  	  }
    	 	 //col2 = n;
    		}
    	// process (print) the tokens
    		for (int i = 0; i < n; i++){ // n = #of tokens
	
      			//cout << "Token[" << i << "] = " << token[i] << endl;
       			a1[dum1] = atof(token[i]);
			//cout << check2[stat2] << endl;
       			dum1++;
    		}
		//cout << endl;
	}
    }
   while (!infile.eof())
  {
   char buffer[512];
   infile.getline(buffer,512);
		int n = 0;
    		// array to store memory addresses of the tokens in buf
    		const char* token[250] = {}; // initialize to 0
    
   		 // parse the line
   		 token[0] = strtok(buffer," "); // first token
   		 if (token[0]) // zero if line is blank
   		 {
    		  for (n = 1; n < 250; n++)
    		  {
    	 	   token[n] = strtok(0, " "); // subsequent tokens
    	    	   if (!token[n]) break; // no more tokens
    	  	  }
    	 	 //col1 = n;
    		}
    	// process (print) the tokens
    		for (int i = 0; i < n; i++){ // n = #of tokens
	
      			//cout << "Token[" << i << "] = " << token[i] << endl;
       			a2[dum2] = atof(token[i]);
			//cout << check1[stat1] << endl;
       			dum2++;
    		}
		//cout << endl;
		if(infile.eof())
			break;
    }
 	//cout << stat1 << "  " << col1 << " " << stat2 << " " << col2 << endl;	
	int newX,newY;
	for(int i = 0;i < stat2 ;i++){
		//cout << a1[i] << endl;
	}
	int ro1 = stat1/col1; int ro2 = stat2/col2;
	newX = col1+col2-1;
	newY = ro1+ro2-1;
	dX=newX+col1-1;
	dY=newY+ro1-1;
 	kY=ro1;
	kX=col1;
	
	//Padding input matrix such that the convolution formulae is valid for all values
	

	//Host Input Vector
	float *host_a;
	//h_a = new float [dataSizeX*dataSizeY];
	float *host_h;
	//Host Output Vector
	float *host_c;

	//Device Input Vector
	float *device_a;
	float *device_h;
	//Host output Vector
	float *device_c;

	//Memory allocation for Host
	host_a = (float*)malloc((dX*dY)*sizeof(float));
	host_h = (float*)malloc((kY*kX)*sizeof(float));
	host_c = (float*)malloc((newX*newY)*sizeof(float));

	//Memory allocation for device
	cudaMalloc(&device_a, (dX*dY)*sizeof(float));
	cudaMalloc(&device_h, (kY*kX)*sizeof(float));
	cudaMalloc(&device_c, (newX*newY)*sizeof(float));
        
	for(int i=0;i<dY;i++){
		for(int j=0;j<dX;j++){
			host_a[i*dX + j] = 0.0;
		}
	} 
        
	//Padding happens here on input matrix 2*(kY-1) rows added and 2*(kX-1) collumns added			
	//Intialize on Host
	int set1 = kX-1;
	int set2 = kY-1;
	int countset = 0;
	for(int i = set2;i <(dY-(kY-1)) ;i++){
		for(int j=0;j < set1;j++){
		   	host_a[i*dX + j] = 0.0;
		}
		for(int j = set1;j<(set1+col2);j++){
			host_a[i*dX + j] = a1[countset];
			countset++;	
		}
	}
					
         

	for(int i=0;i<(kY*kX);i++){			
		host_h[i] = a2[i];	
	}
	
		

	//Transfer to device
	cudaMemcpy( device_a, host_a, (dX*dY)*sizeof(float), cudaMemcpyHostToDevice);
    	cudaMemcpy( device_h, host_h, (kY*kX)*sizeof(float), cudaMemcpyHostToDevice);
	float x = newX;
       float y = newY;
       //Calculating GridSize required for computations
       int sizingX = (int)ceil((float)((float)(x)/16));
    int sizingY = (int)ceil((float)((float)(y)/16));
   
      dim3 blockSize(16,16);
     dim3 gridSize(sizingX,sizingY);
    twodimconvol<<<gridSize, blockSize>>>(device_a, device_h, device_c, kY, kX,dY, dX,newX,newY);

    // Copy array back to host
    cudaMemcpy( host_c, device_c, (newX*newY)*sizeof(float), cudaMemcpyDeviceToHost );

	// Release device memory
	cudaFree(device_a);
	cudaFree(device_h);
	cudaFree(device_c);
	int i,j;
	for(int j=0;j<newY;j++){
		for(int i=0;i<newX;i++){			
			cout << fixed << setprecision(1) << host_c[j*newX + i] << " ";
		}
		cout << endl;
	}

 
	// Release host memory
        free(host_a);
        free(host_h);
        free(host_c);
 
        return 0;
	

}
