##### Сравнение команд Neo4j с Oracle
1. Получение всех сущностей:
1.1. Neo4j - match (n) return n
1.2. Oracle - такой команды нет.
2. Добавление данных:
2.1. Neo4j - create (:Director {name:'Joel Coen'})
2.2. Oracle - необходми что бы была создана таблица Director, а только после этого можно добавить данные командой insert into Director(name) values('Joel Coen')
3. Добавление свойств:
3.1. Neo4j - match (n:Director {name:'Ethan Coen'}) SET n.born = 1957
3.2. Oracle - можно реализовать несколькими способами:
3.2.1. Добавить поле в born в таблицу Director и после этого можно выполнить команду: update Director set born = 1957 where name = 'Ethan Coen'
3.2.2. Через отдельныю таблицу Director_param. insert into Director_param(name, key, value) values ('Ethan Coen', 'born', '1957'). В данном варинате получается что все значения строковые и необходимо всегда делать приведение типов.