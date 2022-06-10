1. Создадим БД Elasticsearch

	yc managed-elasticsearch cluster create \
  --name ch \
  --environment production \
  --network-name default \
  --host zone-id=ru-central1-b,assign-public-ip=true,type=datanode \
  --datanode-resource-preset s2.micro \
  --datanode-disk-type=network-ssd \
  --datanode-disk-size=10 \
  --admin-password=adminpassword \
  --version 7.17 \
  --edition platinum

 
 2. Добавим Сертификат в Postman

 
 3. Настроим Basic авторизацию в Postman 

 
 4. Создадим индекс
 
 	PUT https://rc1b-rk7kftsghhrvam8r.mdb.yandexcloud.net:9200/hw
 {
  "mappings": {
    "properties": {
      "phrase": { "type": "text" }
    }
  }
}
{
    "acknowledged": true,
    "shards_acknowledged": true,
    "index": "hw"
}


5. Создадим патернов для индексов

	PUT https://rc1b-rk7kftsghhrvam8r.mdb.yandexcloud.net:9200/_template/default_template
{
   "template": "*",
   "order": 0,
   "settings": {
     "number_of_shards": 1
   }
 }
 
{
    "acknowledged": true
}


6. Добавим докумены в индекс

	POST https://rc1b-rk7kftsghhrvam8r.mdb.yandexcloud.net:9200/hw/_doc
{
  "phrase": "моя мама мыла посуду а кот жевал сосиски"
}

{
    "_index": "hw",
    "_type": "_doc",
    "_id": "ysgDTIEBaMvC_3fjUdZA",
    "_version": 1,
    "result": "created",
    "_shards": {
        "total": 2,
        "successful": 1,
        "failed": 0
    },
    "_seq_no": 0,
    "_primary_term": 1
}


	POST https://rc1b-rk7kftsghhrvam8r.mdb.yandexcloud.net:9200/hw/_doc
{
  "phrase": "рама была отмыта и вылизана котом"
}

{
    "_index": "hw",
    "_type": "_doc",
    "_id": "y8gETIEBaMvC_3fjWta8",
    "_version": 1,
    "result": "created",
    "_shards": {
        "total": 2,
        "successful": 1,
        "failed": 0
    },
    "_seq_no": 1,
    "_primary_term": 1
}


	POST https://rc1b-rk7kftsghhrvam8r.mdb.yandexcloud.net:9200/hw/_doc
{
  "phrase": "мама мыла раму"
}

{
    "_index": "hw",
    "_type": "_doc",
    "_id": "zMgETIEBaMvC_3fjwdbM",
    "_version": 1,
    "result": "created",
    "_shards": {
        "total": 2,
        "successful": 1,
        "failed": 0
    },
    "_seq_no": 2,
    "_primary_term": 1
}


7. Написать запрос нечеткого поиска к этой коллекции документов ко ключу «мама ела сосиски»

	GET https://rc1b-rk7kftsghhrvam8r.mdb.yandexcloud.net:9200/hw/_search
{
  "query": {
    "match": {
      "phrase": 
        "мама ела сосиски"
    }
  }
}

{
    "took": 516,
    "timed_out": false,
    "_shards": {
        "total": 1,
        "successful": 1,
        "skipped": 0,
        "failed": 0
    },
    "hits": {
        "total": {
            "value": 2,
            "relation": "eq"
        },
        "max_score": 1.241674,
        "hits": [
            {
                "_index": "hw",
                "_type": "_doc",
                "_id": "ysgDTIEBaMvC_3fjUdZA",
                "_score": 1.241674,
                "_source": {
                    "phrase": "моя мама мыла посуду а кот жевал сосиски"
                }
            },
            {
                "_index": "hw",
                "_type": "_doc",
                "_id": "zMgETIEBaMvC_3fjwdbM",
                "_score": 0.5820575,
                "_source": {
                    "phrase": "мама мыла раму"
                }
            }
        ]
    }
}


8. Ссылка на коллекцию

	https://www.getpostman.com/collections/4d03950220a74b5a0ec7
