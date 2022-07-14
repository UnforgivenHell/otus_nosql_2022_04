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
```
