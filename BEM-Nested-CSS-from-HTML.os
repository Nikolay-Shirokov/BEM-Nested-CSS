Перем КаталогСБлоками;
Перем КаталогССтилямиСтраниц;
Перем ИмяФайлаРазметки;

Процедура ПрочитатьПараметрыКоманднойСтроки()

  Если АргументыКоманднойСтроки.Количество() > 0 Тогда
    ИмяФайлаРазметки = АргументыКоманднойСтроки[0];
    ИмяФайлаРазметки = СтрЗаменить(ИмяФайлаРазметки, ".html", "");
  КонецЕсли;

  ПолноеИмяФайлаРазметки = СтрШаблон("%1.html", ИмяФайлаРазметки);

  Если НЕ Новый Файл(ПолноеИмяФайлаРазметки).Существует() Тогда
    ВызватьИсключение "Не найден файл разметки " + ПолноеИмяФайлаРазметки;
  КонецЕсли;

КонецПроцедуры

Функция КаталогСуществует(ИмяКаталога)
  Возврат Новый Файл(ИмяКаталога).Существует();
КонецФункции

Функция РазностьМассивов(Массив, ВычитаемыйМассив)

  ЭлементыВычитаемогоМассива = Новый Соответствие;
  Для каждого Элемент Из ВычитаемыйМассив Цикл
    ЭлементыВычитаемогоМассива.Вставить(Элемент, Истина);
  КонецЦикла;

  Результат = Новый Массив;
  Для каждого Элемент Из Массив Цикл
    Если ЭлементыВычитаемогоМассива[Элемент] = Неопределено Тогда
      Результат.Добавить(Элемент);
    КонецЕсли;
  КонецЦикла;

  Возврат Результат;

КонецФункции

Функция ПрочитатьКлассыИзРазметки()

  ТекстовыйДокумент = Новый ТекстовыйДокумент();
  ТекстовыйДокумент.Прочитать(СтрШаблон("%1.html", ИмяФайлаРазметки));

  ТекстРазметки = ТекстовыйДокумент.ПолучитьТекст();
  ТекстовыйДокумент = Неопределено;

  РегулярноеВыражение = Новый РегулярноеВыражение("class=""(.*?)""");
  ЗначенияАтрибутовКлассИзРазметки = РегулярноеВыражение.НайтиСовпадения(ТекстРазметки);

  КлассыИзРазметки = Новый Массив;
  Для каждого Совпадение Из ЗначенияАтрибутовКлассИзРазметки Цикл
    ЗначениеАтрибута = Совпадение.Группы[1].Значение;
    Для каждого Класс Из СтрРазделить(ЗначениеАтрибута, " ", Ложь) Цикл
      Если КлассыИзРазметки.Найти(Класс) = Неопределено Тогда
        КлассыИзРазметки.Добавить(Класс);
      КонецЕсли;
    КонецЦикла;
  КонецЦикла;

  Возврат КлассыИзРазметки;

КонецФункции

Функция ПрочитатьКлассыИзФайловойСтруктуры()

  КлассыИзФайловойСтруктуры = Новый Массив;

  Если НЕ КаталогСуществует(КаталогСБлоками) Тогда
    СоздатьКаталог(КаталогСБлоками);
  КонецЕсли;

  Для каждого Файл Из НайтиФайлы(КаталогСБлоками, "*.css", Истина) Цикл
    КлассыИзФайловойСтруктуры.Добавить(Файл.ИмяБезРасширения);
  КонецЦикла;

  Возврат КлассыИзФайловойСтруктуры;

КонецФункции

Функция ОпределитьПутьККаталогуКласса(Класс, СообщитьОбрабатываемыйКласс = Ложь)

  СоставляющиеКласса = СтрРазделить(Класс, "_");
  КоличествоСоставляющих = СоставляющиеКласса.Количество();

  Блок = СоставляющиеКласса[0];
  Если КоличествоСоставляющих = 1 Тогда
    ВидКласса = "Блок";
  ИначеЕсли ПустаяСтрока(СоставляющиеКласса[1]) Тогда
    Если КоличествоСоставляющих > 3 Тогда
      ВидКласса = "ЭлементМодификатор";
    Иначе
      ВидКласса = "Элемент";
    КонецЕсли;
  Иначе
    ВидКласса = "БлокМодификатор";
  КонецЕсли;

  Если СообщитьОбрабатываемыйКласс Тогда
    Сообщить(СтрШаблон("%1 (%2)", Класс, ВидКласса));
  КонецЕсли;

  Если ВидКласса = "Блок" Тогда
    ПутьККаталогу = ОбъединитьПути(КаталогСБлоками, Блок);
  ИначеЕсли ВидКласса = "БлокМодификатор" Тогда
    ПутьККаталогу = ОбъединитьПути(КаталогСБлоками
        , Блок
        , СтрШаблон("_%1", СоставляющиеКласса[1])
      );
  ИначеЕсли ВидКласса = "Элемент" Тогда
    ПутьККаталогу = ОбъединитьПути(КаталогСБлоками
        , Блок
        , СтрШаблон("__%1", СоставляющиеКласса[2])
      );
  ИначеЕсли ВидКласса = "ЭлементМодификатор" Тогда
    ПутьККаталогу = ОбъединитьПути(КаталогСБлоками
        , Блок
        , СтрШаблон("__%1", СоставляющиеКласса[2])
        , СтрШаблон("_%1", СоставляющиеКласса[3])
      );
  Иначе

  КонецЕсли;

  Возврат ПутьККаталогу;

КонецФункции

Процедура СоздатьФайлыПоНовымКлассам(КлассыИзРазметки, КлассыИзФайловойСтруктуры)

  КлассыКДобавлению = РазностьМассивов(КлассыИзРазметки, КлассыИзФайловойСтруктуры);
  Для каждого Класс Из КлассыКДобавлению Цикл

    ПутьККаталогу = ОпределитьПутьККаталогуКласса(Класс, Истина);

    Если Не КаталогСуществует(ПутьККаталогу) Тогда
      СоздатьКаталог(ПутьККаталогу);
    КонецЕсли;

    ШаблонФайлаСтилей =
      ".%1 {
      |
      |}";

    ТекстовыйДокумент = Новый ТекстовыйДокумент;
    ТекстовыйДокумент.УстановитьТекст(СтрШаблон(ШаблонФайлаСтилей, Класс));
    ТекстовыйДокумент.Записать(ОбъединитьПути(ПутьККаталогу, СтрШаблон("%1.css", Класс)), КодировкаТекста.UTF8);

  КонецЦикла;

КонецПроцедуры

Процедура СоздатьФайлСтилейСтраницы(КоллекцияКлассов)

  Если Не КаталогСуществует(КаталогССтилямиСтраниц) Тогда
    СоздатьКаталог(КаталогССтилямиСтраниц);
  КонецЕсли;

  ТекстовыйДокумент = Новый ТекстовыйДокумент();
  ДобавитьИмпортПоставляемыхСтилей(ТекстовыйДокумент);

  Для каждого Класс Из КоллекцияКлассов Цикл

    ПутьККаталогу = ОпределитьПутьККаталогуКласса(Класс);
    ОтносительныйПутьКФайлуСтилейКласса = ОбъединитьПути(ПутьККаталогу, СтрШаблон("%1.css", Класс));
    ОтносительныйПутьКФайлуСтилейКласса = СтрЗаменить(ОтносительныйПутьКФайлуСтилейКласса, "\", "/");
    СтрокаИмпорта = СтрШаблон("@import url(../%1);", ОтносительныйПутьКФайлуСтилейКласса);

    ТекстовыйДокумент.ДобавитьСтроку(СтрокаИмпорта);

  КонецЦикла;

  ТекИмяФайлаСтилей = ОбъединитьПути(КаталогССтилямиСтраниц, СтрШаблон("%1.css", ИмяФайлаРазметки));
  ТекстовыйДокумент.Записать(ТекИмяФайлаСтилей, КодировкаТекста.UTF8);

КонецПроцедуры

Процедура ДобавитьИмпортПоставляемыхСтилей(ТекстовыйДокумент)
  
  КаталогПоставлямогоФункционала = "vendor";

  Если НЕ КаталогСуществует(КаталогПоставлямогоФункционала) Тогда
    Возврат;
  КонецЕсли;

  МассивВозможныхПоставляемыхСтилей = Новый Массив;
  МассивВозможныхПоставляемыхСтилей.Добавить("normalize.css");
  МассивВозможныхПоставляемыхСтилей.Добавить("fonts/fonts.css");

  Для каждого ОтносительныйПутьКФайлуСтилей Из МассивВозможныхПоставляемыхСтилей Цикл
    
    ИмяФайла = ОбъединитьПути(КаталогПоставлямогоФункционала, ОтносительныйПутьКФайлуСтилей);
    Файл = Новый Файл(ИмяФайла);
    Если НЕ Файл.Существует() Тогда
      Продолжить;
    КонецЕсли;

    ИмяФайла      = СтрЗаменить(ИмяФайла, "\", "/");
    СтрокаИмпорта = СтрШаблон("@import url(../%1);", ИмяФайла);

    ТекстовыйДокумент.ДобавитьСтроку(СтрокаИмпорта);

  КонецЦикла;

  Если ТекстовыйДокумент.КоличествоСтрок() > 0 Тогда
    ТекстовыйДокумент.ДобавитьСтроку("");
  КонецЕсли;

КонецПроцедуры

КаталогСБлоками         = "blocks";
КаталогССтилямиСтраниц  = "pages";
ИмяФайлаРазметки        = "index";

ПрочитатьПараметрыКоманднойСтроки();

КлассыИзРазметки = ПрочитатьКлассыИзРазметки();
КлассыИзФайловойСтруктуры = ПрочитатьКлассыИзФайловойСтруктуры();

СоздатьФайлыПоНовымКлассам(КлассыИзРазметки, КлассыИзФайловойСтруктуры);
СоздатьФайлСтилейСтраницы(КлассыИзРазметки);
