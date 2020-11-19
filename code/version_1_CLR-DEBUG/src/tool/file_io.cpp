#include "file_io.h"
#include <stdio.h>
#include <stdlib.h>

 void load(const char * fn, unsigned char * Data,unsigned int& size){
    FILE* fptr = fopen(fn,"rb");
    fread(&size,sizeof(unsigned int),1,fptr);
    fread(Data,sizeof(unsigned char),size,fptr);
    fclose(fptr);
 }

 void store(const char * fn, unsigned char * Data, unsigned int size){
    FILE* fptr = fopen(fn,"wb");
    fwrite(&size,sizeof(unsigned int),1,fptr);
    fwrite(Data,sizeof(unsigned char),size,fptr);
    fclose(fptr);
}

