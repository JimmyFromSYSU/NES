#include <stdio.h>
#include <string.h>
unsigned char buffer[16];
unsigned char prom[32*1024];
unsigned char vrom[8*1024];

void solve(const char * fn){
	FILE * fp = fopen(fn,"rb");
	FILE * fp1 = fopen("new_prom.bin","wb");
	FILE * fp2 = fopen("new_vrom.bin","wb");

	fread(buffer,sizeof(unsigned char ) , 16, fp);
	if(buffer[4]!=2 || buffer[5]!=1) {
		printf("Error: ");
		printf("16K PRG-ROM count: %d, should be 2",buffer[4]);
		printf("8K  CHR-ROM count: %d, should be 1",buffer[5]);
	}
	else{

		unsigned int size;
		size = 32*1024;
		fread(prom,sizeof(unsigned char),size,fp);
		fwrite(&size,sizeof(unsigned int),1,fp1);
		fwrite(prom,sizeof(unsigned char),size,fp1);
		
		size = 8*1024;
		fread(vrom,sizeof(unsigned char),size,fp);
		fwrite(&size,sizeof(unsigned int),1,fp2);
		fwrite(vrom,sizeof(unsigned char),size,fp2);
	}
	fclose(fp);
	fclose(fp1);
	fclose(fp2);
}

int main(int argc,char ** argv){ 
	if(argc!=3 || strcmp(argv[1],"-f")!=0){
		printf("usage: %s -f NES_FILE_NAME",argv[0]);
	}
	else{solve(argv[2]);}
	return 0;
}
