Перем Обмен;
Перем ВыборИзСписка;

Процедура ВыбратьПрепроцессор() Экспорт
	
	Данные = Новый Соответствие;
	Данные.Вставить("&НаСервере", "&НаСервере");
	Данные.Вставить("&НаСервереБезКонтекста", "&НаСервереБезКонтекста");
	Данные.Вставить("&НаКлиенте", "&НаКлиенте");
	
	Результат = ВыборИзСписка.ВыбратьИзСписка(Данные);
	// Обмен.ЗаписатьРезультатВФайл("tmp\module.txt", Результат);
	Обмен.УстановитьТекстВВыделение(Результат);
	
КонецПроцедуры

Процедура ВыполнитьДействие(Параметры)
	
	Обмен = ЗагрузитьСценарий("scripts\Обмен.os");
	ВыборИзСписка = ЗагрузитьСценарий("scripts\SelectValue.os");
	
	Если Параметры.Количество() > 0 Тогда
		Если Параметры[0] = "ВыбратьПрепроцессор" Тогда
			ВыбратьПрепроцессор();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

ВыполнитьДействие(АргументыКоманднойСтроки);
