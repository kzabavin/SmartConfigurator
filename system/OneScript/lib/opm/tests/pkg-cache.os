﻿#Использовать asserts

Перем юТест;

Функция ПолучитьСписокТестов(Знач Тестирование) Экспорт

	юТест = Тестирование;
	
	ИменаТестов = Новый Массив;
	
	ИменаТестов.Добавить("ТестДолжен_ПроверитьЧтоПакетУстановлен");
	
	Возврат ИменаТестов;

КонецФункции

Процедура ТестДолжен_ПроверитьЧтоПакетУстановлен() Экспорт

	КаталогБиблиотеки = ОбъединитьПути(КаталогПрограммы(), ПолучитьЗначениеСистемнойНастройки("lib.system"));
	
	ФайлыКаталога = НайтиФайлы(КаталогБиблиотеки, ПолучитьМаскуВсеФайлы());
	НайденныйКаталог = Неопределено;
	Для Каждого Каталог Из ФайлыКаталога Цикл
		Если Каталог.ЭтоКаталог() Тогда
			НайденныйКаталог = Каталог;
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Утверждения.ПроверитьЛожь(НайденныйКаталог = Неопределено, "в библиотеке должен быть хоть один пакет");
	
	КэшПакетов = Новый КэшУстановленныхПакетов();
	ОписаниеЗависимости = Новый Структура("ИмяПакета, МинимальнаяВерсия, МаксимальнаяВерсия", Каталог.Имя);
	Утверждения.ПроверитьИстину(КэшПакетов.ПакетУстановлен(ОписаниеЗависимости), "Должен быть найден пакет " + Каталог.Имя);
	
КонецПроцедуры