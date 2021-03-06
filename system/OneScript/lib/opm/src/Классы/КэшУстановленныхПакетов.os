﻿
#Использовать logos

Перем Лог;

// Массив каталогов в порядке возрастания приоритета
Перем МассивКаталоговПоискаБиблиотек;

Перем УстановленныеПакеты;

Функция ПакетУстановлен(Знач ОписаниеЗависимости) Экспорт
	
	Перем УстановленныеПакеты;
	УстановленныеПакеты = ПолучитьУстановленныеПакеты();

	ПакетУстановлен = УстановленныеПакеты.Получить(ОписаниеЗависимости.ИмяПакета) <> Неопределено;
	
	КаталогБиблиотек = ОбъединитьПути(КаталогПрограммы(), ПолучитьЗначениеСистемнойНастройки("lib.system"));
	ПутьКФайлуМетаданных = ОбъединитьПути(
		КаталогБиблиотек,
		ОписаниеЗависимости.ИмяПакета,
		КонстантыOpm.ИмяФайлаМетаданныхПакета
	);
	ФайлМетаданных = Новый Файл(ПутьКФайлуМетаданных);
	Если ФайлМетаданных.Существует() Тогда	
		МетаОписаниеПакета = ПрочитатьМетаданныеПакета(ПутьКФайлуМетаданных);
		УстановленнаяВерсия = МетаОписаниеПакета.Свойства().Версия;	
	Иначе
		// @deprecated
		УстановленнаяВерсия = 0;
	КонецЕсли;
	Лог.Отладка("ПакетУстановлен: Перед вызовом СравнитьВерсии(ЭтаВерсия = <%1>, БольшеЧемВерсия = <%2>)", УстановленнаяВерсия, ОписаниеЗависимости.МинимальнаяВерсия);
	
	УстановленаКорректнаяВерсия = ОписаниеЗависимости.МинимальнаяВерсия = Неопределено
		ИЛИ РаботаСВерсиями.СравнитьВерсии(УстановленнаяВерсия, ОписаниеЗависимости.МинимальнаяВерсия) >= 0;
	Лог.Отладка("Установлена корректная версия: " + УстановленаКорректнаяВерсия);
	Возврат ПакетУстановлен И УстановленаКорректнаяВерсия;
	
КонецФункции

Процедура Обновить() Экспорт
	
	Для Каждого КаталогБиблиотек Из МассивКаталоговПоискаБиблиотек Цикл

		Лог.Отладка("КаталогБиблиотек " + КаталогБиблиотек);
		УстановленныеПакеты = Новый Соответствие;

		НайденныеФайлы = НайтиФайлы(КаталогБиблиотек, ПолучитьМаскуВсеФайлы());
		Для Каждого ФайлКаталога Из НайденныеФайлы Цикл
			Если ФайлКаталога.ЭтоКаталог() Тогда

				// ДобавитьУстановленныйПакет заменит уже добавленный пакет при совпадении имён
				// Соответственно, более поздние каталоги будут иметь приоритет
				ДобавитьУстановленныйПакет(ФайлКаталога);

			КонецЕсли;
		КонецЦикла;

	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьУстановленныеПакеты() Экспорт

	Если УстановленныеПакеты = Неопределено Тогда
		Обновить();
	КонецЕсли;

	Возврат УстановленныеПакеты;

КонецФункции

Процедура Инициализация()
	
	Лог = Логирование.ПолучитьЛог("oscript.app.opm");
	МассивКаталоговПоискаБиблиотек = Новый Массив;

	КаталогСистемныхБиблиотек = ОбъединитьПути(
			КаталогПрограммы(),
			ПолучитьЗначениеСистемнойНастройки("lib.system")
	);

	МассивКаталоговПоискаБиблиотек.Добавить(КаталогСистемныхБиблиотек);
	
КонецПроцедуры

// Добавляет каталог в список, по которому выполняется поиск библиотек
Процедура ДобавитьКаталогБиблиотек(Знач Каталог) Экспорт

	МассивКаталоговПоискаБиблиотек.Добавить(Каталог);

КонецПроцедуры

Процедура ДобавитьУстановленныйПакет(Знач ФайлКаталога)
	
	ПутьКФайлуМетаданных = ОбъединитьПути(ФайлКаталога.ПолноеИмя, КонстантыOpm.ИмяФайлаМетаданныхПакета);
	ФайлМетаданных = Новый Файл(ПутьКФайлуМетаданных);
	Если ФайлМетаданных.Существует() Тогда	
		МетаОписаниеПакета = ПрочитатьМетаданныеПакета(ПутьКФайлуМетаданных);	
	Иначе
		// @deprecated
		МетаОписаниеПакета = Истина;
	КонецЕсли;
	
	УстановленныеПакеты.Вставить(ФайлКаталога.Имя, МетаОписаниеПакета);
	
КонецПроцедуры

Функция ПрочитатьМетаданныеПакета(Знач ПутьКФайлуМетаданных)
	
	Перем Метаданные;
	Попытка
		Чтение = Новый ЧтениеXML;
		Чтение.ОткрытьФайл(ПутьКФайлуМетаданных);
		Сериализатор = Новый СериализацияМетаданныхПакета;
		Метаданные = Сериализатор.ПрочитатьXML(Чтение);
		
		Чтение.Закрыть();
	Исключение
		Чтение.Закрыть();
		ВызватьИсключение;
	КонецПопытки;

	Возврат Метаданные;
	
КонецФункции

Инициализация();
