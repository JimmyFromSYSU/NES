#include "tool.h"

using namespace std;
const int N = 1024 * 64 * 2;
unsigned char Data[N];
int size;

int valid(char c){
	if(c>='0' && c<= '9') return 0;
	if(c>='A' && c<= 'F') return 0;
	if(c==':') return 1;
	if(c==';') return 2;
	if(c=='[') return 3;
	if(c==']') return 4;
	if(c=='.') return 5;
	if(isspace(c)) return 0;
	return -1; 
}
bool check(char * buffer){
	int cnt[6] = {0};
	for(int i = 0;buffer[i] != '\0';i++){
		int t = valid(buffer[i]);
		if(t==-1)return false;
		cnt[t] ++;
	}
	if(cnt[1] != 1 || cnt[2] != 1 || cnt[3]>1 || cnt [4] > 1) return false;
	if(cnt[5] != 2 && cnt[5] != 0) return false;
	return true;
}
void read(){
	char buffer[1024];
	int start = 0;
	size = 0;
	while(scanf("%[^\n]s",buffer)!=EOF){
		
		char c ; scanf("%c",&c);

		if(check(buffer)==false){
			printf("ignore: %s\n",buffer);
			continue;
		}
		int i = 0;
		while(isspace(buffer[i]))i++;

		if(buffer[i] == '['){
			char addr_st_c[10];
			int addr_st_cnt = 0;
			char addr_ed_c[10];
			int addr_ed_cnt = 0;
			char data_c[10];
			int data_cnt = 0;
			int addr_st;
			int addr_ed;
			int data;
			
			for(;buffer[i]!='.';i++) {
				if(isspace(buffer[i]) || buffer[i] == '['){
					continue;
				}
				addr_st_c[addr_st_cnt++] = buffer[i];
			}
			addr_st_c[addr_st_cnt++] = '\0';
			for(i+=2;buffer[i]!=']';i++){
				if(isspace(buffer[i]) || buffer[i] == '.'){
					continue;
				}
				addr_ed_c[addr_ed_cnt++] = buffer[i];
			}
			addr_ed_c[addr_ed_cnt++] = '\0';

			for(i+=2;buffer[i]!=';';i++){
				if(isspace(buffer[i]) || buffer[i] == ':'){
					continue;
				}
				data_c[data_cnt++] = buffer[i];
			}

			data_c[data_cnt++] = '\0';
			addr_st = hex2int(addr_st_c);
			addr_ed = hex2int(addr_ed_c);
			data = hex2int(data_c);
			for(i = addr_st;i<=addr_ed;i++){
				Data[i] = data;
				size++;
			}
		}
		else{
			char addr_c[10];
			int addr_cnt=0;
			char data_c[10];
			int data_cnt = 0;

			for(;buffer[i]!=':';i++){
				if(isspace(buffer[i]) || buffer[i] =='['){
					continue;
				}
				addr_c[addr_cnt++] = buffer[i];
			}
			addr_c[addr_cnt++] = '\0';
			for(i++;buffer[i]!=';';i++){
				if(isspace(buffer[i])){
					continue;
				}
				data_c[data_cnt++] = buffer[i];
			}
			data_c[data_cnt++] = '\0';

			int addr = hex2int(addr_c);
			int data = hex2int(data_c);
			Data[addr] = data;
			size++;
		}
	}
}

int main(int argc, char ** argv)
{
	if(argc == 3 && strcmp(argv[1],"-f")==0){
		read();
		store(argv[2],Data,size);
		printf("Read size: %dB(%lfKB)\n",size,size/1024.0);
	}
	else{
		printf("Usage: %s -f BIN_FILE < MIF_FILE\n",argv[0]);
	 }
	return 0;
}

