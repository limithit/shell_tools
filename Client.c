#include<netinet/in.h>  
#include<sys/types.h>  
#include<sys/socket.h>  
#include<stdio.h>     
#include<stdlib.h>    
#include<string.h>     
#include <arpa/inet.h>

#define SERVER_PORT 22
#define BUFFER_SIZE 1024 
#define FILE_NAME_MAX_SIZE 512 

int main(int argc, char **argv) 
{ 
	struct sockaddr_in client_addr; 
	bzero(&client_addr, sizeof(client_addr)); 
	client_addr.sin_family = AF_INET; 
	client_addr.sin_addr.s_addr = htons(INADDR_ANY); 
	client_addr.sin_port = htons(0); 

	int client_socket_fd = socket(AF_INET, SOCK_STREAM, 0); 
	if(client_socket_fd < 0) 
	{ 
		perror("Create Socket Failed:"); 
		exit(1); 
	} 

	if(-1 == (bind(client_socket_fd, (struct sockaddr*)&client_addr, sizeof(client_addr)))) 
	{ 
		perror("Client Bind Failed:"); 
		exit(1); 
	} 


	struct sockaddr_in server_addr; 
	bzero(&server_addr, sizeof(server_addr)); 
	server_addr.sin_family = AF_INET; 
	if(inet_pton(AF_INET, "192.168.18.22", &server_addr.sin_addr) == 0) 
	{ 
		perror("Server IP Address Error:"); 
		exit(1); 
	} 
	server_addr.sin_port = htons(SERVER_PORT); 
	socklen_t server_addr_length = sizeof(server_addr); 

	if(connect(client_socket_fd, (struct sockaddr*)&server_addr, server_addr_length) < 0) 
	{ 
		perror("Can Not Connect To Server IP:"); 
		exit(0); 
	} 


	char buffer[BUFFER_SIZE]; 
	bzero(buffer, BUFFER_SIZE); 
	strncpy(buffer, argv[1], strlen(argv[1])>BUFFER_SIZE?BUFFER_SIZE:strlen(argv[1])); 

	if(send(client_socket_fd, buffer, BUFFER_SIZE, 0) < 0) 
	{ 
		perror("Send File Name Failed:"); 
		exit(1); 
	} 

	FILE *fp = fopen(argv[1], "w"); 
	if(NULL == fp) 
	{ 
		printf("File:\t%s Can Not Open To Write\n", argv[1]); 
		exit(1); 
	} 


	bzero(buffer, BUFFER_SIZE); 
	int length = 0; 
	while((length = recv(client_socket_fd, buffer, BUFFER_SIZE, 0)) > 0) 
	{ 
		if(fwrite(buffer, sizeof(char), length, fp) < length) 
		{ 
			printf("File:\t%s Write Failed\n", argv[1]); 
			break; 
		} 
		bzero(buffer, BUFFER_SIZE); 
	} 

	printf("Receive File:\t%s From Server IP Successful!\n", argv[1]); 
	close(fp); 
	close(client_socket_fd); 
	return 0; 
} 
