1. Создаем кластер конфигов
1.1. запускаем ноды
       d:\!!!_mongodb\bin\mongod --configsvr --dbpath d:\!!!_mongodb\data\conf1\ --port 27001 --replSet RScfg --logpath d:\!!!_mongodb\data\conf1\!_db.log --pidfilepath d:\!!!_mongodb\data\conf1\db.pid
       d:\!!!_mongodb\bin\mongod --configsvr --dbpath d:\!!!_mongodb\data\conf2\ --port 27002 --replSet RScfg --logpath d:\!!!_mongodb\data\conf2\!_db.log --pidfilepath d:\!!!_mongodb\data\conf2\db.pid
       d:\!!!_mongodb\bin\mongod --configsvr --dbpath d:\!!!_mongodb\data\conf3\ --port 27003 --replSet RScfg --logpath d:\!!!_mongodb\data\conf3\!_db.log --pidfilepath d:\!!!_mongodb\data\conf3\db.pid
1.2. Подключаемся к БД
       d:\!!!_mongodb\bin\mongo --port 27001
1.3. Настраиваем кластер
       rs.initiate({"_id" : "RScfg", configsvr: true, members : [{"_id" : 0, priority : 3, host : "127.0.0.1:27001"},{"_id" : 1, host : "127.0.0.1:27002"},{"_id" : 2, host : "127.0.0.1:27003"}]});

2. Создаем 3 кластера по 3 инстанса
2.1. Запускам ноды
       d:\!!!_mongodb\bin\mongod --shardsvr --dbpath d:\!!!_mongodb\data\node11\ --port 27011 --replSet RS1 --logpath d:\!!!_mongodb\data\node11\!_db.log --pidfilepath d:\!!!_mongodb\data\node11\db.pid
       d:\!!!_mongodb\bin\mongod --shardsvr --dbpath d:\!!!_mongodb\data\node12\ --port 27012 --replSet RS1 --logpath d:\!!!_mongodb\data\node12\!_db.log --pidfilepath d:\!!!_mongodb\data\node12\db.pid
       d:\!!!_mongodb\bin\mongod --shardsvr --dbpath d:\!!!_mongodb\data\node13\ --port 27013 --replSet RS1 --logpath d:\!!!_mongodb\data\node13\!_db.log --pidfilepath d:\!!!_mongodb\data\node13\db.pid
       
       d:\!!!_mongodb\bin\mongod --shardsvr --dbpath d:\!!!_mongodb\data\node21\ --port 27021 --replSet RS2 --logpath d:\!!!_mongodb\data\node21\!_db.log --pidfilepath d:\!!!_mongodb\data\node21\db.pid
       d:\!!!_mongodb\bin\mongod --shardsvr --dbpath d:\!!!_mongodb\data\node22\ --port 27022 --replSet RS2 --logpath d:\!!!_mongodb\data\node22\!_db.log --pidfilepath d:\!!!_mongodb\data\node22\db.pid
       d:\!!!_mongodb\bin\mongod --shardsvr --dbpath d:\!!!_mongodb\data\node23\ --port 27023 --replSet RS2 --logpath d:\!!!_mongodb\data\node23\!_db.log --pidfilepath d:\!!!_mongodb\data\node23\db.pid
       
       d:\!!!_mongodb\bin\mongod --shardsvr --dbpath d:\!!!_mongodb\data\node31\ --port 27031 --replSet RS3 --logpath d:\!!!_mongodb\data\node31\!_db.log --pidfilepath d:\!!!_mongodb\data\node31\db.pid
       d:\!!!_mongodb\bin\mongod --shardsvr --dbpath d:\!!!_mongodb\data\node32\ --port 27032 --replSet RS3 --logpath d:\!!!_mongodb\data\node32\!_db.log --pidfilepath d:\!!!_mongodb\data\node32\db.pid
       d:\!!!_mongodb\bin\mongod --shardsvr --dbpath d:\!!!_mongodb\data\node33\ --port 27033 --replSet RS3 --logpath d:\!!!_mongodb\data\node33\!_db.log --pidfilepath d:\!!!_mongodb\data\node33\db.pid
2.2. Настроиваем кластера
2.2.1. Полдключается к ноде 
       d:\!!!_mongodb\bin\mongo --port 27011
2.2.2. Инициируем ReplicaSet
       rs.initiate({"_id" : "RS1", members : [{"_id" : 0, priority : 3, host : "127.0.0.1:27011"},{"_id" : 1, host : "127.0.0.1:27012"},{"_id" : 2, host : "127.0.0.1:27013", arbiterOnly : true}]});

2.2.3. Полдключается к ноде 
       d:\!!!_mongodb\bin\mongo --port 27021
2.2.4. Инициируем ReplicaSet
       rs.initiate({"_id" : "RS2", members : [{"_id" : 0, priority : 3, host : "127.0.0.1:27021"},{"_id" : 1, host : "127.0.0.1:27022"},{"_id" : 2, host : "127.0.0.1:27023", arbiterOnly : true}]});

2.2.5. Полдключается к ноде 
       d:\!!!_mongodb\bin\mongo --port 27031
2.2.6. Инициируем ReplicaSet
       rs.initiate({"_id" : "RS3", members : [{"_id" : 0, priority : 3, host : "127.0.0.1:27031"},{"_id" : 1, host : "127.0.0.1:27032"},{"_id" : 2, host : "127.0.0.1:27033", arbiterOnly : true}]});

3. Создаем шардированный кластер
3.1. Создаем ноды
       d:\!!!_mongodb\bin\mongos --configdb RScfg/127.0.0.1:27001,127.0.0.1:27002,127.0.0.1:27003 --port 27000 --logpath d:\!!!_mongodb\data\dbc\dbs1.log --pidfilepath d:\!!!_mongodb\data\dbc\dbs1.pid 
       d:\!!!_mongodb\bin\mongos --configdb RScfg/127.0.0.1:27001,127.0.0.1:27002,127.0.0.1:27003 --port 27100 --logpath d:\!!!_mongodb\data\dbc\dbs2.log --pidfilepath d:\!!!_mongodb\data\dbc\dbs2.pid 
3.2. Полдключается к ноде
       d:\!!!_mongodb\bin\mongo --port 27000
3.3. Добавляем шарды в класстер
       sh.addShard("RS1/127.0.0.1:27011,127.0.0.1:27012,127.0.0.1:27013")
       sh.addShard("RS2/127.0.0.1:27021,127.0.0.1:27022,127.0.0.1:27023")
       sh.addShard("RS3/127.0.0.1:27031,127.0.0.1:27032,127.0.0.1:27033")
3.4. Проверяем статус
       sh.status()

4. Созжание фардированной таблицы
4.1. Сменим схему
       use bank
4.2. Включаем шардирование
       sh.enableSharding("bank")
4.3. Создадим записи
       db.account.insert({clinet_id: 1, account_type: 1, amount: 10})
       db.account.insert({clinet_id: 2, account_type: 1, amount: 100})
       db.account.insert({clinet_id: 3, account_type: 1, amount: 1000})
       db.account.insert({clinet_id: 4, account_type: 1, amount: 1000})
       db.account.insert({clinet_id: 5, account_type: 1, amount: 1000})
       db.account.insert({clinet_id: 4, account_type: 2, amount: 10})
4.4. Создаем индекс
       db.account.createIndex({clinet_id: 1})
4.5. Создаем шардированную коллекцию
       sh.shardCollection("bank.account",{clinet_id: 1})
4.6. Производим балансировку шардов
       sh.balancerCollectionStatus("bank.account")

5. Смотрим что будет происходить если уронить ту или иную ноду
5.1. Если выключить ноду, которая не является мастером, из кластера конфигов то при выполнении команды rs.status() то в информации по ноде в параметре "lastHeartbeatMessage" будет информация что потеряна связь с данной нодой. После восстановления связи с нодой инфромация по данному параметру удаляется
5.2. Если выключить ноду, которая является мастером, из кластера конфигов то при выполнении команды rs.status() то в информации по ноде в параметре "lastHeartbeatMessage" будет информация что потеряна связь с данной нодой и мастером становится другая ноде. После восстановления связи с нодой инфромация по данному параметру удаляется и она опять становится мастер нодой.
5.3. Если выключить ноду, которая является мастером, из кластера то при выполнении команды rs.status() то в информации по ноде в параметре "lastHeartbeatMessage" будет информация что потеряна связь с данной нодойи мастером становится другая ноде. После восстановления связи с нодой инфромация по данному параметру удаляется и она опять становится мастер нодой.


6. Настройка прав доступа
6.1. Запускаем ноду
       d:\!!!_mongodb\bin\mongod.exe --dbpath d:\!!!_mongodb\data\db1 --logpath d:\!!!_mongodb\data\db1\db
6.2. Создаем админский доступ
       db = db.getSiblingDB("admin")

       db.createRole(
           {      
            role: "superRoot",      
            privileges:[
               { resource: {anyResource:true}, actions: ["anyAction"]}
            ],      
            roles:[] 
           }
       )

       db.createUser({      
            user: "MongoDBA",      
            pwd: "hd4sOK",      
            roles: ["superRoot"] 
       })
6.3. Останавливаем ноду
6.4. Запускаем ноду с с аутентификацией
       d:\!!!_mongodb\bin\mongod.exe --auth --dbpath d:\!!!_mongodb\data\db1 --logpath d:\!!!_mongodb\data\db1\db1.log  --pidfilepath d:\!!!_mongodb\data\db1\db1.pid
6.5. При обычном подключении метод show databases нам ничего не показывает 
       d:\!!!_mongodb\bin\mongod.exe --dbpath d:\!!!_mongodb\data\db1 --logpath d:\!!!_mongodb\data\db1\db
6.6. При обычном подключении под MongoDBA метод show databases показывает список баз
       d:\!!!_mongodb\bin\mongo --port 27017 -u MongoDBA -p hd4sOK --authenticationDatabase "admin"
