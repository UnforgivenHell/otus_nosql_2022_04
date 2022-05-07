1. Подключаемся к mongodb 
  .\mongo
2. подключаем к схеме для домашнего задания 
  use hw_02
3. Создаем коллекцию в которую будем загружать тестовые данные
  db.createCollection("bank_additional_full")
4. Через MongoDB Compass загрузим [датасет][ds1]
5. Запросы на выборку данных:
  db.bank_additional_full.find({"age": 30})
  db.bank_additional_full.find({"age": {$gt: 40}, "education": "unknown"}).limit(100).sort({"age": 1});
  db.bank_additional_full.find({"_id": ObjectId('62765c25d9762799f664f251')})
  db.bank_additional_full.find({$or: [{"job": "technician", "marital": "married"}, {"job": "blue-collar", "marital": "married"}]}).skip(100).limit(10).sort({"age": 1, "education": -1})
  db.bank_additional_full.aggregate([{$group : {_id : "$job", count_job : {$sum : 1}}}])
6. Обновление данных:
  db.bank_additional_full.update({"_id": ObjectId('62765c25d9762799f664f251')}, {$set: {"age": 41}})
  db.bank_additional_full.update({"default": { $nin: ["no", "yes"] }}, {$set: {"default": "no"}}, {multi : true})
7. Созадение индекса:
  db.bank_additional_full.createIndex( {"job" : 1 })
  После создания данного индекса если использовать поиск db.bank_additional_full.find({"job": "technician"}) будет сканирование по индексу вместо полного сканирования коллекции, что положительно скажется на скорости получения данных.

[ds1]: <https://www.kaggle.com/datasets/joseguzman/bank-marketing?select=bank-additional-full.csv>