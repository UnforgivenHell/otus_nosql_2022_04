[Реестр муниципальных маршрутов регулярных перевозок пассажиров и багажа автомобильным и наземным электрическим транспортом в городе Москве](https://data.gov.ru/opendata/7704786030-municipalroutesregister)
 и [json-данные ~ 60 МБ](https://data.gov.ru/sites/default/files/opendata/7704786030-MunicipalRoutesRegister/data-2017-07-18T00-00-00-structure-2017-07-18T00-00-00.json)
 ([зеркало в текущем репозитории](data.json))

Структура:
 - "system_object_id":("STRING"),
 - "CarrierName" ("STRING", Наименование юридического лица или индивидуального предпринимателя, осуществляющего перевозки пассажиров по маршруту"),
 - "global_id" ("NUMBER"),
 - "RouteNumber" ("STRING", "Номер маршрута"),
 - "DirectRouteTrack" ("STRING", "Координаты прямого трека маршрута"),
 - "ReverseTrackOfFollowing" ("STRING", "Трасса следования маршрута (обратное направление)"),
 - "is_deleted" ("NUMBER"),
 - "signature_date" ("STRING"),
 - "ReverseRouteTrack" ("STRING", "Координаты обратного трека маршрута"),
 - "TrackOfFollowing" ("STRING", "Трасса следования маршрута (прямое направление)"),
 - "RouteName" ("STRING", "Наименование маршрута"),
 - "ID" ("INTEGER", "Код"),
 - "TypeOfTransport" ("DICTIONARY", "Вид транспорта").
 
## Время на вставку даннных

### Как строка 

Импорт происходит в формате 
```bash
obj:<ID> <STRINGIFY JSON-row>
```

[Cкрипт загрузки JSON как строки](pythone/upload_as_string.py)

Запустил для первых 1000 записей JSON-набора.
```bash
python3 upload_as_string.py

Upload json as true-string.
         Were upload: 1000 units
         Time left: 291.31338763237 sec
```

## Как сложная структура 

Структура из hset, zset, list (ключам дал название, чтоб не путаться)

```bash
object:<ID>:hset
     system_object_id
     routenumber
     global_id
     id
     id_en
     signature_date
     routename
     routename_en
     trackoffollowing
     trackoffollowing_en
     typeoftransport
     typeoftransport_en
     carriername_en
object:<ID>:list__reverseroutetrack
object:<ID>:list__reverseroutetrack_en
object:<ID>:list__trackoffollowing
object:<ID>:list__trackoffollowing_en
object:<ID>:list__directroutetrack
object:<ID>:list__directroutetrack_en
object:<ID>:list__reversetrackoffollowing
object:<ID>:list__reversetrackoffollowing_en
object:<ID>:zset__trackoffollowing
```

[Cкрипт загрузки JSON как сложной структуры](pythone/upload_as_structure.py)

Запустил для первых 1000 записей JSON-набора.

```bash
python3 upload_as_structure.py

Upload json as complex structure.
         hset - https://redis.io/commands/hset
         zadd - https://redis.io/commands/zadd
         list - https://redis.io/commands/lpush
         Were upload: 1000 units
         Time left: 1703.8530101776123 sec


```

### Вывод

Видим, что первые 1000 json-записей данных как строки вставляются быстрее (291 сек), чем "распознанных" как структуры данные (1703 сек).

## Критерии на выборку

### У строк

[Cкрипт выборки сведений, упакованных как строки,  по всем ключам](pythone/load_string.py)

```bash
Time left 0.41986918449401855 sec
Units count: 1000
```

__Замечание__: не могу понять, как искать именно по строковым значенеиям, по значениям ключей

### У распознанных структур

[Cкрипт выборки сведений, упакованных как строки,  по всем ключам](pythone/load_structure.py)

Выборка по хешам:
```bash
Time left for get all hset-substructures for ALL rows 0.6036486625671387 sec
units: 1000
```

Выборка по спискам (7624 - столько нод, суммарно элементов во всех списках):
```bash
Time left for get all lists: 16.734337091445923 sec
Units count: 7624
```

Выборка из упорядоченных наборов:
```bash
Time left for get values from zset: 0.522514820098877 sec
Units count: 1000
```
### Вывод

Видим, что первые 1000 json-записей данных как строки забираются быстрее (0.4 сек), 
чем "распознанные" как структуры данные (хеш-таблицы - 0.6 сек, списки - 16.7 сек, упорядоченные множества - 0.5 сек, ).

##  Общий вывод

При грубом подходе как вставка сведений в виде строк, так и их выборка - быстрее, 
чем использование и подготовка для специальных структур.