1. Создадим БД ClickHouse

	yc clickhouse cluster create --name ch --environment=production --network-name default --clickhouse-resource-preset s2.micro --host type=clickhouse,zone-id=ru-central1-a,subnet-id=e9bdn1ntssko35mriuq5,assign-public-ip --clickhouse-disk-size 10 --clickhouse-disk-type network-ssd --user name=user1,password=user1password --database name=db1



clickhouse-client --host rc1a-o24dpkvqgbe26oif.mdb.yandexcloud.net \
                  --secure \
                  --user user1 \
                  --database db1 \
                  --port 9440 \
                  --password user1password

2. Создадим таблицы

	clickhouse-client --host  rc1a-o24dpkvqgbe26oif.mdb.yandexcloud.net \
                  --secure \
                  --user user1 \
                  --database db1 \
                  --port 9440 \
                  --password user1password \
                  --query "CREATE TABLE db1.hits_v1
(
    WatchID UInt64,
    JavaEnable UInt8,
    Title String,
    GoodEvent Int16,
    EventTime DateTime,
    EventDate Date,
    CounterID UInt32,
    ClientIP UInt32,
    ClientIP6 FixedString(16),
    RegionID UInt32,
    UserID UInt64,
    CounterClass Int8,
    OS UInt8,
    UserAgent UInt8,
    URL String,
    Referer String,
    URLDomain String,
    RefererDomain String,
    Refresh UInt8,
    IsRobot UInt8,
    RefererCategories Array(UInt16),
    URLCategories Array(UInt16),
    URLRegions Array(UInt32),
    RefererRegions Array(UInt32),
    ResolutionWidth UInt16,
    ResolutionHeight UInt16,
    ResolutionDepth UInt8,
    FlashMajor UInt8,
    FlashMinor UInt8,
    FlashMinor2 String,
    NetMajor UInt8,
    NetMinor UInt8,
    UserAgentMajor UInt16,
    UserAgentMinor FixedString(2),
    CookieEnable UInt8,
    JavascriptEnable UInt8,
    IsMobile UInt8,
    MobilePhone UInt8,
    MobilePhoneModel String,
    Params String,
    IPNetworkID UInt32,
    TraficSourceID Int8,
    SearchEngineID UInt16,
    SearchPhrase String,
    AdvEngineID UInt8,
    IsArtifical UInt8,
    WindowClientWidth UInt16,
    WindowClientHeight UInt16,
    ClientTimeZone Int16,
    ClientEventTime DateTime,
    SilverlightVersion1 UInt8,
    SilverlightVersion2 UInt8,
    SilverlightVersion3 UInt32,
    SilverlightVersion4 UInt16,
    PageCharset String,
    CodeVersion UInt32,
    IsLink UInt8,
    IsDownload UInt8,
    IsNotBounce UInt8,
    FUniqID UInt64,
    HID UInt32,
    IsOldCounter UInt8,
    IsEvent UInt8,
    IsParameter UInt8,
    DontCountHits UInt8,
    WithHash UInt8,
    HitColor FixedString(1),
    UTCEventTime DateTime,
    Age UInt8,
    Sex UInt8,
    Income UInt8,
    Interests UInt16,
    Robotness UInt8,
    GeneralInterests Array(UInt16),
    RemoteIP UInt32,
    RemoteIP6 FixedString(16),
    WindowName Int32,
    OpenerName Int32,
    HistoryLength Int16,
    BrowserLanguage FixedString(2),
    BrowserCountry FixedString(2),
    SocialNetwork String,
    SocialAction String,
    HTTPError UInt16,
    SendTiming Int32,
    DNSTiming Int32,
    ConnectTiming Int32,
    ResponseStartTiming Int32,
    ResponseEndTiming Int32,
    FetchTiming Int32,
    RedirectTiming Int32,
    DOMInteractiveTiming Int32,
    DOMContentLoadedTiming Int32,
    DOMCompleteTiming Int32,
    LoadEventStartTiming Int32,
    LoadEventEndTiming Int32,
    NSToDOMContentLoadedTiming Int32,
    FirstPaintTiming Int32,
    RedirectCount Int8,
    SocialSourceNetworkID UInt8,
    SocialSourcePage String,
    ParamPrice Int64,
    ParamOrderID String,
    ParamCurrency FixedString(3),
    ParamCurrencyID UInt16,
    GoalsReached Array(UInt32),
    OpenstatServiceName String,
    OpenstatCampaignID String,
    OpenstatAdID String,
    OpenstatSourceID String,
    UTMSource String,
    UTMMedium String,
    UTMCampaign String,
    UTMContent String,
    UTMTerm String,
    FromTag String,
    HasGCLID UInt8,
    RefererHash UInt64,
    URLHash UInt64,
    CLID UInt32,
    YCLID UInt64,
    ShareService String,
    ShareURL String,
    ShareTitle String,
    ParsedParams Nested(
        Key1 String,
        Key2 String,
        Key3 String,
        Key4 String,
        Key5 String,
        ValueDouble Float64),
    IslandID FixedString(16),
    RequestNum UInt32,
    RequestTry UInt8
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(EventDate)
ORDER BY (CounterID, EventDate, intHash32(UserID))
SAMPLE BY intHash32(UserID)"

	clickhouse-client --host  rc1a-o24dpkvqgbe26oif.mdb.yandexcloud.net \
                  --secure \
                  --user user1 \
                  --database db1 \
                  --port 9440 \
                  --password user1password \
                  --query "CREATE TABLE db1.visits_v1
(
    CounterID UInt32,
    StartDate Date,
    Sign Int8,
    IsNew UInt8,
    VisitID UInt64,
    UserID UInt64,
    StartTime DateTime,
    Duration UInt32,
    UTCStartTime DateTime,
    PageViews Int32,
    Hits Int32,
    IsBounce UInt8,
    Referer String,
    StartURL String,
    RefererDomain String,
    StartURLDomain String,
    EndURL String,
    LinkURL String,
    IsDownload UInt8,
    TraficSourceID Int8,
    SearchEngineID UInt16,
    SearchPhrase String,
    AdvEngineID UInt8,
    PlaceID Int32,
    RefererCategories Array(UInt16),
    URLCategories Array(UInt16),
    URLRegions Array(UInt32),
    RefererRegions Array(UInt32),
    IsYandex UInt8,
    GoalReachesDepth Int32,
    GoalReachesURL Int32,
    GoalReachesAny Int32,
    SocialSourceNetworkID UInt8,
    SocialSourcePage String,
    MobilePhoneModel String,
    ClientEventTime DateTime,
    RegionID UInt32,
    ClientIP UInt32,
    ClientIP6 FixedString(16),
    RemoteIP UInt32,
    RemoteIP6 FixedString(16),
    IPNetworkID UInt32,
    SilverlightVersion3 UInt32,
    CodeVersion UInt32,
    ResolutionWidth UInt16,
    ResolutionHeight UInt16,
    UserAgentMajor UInt16,
    UserAgentMinor UInt16,
    WindowClientWidth UInt16,
    WindowClientHeight UInt16,
    SilverlightVersion2 UInt8,
    SilverlightVersion4 UInt16,
    FlashVersion3 UInt16,
    FlashVersion4 UInt16,
    ClientTimeZone Int16,
    OS UInt8,
    UserAgent UInt8,
    ResolutionDepth UInt8,
    FlashMajor UInt8,
    FlashMinor UInt8,
    NetMajor UInt8,
    NetMinor UInt8,
    MobilePhone UInt8,
    SilverlightVersion1 UInt8,
    Age UInt8,
    Sex UInt8,
    Income UInt8,
    JavaEnable UInt8,
    CookieEnable UInt8,
    JavascriptEnable UInt8,
    IsMobile UInt8,
    BrowserLanguage UInt16,
    BrowserCountry UInt16,
    Interests UInt16,
    Robotness UInt8,
    GeneralInterests Array(UInt16),
    Params Array(String),
    Goals Nested(
        ID UInt32,
        Serial UInt32,
        EventTime DateTime,
        Price Int64,
        OrderID String,
        CurrencyID UInt32),
    WatchIDs Array(UInt64),
    ParamSumPrice Int64,
    ParamCurrency FixedString(3),
    ParamCurrencyID UInt16,
    ClickLogID UInt64,
    ClickEventID Int32,
    ClickGoodEvent Int32,
    ClickEventTime DateTime,
    ClickPriorityID Int32,
    ClickPhraseID Int32,
    ClickPageID Int32,
    ClickPlaceID Int32,
    ClickTypeID Int32,
    ClickResourceID Int32,
    ClickCost UInt32,
    ClickClientIP UInt32,
    ClickDomainID UInt32,
    ClickURL String,
    ClickAttempt UInt8,
    ClickOrderID UInt32,
    ClickBannerID UInt32,
    ClickMarketCategoryID UInt32,
    ClickMarketPP UInt32,
    ClickMarketCategoryName String,
    ClickMarketPPName String,
    ClickAWAPSCampaignName String,
    ClickPageName String,
    ClickTargetType UInt16,
    ClickTargetPhraseID UInt64,
    ClickContextType UInt8,
    ClickSelectType Int8,
    ClickOptions String,
    ClickGroupBannerID Int32,
    OpenstatServiceName String,
    OpenstatCampaignID String,
    OpenstatAdID String,
    OpenstatSourceID String,
    UTMSource String,
    UTMMedium String,
    UTMCampaign String,
    UTMContent String,
    UTMTerm String,
    FromTag String,
    HasGCLID UInt8,
    FirstVisit DateTime,
    PredLastVisit Date,
    LastVisit Date,
    TotalVisits UInt32,
    TraficSource Nested(
        ID Int8,
        SearchEngineID UInt16,
        AdvEngineID UInt8,
        PlaceID UInt16,
        SocialSourceNetworkID UInt8,
        Domain String,
        SearchPhrase String,
        SocialSourcePage String),
    Attendance FixedString(16),
    CLID UInt32,
    YCLID UInt64,
    NormalizedRefererHash UInt64,
    SearchPhraseHash UInt64,
    RefererDomainHash UInt64,
    NormalizedStartURLHash UInt64,
    StartURLDomainHash UInt64,
    NormalizedEndURLHash UInt64,
    TopLevelDomain UInt64,
    URLScheme UInt64,
    OpenstatServiceNameHash UInt64,
    OpenstatCampaignIDHash UInt64,
    OpenstatAdIDHash UInt64,
    OpenstatSourceIDHash UInt64,
    UTMSourceHash UInt64,
    UTMMediumHash UInt64,
    UTMCampaignHash UInt64,
    UTMContentHash UInt64,
    UTMTermHash UInt64,
    FromHash UInt64,
    WebVisorEnabled UInt8,
    WebVisorActivity UInt32,
    ParsedParams Nested(
        Key1 String,
        Key2 String,
        Key3 String,
        Key4 String,
        Key5 String,
        ValueDouble Float64),
    Market Nested(
        Type UInt8,
        GoalID UInt32,
        OrderID String,
        OrderPrice Int64,
        PP UInt32,
        DirectPlaceID UInt32,
        DirectOrderID UInt32,
        DirectBannerID UInt32,
        GoodID String,
        GoodName String,
        GoodQuantity Int32,
        GoodPrice Int64),
    IslandID FixedString(16)
)
ENGINE = CollapsingMergeTree(Sign)
PARTITION BY toYYYYMM(StartDate)
ORDER BY (CounterID, StartDate, intHash32(UserID), VisitID)
SAMPLE BY intHash32(UserID)"

3. Pагрузим дата сеты

	cat visits_v1.tsv | clickhouse-client --host  rc1a-o24dpkvqgbe26oif.mdb.yandexcloud.net \
                  --secure \
                  --user user1 \
                  --database db1 \
                  --port 9440 \
                  --password user1password \
                  --query "INSERT INTO db1.visits_v1 FORMAT TSV" --max_insert_block_size=100000

	cat hits_v1.tsv | clickhouse-client --host  rc1a-o24dpkvqgbe26oif.mdb.yandexcloud.net \
                  --secure \
                  --user user1 \
                  --database db1 \
                  --port 9440 \
                  --password user1password \
                  --query "INSERT INTO db1.hits_v1 FORMAT TSV" --max_insert_block_size=100000

4. Подключаемся к кластеру

	clickhouse-client --host  rc1a-o24dpkvqgbe26oif.mdb.yandexcloud.net \
                  --secure \
                  --user user1 \
                  --database db1 \
                  --port 9440 \
                  --password user1password

5. Выполняем запросы
5.1. Запрос
SELECT
    StartURL AS URL,
    AVG(Duration) AS AvgDuration
FROM db1.visits_v1
WHERE StartDate BETWEEN '2014-03-23' AND '2014-03-30'
GROUP BY URL
ORDER BY AvgDuration DESC
LIMIT 10
Результат: 10 rows in set. Elapsed: 0.703 sec. Processed 1.45 million rows, 114.14 MB (2.07 million rows/s., 162.28 MB/s.)

5.2. Запрос
SELECT
    sum(Sign) AS visits,
    sumIf(Sign, has(Goals.ID, 1105530)) AS goal_visits,
    (100. * goal_visits) / visits AS goal_percent
FROM db1.visits_v1
WHERE (CounterID = 912887) AND (toYYYYMM(StartDate) = 201403) AND (domain(StartURL) = 'yandex.ru')
Результат: 1 rows in set. Elapsed: 0.117 sec. Processed 40.05 thousand rows, 4.94 MB (340.97 thousand rows/s., 42.09 MB/s.)

5.3. Запрос
SELECT count(*) FROM db1.hits_v1
Резльтат: 1 rows in set. Elapsed: 0.079 sec. 

5.4. Запрос
SELECT AVG(Age) FROM db1.hits_v1
Рузультат: 1 rows in set. Elapsed: 0.148 sec. Processed 8.87 million rows, 8.87 MB (60.06 million rows/s., 60.06 MB/s.)
