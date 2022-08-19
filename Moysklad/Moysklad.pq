// This file contains your Data Connector logic
section Moysklad;

[DataSource.Kind="Moysklad", Publish="Moysklad.Publish"]
shared Moysklad.Data = Value.ReplaceType(Moysklad.Func, FuncType);

FuncType = type function (   
    
    what  as (type text meta 
    [
        Documentation.FieldCaption = "Что нужно получить:",
        Documentation.SampleValues = {"Выгрузка"},
        Documentation.AllowedValues = { "Токен", "Размер выгрузки", "Выгрузка"}
    ]),

    report  as (type text meta 
    [
        Documentation.FieldCaption = "Тип отчёта:",
        Documentation.SampleValues = {"Не выбрано"},
        Documentation.AllowedValues = { "Не выбрано", "Ассортимент","Бонусные операции","Бонусные программы","Валюты","Вебхухи","Внесения денег","Внутренние заказы","Возвраты покупателей","Возвраты поставщику","Возвраты предоплаты","Входящие платежи","Выданные отчёты комиссионера","Выданные счёт-фактуры","Выплаты денег","Группы техкарт","Группы товаров","Движение денежных средств","Договоры","Единицы измерения","Задачи","Заказы на производство","Заказы покупателей","Заказы поставщикам","Инвенторизации","Исходящие платежи","Каналы продаж","Комплекты","Контексты аудита","Контргенты","Корректировки баланса контрагента","Лента уведомлений","Модификации","Настройки уведомлений","Обороты по товарам","Оприходования","Остатки денежных средств","Отгрузки","Отделы","Отчёт Остатки по складам","Отчёт Остатки","Отчёт Текущие остатки","Отчёты комиссионера","Перемещения","Показатели за день","Показатели за месяц","Показатели за неделю","Полченные счёт-фактуры","Пользовательские роли","Прайс-листы","Предоплаты","Прибыльность по каналам продаж","Прибыльность по модификациям","Прибыльность по покупателям","Прибыльность по сотрудникам","Прибыльность по товарам","Приходные ордера","Приёмки","Проекты","Расходные ордера","Регионы","Розничная смена","Розничные возвраты","Розничные продажи","Серии","Скидки","Склады","Сотруники","Списания","Список услуг","Статьи расходов","Страны","Счета покупателям","Счета поставщиков","Техкарты","Техоперации","Товары","Точки продаж","Юрлица"}
    ]),

    
    entity as (type nullable text meta 
    [
        Documentation.FieldCaption = "Укажите конец URL для получения данных:",
        Documentation.SampleValues = {"entity/customerorder"}
    ]),

    start as (type nullable text meta 
    [
        Documentation.FieldCaption = "Начальный отступ:",
        Documentation.SampleValues = {"7000"}
    ])
    
    )
    as table meta [
        Documentation.Name = "Забираем данные из Мойсклад",
        Documentation.LongDescription =  "",
        Documentation.Examples = {
        [
            
        ]
        }
    ];



Moysklad.Func =(what as text,  report as text, entity as nullable text,  start as nullable text) => 
    let
        gettoken = Json.Document(Web.Contents("https://online.moysklad.ru/", [RelativePath = "api/remap/1.2/security/token", Headers = [#"Content-Type"="application/json", Authorization  = "Basic "&Extension.CurrentCredential()[Key]], Content = Text.ToBinary(""),  ManualStatusHandling = {404, 400}])),    
        reportType = 
        if report = "Ассортимент" then "entity/assortment" else 
        if report = "Бонусные операции" then "entity/bonustransaction" else 
        if report = "Бонусные программы" then "entity/bonusprogram" else 
        if report = "Валюты" then "entity/currency" else 
        if report = "Вебхухи" then "entity/webhook" else 
        if report = "Группы товаров" then "entity/productfolder" else 
        if report = "Договоры" then "entity/contract" else 
        if report = "Единицы измерения" then "entity/uom" else 
        if report = "Задачи" then "entity/task" else 
        if report = "Каналы продаж" then "entity/saleschannel" else 
        if report = "Комплекты" then "entity/bundle" else 
        if report = "Контргенты" then "entity/counterparty" else 
        if report = "Модификации" then "entity/variant" else 
        if report = "Отделы" then "entity/group" else 
        if report = "Пользовательские роли" then "entity/role" else 
        if report = "Проекты" then "entity/project" else 
        if report = "Регионы" then "entity/region" else 
        if report = "Серии" then "entity/consignment" else 
        if report = "Скидки" then "entity/discount" else 
        if report = "Склады" then "entity/store" else 
        if report = "Сотруники" then "entity/employee" else 
        if report = "Статьи расходов" then "entity/expenseitem" else 
        if report = "Страны" then "entity/country" else
        if report = "Товары" then "entity/product" else
        if report = "Точки продаж" then "entity/retailstore" else
        if report = "Список услуг" then "entity/service" else
        if report = "Юрлица" then "entity/organization" else
        if report = "Внесения денег" then "entity/retaildrawercashin" else
        if report = "Внутренние заказы" then "entity/internalorder" else
        if report = "Возвраты покупателей" then "entity/salesreturn" else
        if report = "Возвраты поставщику" then "entity/purchasereturn" else
        if report = "Возвраты предоплаты" then "entity/prepaymentreturn" else
        if report = "Входящие платежи" then "entity/paymentin" else
        if report = "Выданные отчёты комиссионера" then "entity/commissionreportout" else
        if report = "Выплаты денег" then "entity/retaildrawercashout" else
        if report = "Заказы на производство" then "entity/processingorder" else
        if report = "Заказы покупателей" then "entity/customerorder" else
        if report = "Заказы поставщикам" then "entity/purchaseorder" else
        if report = "Инвенторизации" then "entity/inventory" else
        if report = "Исходящие платежи" then "entity/paymentout" else
        if report = "Корректировки баланса контрагента" then "entity/counterpartyadjustment" else
        if report = "Оприходования" then "entity/enter" else
        if report = "Отгрузки" then "entity/demand" else
        if report = "Перемещения" then "entity/move" else
        if report = "Отчёты комиссионера" then "entity/commissionreportin" else
        if report = "Прайс-листы" then "entity/pricelist" else
        if report = "Предоплаты" then "entity/prepayment" else
        if report = "Приёмки" then "entity/supply" else
        if report = "Приходные ордера" then "entity/cashin" else
        if report = "Расходные ордера" then "entity/cashout" else
        if report = "Розничные продажи" then "entity/retaildemand" else
        if report = "Розничная смена" then "entity/retailshift" else
        if report = "Розничные возвраты" then "entity/retailsalesreturn" else
        if report = "Списания" then "entity/loss" else
        if report = "Счета покупателям" then "entity/invoiceout" else
        if report = "Счета поставщиков" then "entity/invoicein" else
        if report = "Выданные счёт-фактуры" then "entity/factureout" else
        if report = "Полченные счёт-фактуры" then "entity/facturein" else
        if report = "Техкарты" then "entity/processingplan" else
        if report = "Группы техкарт" then "entity/processingplanfolder" else
        if report = "Техоперации" then "entity/processing" else

        if report = "Отчёт Остатки" then "report/stock/all" else
        if report = "Отчёт Остатки по складам" then "report/stock/bystore" else
        if report = "Отчёт Текущие остатки" then "report/stock/all/current" else
        if report = "Прибыльность по товарам" then "report/profit/byproduct" else
        if report = "Прибыльность по модификациям" then "report/profit/byvariant" else
        if report = "Прибыльность по сотрудникам" then "report/profit/byemployee" else
        if report = "Прибыльность по покупателям" then "report/profit/bycounterparty" else
        if report = "Прибыльность по каналам продаж" then "report/profit/bysaleschannel" else
        if report = "Остатки денежных средств" then "report/money/byaccount" else
        if report = "Движение денежных средств" then "report/money/plotseries" else
        if report = "Обороты по товарам" then "report/turnover/all" else
        if report = "Показатели за день" then "report/dashboard/day" else
        if report = "Показатели за неделю" then "report/dashboard/week" else
        if report = "Показатели за месяц" then "report/dashboard/month" else
        if report = "Контексты аудита" then "audit" else
        if report = "Лента уведомлений" then "notification" else
        if report = "Настройки уведомлений" then "notification/subscription" else "none",
    
    
        startOffset = if start= null or  start="null" or  start= "" then 0 else Number.From(start),

        ent = if entity = null or entity = "null" or entity ="" then reportType else entity,
        getofflist=(rows,limit)=> List.Accumulate({Number.RoundDown(startOffset/limit)..Number.RoundDown(rows/limit-0.0000000001)}, {}, (state, current)=>state&{current*limit}),
        size = Json.Document(Web.Contents("https://online.moysklad.ru/", [RelativePath = "api/remap/1.2/"&ent, Query = [#"limit"="1000", #"offset"="0"], Headers = [#"Content-Type"="application/json", Authorization  = "Bearer "&Extension.CurrentCredential()[Key]],  ManualStatusHandling = {404, 400}]))[meta][size],
        offlist = getofflist(size, 1000),
        #"Преобразовано в таблицу" = Table.FromList(offlist, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        #"Переименованные столбцы" = Table.RenameColumns(#"Преобразовано в таблицу",{{"Column1", "offset"}}),
        #"Измененный тип" = Table.TransformColumnTypes(#"Переименованные столбцы",{{"offset", type text}}),
        stat = Table.AddColumn(#"Измененный тип", "data", (x)=>  Json.Document(Web.Contents("https://online.moysklad.ru/", [RelativePath = "api/remap/1.2/"&ent, Query = [#"limit"="1000", #"offset"=x[offset]], Headers = [#"Content-Type"="application/json", Authorization  = "Bearer "&Extension.CurrentCredential()[Key]],  ManualStatusHandling = {404, 400}]))[rows] ),
        
        final = if what = "Токен" then gettoken else if what = "Размер выгрузки" then size else  stat
    in
        final;

Moysklad = [
    TestConnection = (dataSourcePath) => 
        { "Moysklad.Data", 
        Json.Document(dataSourcePath)[what], 
        Json.Document(dataSourcePath)[report], 
        Json.Document(dataSourcePath)[entity]?,
        Json.Document(dataSourcePath)[start]?},
    
    Authentication = [
        
         Key = []
   
    ],
    Label = "Moysklad Connection"
];



Moysklad.Publish = [
    Beta = false,
    Category = "Other",
    ButtonText = { "Moysklad Connector", "Moysklad Help" },
    LearnMoreUrl = "",
    SourceImage = Moysklad.Icons,
    SourceTypeImage = Moysklad.Icons
];



Moysklad.Icons = [
    Icon16 = { Extension.Contents("Moysklad16.png"), Extension.Contents("Moysklad20.png"), Extension.Contents("Moysklad24.png"), Extension.Contents("Moysklad32.png") },
    Icon32 = { Extension.Contents("Moysklad32.png"), Extension.Contents("Moysklad40.png"), Extension.Contents("Moysklad48.png"), Extension.Contents("Moysklad64.png") }
];