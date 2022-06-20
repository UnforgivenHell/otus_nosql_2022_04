 ### 1. Разворачиваем Cassandra с помощью [Helm-чарта bitnami](https://bitnami.com/stack/cassandra/helm)

```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install test-cassandra-cluster -f ./values.yaml bitnami/cassandra
```

Поскольку по умолчанию разворачивается [stand-alone из одной реплики](https://github.com/bitnami/charts/tree/master/bitnami/cassandra/#parameters), в values.yaml указываю replicaCount = 3 и cluster.seedCount = 3. Также указано имя УЗ admin с паролем adminpassword вместо УЗ cassandra с автогенерируемым паролем.

После запуска всех контейнеров, в CLI одного из них запускаю nodetool status:

```
--  Address    Load       Tokens       Owns         Host ID                               Rack
UN  10.1.0.10  70.68 KiB  256          55.0%        0421400f-7021-46b3-a45d-7586174c54a9  rack1
UN  10.1.0.12  70.71 KiB  256          53.6%        6c4b9c50-6a66-41f7-86ba-f94549cb4699  rack1
UN  10.1.0.11  70.73 KiB  256          54.4%        290db916-2a2d-432d-ab5b-5eaedfe835f9  rack1
```

 ### 2. Запускаем cassandra-stress, указываю адрес кластера и учётные данные, операция write, количество 1 млн:
```
/opt/bitnami/cassandra/tools/bin/cassandra-stress write n=1000000 -mode native cql3 user=admin password=adminpassword -node test-cassandra-cluster
```

Результаты:
```
Results:
Op rate                   :    6,070 op/s  [WRITE: 6,070 op/s]
Partition rate            :    6,070 pk/s  [WRITE: 6,070 pk/s]
Row rate                  :    6,070 row/s [WRITE: 6,070 row/s]
Latency mean              :   32.8 ms [WRITE: 32.8 ms]
Latency median            :   32.1 ms [WRITE: 32.1 ms]
Latency 95th percentile   :   75.7 ms [WRITE: 75.7 ms]
Latency 99th percentile   :  171.3 ms [WRITE: 171.3 ms]
Latency 99.9th percentile :  361.5 ms [WRITE: 361.5 ms]
Latency max               :  754.5 ms [WRITE: 754.5 ms]
Total partitions          :  1,000,000 [WRITE: 1,000,000]
Total errors              :          0 [WRITE: 0]
Total GC count            : 83
Total GC memory           : 12.678 GiB
Total GC time             :    9.2 seconds
Avg GC time               :  110.4 ms
StdDev GC time            :   62.6 ms
Total operation time      : 00:02:44
```

 ### 3. Запускаем cassandra-stress, указываю адрес кластера и учётные данные, операция read, количество 1 млн:
```
 /opt/bitnami/cassandra/tools/bin/cassandra-stress read n=1000000 -mode native cql3 user=admin password=adminpassword -node test-cassandra-cluster
```

Результаты:
``` 
Results:
Op rate                   :    5,797 op/s  [READ: 5,797 op/s]
Partition rate            :    5,797 pk/s  [READ: 5,797 pk/s]
Row rate                  :    5,797 row/s [READ: 5,797 row/s]
Latency mean              :    2.7 ms [READ: 2.7 ms]
Latency median            :    2.1 ms [READ: 2.1 ms]
Latency 95th percentile   :    6.3 ms [READ: 6.3 ms]
Latency 99th percentile   :   13.4 ms [READ: 13.4 ms]
Latency 99.9th percentile :   76.8 ms [READ: 76.8 ms]
Latency max               :  257.8 ms [READ: 257.8 ms]
Total partitions          :  1,000,000 [READ: 1,000,000]
Total errors              :          0 [READ: 0]
Total GC count            : 103
Total GC memory           : 16.087 GiB
Total GC time             :    5.4 seconds
Avg GC time               :   52.5 ms
StdDev GC time            :   23.4 ms
Total operation time      : 00:02:52

Improvement over 8 threadCount: 10%
```
 
 ### 4. Удаляем созданный кластер:
```
helm del test-cassandra-cluster
``` 
