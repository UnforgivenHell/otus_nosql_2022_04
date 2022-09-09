# etcd cluster test

## Тестовая среда

**etcd 3.4.18, 5 nodes**.

Сборка:
```
docker-compose up -d etcd1 etcd2 etcd3
```

Запуск теста:
```
./test-etcd.sh
```

Очистка:
```
docker-compose down -v
```

## Пример вывода

Тест:
```
[NODES = 3][FAILURE TOLERANCE = 1]

[NODE1] etcdctl member list
97ecdd3706cc2d90, started, etcd2, http://etcd2:2380, http://etcd2:2379, false
1e738073e57b0810, started, etcd3, http://etcd3:2380, http://etcd3:2379, false
a3959071884acd0c, started, etcd1, http://etcd1:2380, http://etcd1:2379, false

[NODE2] etcdctl del "" --from-key=true
0

[NODE1] etcdctl put key_n1_0 val_n1_0
OK

[NODE2] etcdctl put key_n2_0 val_n2_0
OK

[NODE3] etcdctl put key_n3_0 val_n3_0
OK

[NODE1] etcdctl put key_n1_1 val_n1_1
OK

[NODE2] etcdctl put key_n2_1 val_n2_1
OK

[NODE3] etcdctl put key_n3_1 val_n3_1
OK

[NODE1] etcdctl get --prefix key
key_n1_0
val_n1_0
key_n2_0
val_n2_0
key_n3_0
val_n3_0
key_n1_1
val_n1_1
key_n2_1
val_n2_1
key_n3_1
val_n3_1

[NODE2] etcdctl get --prefix key
key_n1_0
val_n1_0
key_n2_0
val_n2_0
key_n3_0
val_n3_0
key_n1_1
val_n1_1
key_n2_1
val_n2_1
key_n3_1
val_n3_1

[NODE3] etcdctl get --prefix key
key_n1_0
val_n1_0
key_n2_0
val_n2_0
key_n3_0
val_n3_0
key_n1_1
val_n1_1
key_n2_1
val_n2_1
key_n3_1
val_n3_1

[NODE1] STOP
[+] Running 1/1
 ⠿ Container etcd-1  Stopped  

[NODE2] etcdctl get --prefix key
key_n1_0
val_n1_0
key_n2_0
val_n2_0
key_n3_0
val_n3_0
key_n1_1
val_n1_1
key_n2_1
val_n2_1
key_n3_1
val_n3_1

[NODE2] STOP
[+] Running 1/1
 ⠿ Container etcd-2  Stopped

[NODE3] etcdctl get --prefix key
{"level":"warn","ts":"2022-09-09T06:10:15.999Z","caller":"clientv3/retry_interceptor.go:62","msg":"retrying of unary invoker failed","target":"endpoint://client-f891c00b-f259-4d72-9c54-61af5d68e336/127.0.0.1:2379","attempt":0,"error":"rpc error: code = DeadlineExceeded desc = context deadline exceeded"}
Error: context deadline exceeded 
```
