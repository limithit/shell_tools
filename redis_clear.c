#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <hiredis.h>
#include <time.h>
/* gcc redis_clear.c -I/usr/local/include/hiredis/ -lhiredis */
int main(int argc, char **argv) {
	unsigned int j;
	redisContext *c;
	redisReply *reply;
	const char *hostname = (argc > 1) ? argv[1] : "127.0.0.1";
	int port = (argc > 2) ? atoi(argv[2]) : 6379;
	char *program=argv[0], *year=argv[3], *months=argv[4], *keys=argv[5];
	if (argc < 5){
		printf("Usage: command host port year months keys\n");
		printf("Example: %s 127.0.0.1 6379 2020 02 `redis-cli info|grep db0:keys|cut -d = -f 2|cut -d , -f 1`\n", program);
		exit(-1);
	}
	time_t err_t = time(NULL);
	struct tm *err_loc_time = localtime(&err_t);
	char D_time[256];
	sprintf(D_time, "%04d-%02d-%02d", err_loc_time->tm_year + 1900,
			err_loc_time->tm_mon + 1, err_loc_time->tm_mday -1);

	struct timeval timeout = { 1, 500000 }; // 1.5 seconds
	c = redisConnectWithTimeout(hostname, port, timeout);
	if (c == NULL || c->err) {
		if (c) {
			printf("Connection error: %s\n", c->errstr);
			redisFree(c);
		} else {
			printf("Connection error: can't allocate redis context\n");
		}
		exit(1);
	}

	int i;
	for(i=0; i<atoi(keys)/10000; i++){
		reply = redisCommand(c,"scan %d match *%s-%s* count 10000", i, year, months);
		int i;
		if (reply->type == REDIS_REPLY_ARRAY){
			for (i=0; i<reply->element[1]->elements; i++){
				printf("%s\n", reply->element[1]->element[i]->str);
				redisCommand(c,"del %s", reply->element[1]->element[i]->str);
			}
		}
		freeReplyObject(reply);
	}
	/* Disconnects and frees the context */
	redisFree(c);

	return 0;
}
