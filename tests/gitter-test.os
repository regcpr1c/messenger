#Использовать asserts
#Использовать "../"

Перем юТест;
Перем Мессенджер;

Перем ИмяКомнаты;
Перем IdКомнаты;
Перем ТокенПользователя;
Перем ОшибкаВходящихПараметров;

Функция ПолучитьСписокТестов(ЮнитТестирование) Экспорт

	// Мока нет, или задавть параметры тут или передвать через переменные окружения
	// Переменные окружения:
	// GitterToken	
	// GitterRoomId
	// GitterRoomName
	
	ТокенПользователя = ""; // https://developer.gitter.im/apps
	IdКомнаты  = ""; // https://api.gitter.im/v1/rooms?access_token=ТокенПользователя
	ИмяКомнаты = ""; // для комнаты https://gitter.im/asosnoviy/Lobby имя будет asosnoviy/Lobby 	
	
	ЗаполнитьПарметрыИзПеременныхОкружения();	


	юТест = ЮнитТестирование;
	
	ВсеТесты = Новый Массив;

	ВсеТесты.Добавить("ТестДолжен_ПроверитьАвторизацию");

	Если ЗначениеЗаполнено(ТокенПользователя) И
		 ЗначениеЗаполнено(IdКомнаты) И
		 ЗначениеЗаполнено(ИмяКомнаты)  Тогда

		ВсеТесты.Добавить("ТестДолжен_ПроверитьПолучениеСпискаКомнат");
		ВсеТесты.Добавить("ТестДолжен_ОтправитьСообщениеВGitterПоidКомнаты");
		ВсеТесты.Добавить("ТестДолжен_ОтправитьСообщениеВGitterПоИмениКомнаты");
		ВсеТесты.Добавить("ТестДолжен_НеНайтиКомнатуПоИмениКомнаты");
		ВсеТесты.Добавить("ТестДолжен_ОтправитьСообщениеМетодомОтправитьСообщение");
		ВсеТесты.Добавить("ТестДолжен_ПроверитьОтправкуМногострочногоСообщения");

	Иначе

		Сообщить("Не заполненны входящие параметры");
		Сообщить("Тест ТестДолжен_ПроверитьПолучениеСпискаКомнат будет пропущен");
		Сообщить("Тест ТестДолжен_ОтправитьСообщениеВGitterПоidКомнаты будет пропущен");
		Сообщить("Тест ТестДолжен_НеНайтиКомнатуПоИмениКомнаты будет пропущен");
		Сообщить("Тест ТестДолжен_ОтправитьСообщениеВGitterПоИмениКомнаты будет пропущен");
		Сообщить("Тест ТестДолжен_ОтправитьСообщениеМетодомОтправитьСообщение будет пропущен");
		Сообщить("Тест ТестДолжен_ПроверитьОтправкуМногострочногоСообщения будет пропущен");

	КонецЕсли;

	Возврат ВсеТесты;

КонецФункции

Процедура ПередЗапускомТеста() Экспорт

	Мессенджер = Новый Мессенджер();
		
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт

	Мессенджер = Неопределено;

КонецПроцедуры

Процедура ТестДолжен_ПроверитьАвторизацию() Экспорт
	
	НеверныйТокенПользователя = "123";

	Попытка
		Мессенджер.ИнициализацияGitter(НеверныйТокенПользователя);
	Исключение
		Ожидаем.Что(ОписаниеОшибки(), "Должен Упасть С Ошибкой авторизации").Содержит("Ошибка авторизации");
	КонецПопытки

КонецПроцедуры

Процедура ТестДолжен_ПроверитьПолучениеСпискаКомнат() Экспорт

	Мессенджер.ИнициализацияGitter(ТокенПользователя);
	
	Ожидаем.Что(Мессенджер.ДоступныеПротоколы().Количество(), "Количество доступных протоколов 3").Равно(3);
	Ожидаем.Что(Мессенджер.АвторизацияGitter.Токен, "Токен должен инициализироватся").Равно(ТокенПользователя) ;
	Ожидаем.Что(Мессенджер.АвторизацияGitter.Комнаты.Количество(), "Комнаты Должны быть").Больше(0) ;
	Ожидаем.Что(Мессенджер.АвторизацияGitter.Комнаты.Получить(ИмяКомнаты), "Комнаты Должны совпадать с id").Равно(IdКомнаты) ;

КонецПроцедуры

Процедура ТестДолжен_ОтправитьСообщениеВGitterПоidКомнаты() Экспорт

	Мессенджер.ИнициализацияGitter(ТокенПользователя);

	Мессенджер.ОтправитьСообщениеВКомнатуGitter(IdКомнаты,"Тестовое сообщение по IdКомнаты " + Строка(ТекущаяДата()));

КонецПроцедуры	

Процедура ТестДолжен_ОтправитьСообщениеВGitterПоИмениКомнаты() Экспорт

	Мессенджер.ИнициализацияGitter(ТокенПользователя);
	Мессенджер.ОтправитьСообщениеGitter(ИмяКомнаты, "Тестовое сообщение по имени комнаты " + Строка(ТекущаяДата()));

КонецПроцедуры	

Процедура ТестДолжен_НеНайтиКомнатуПоИмениКомнаты() Экспорт

	НевернаяИмяКомнаты = "КомнатаКоторойНет";

	Мессенджер.ИнициализацияGitter(ТокенПользователя);

	Попытка
		Мессенджер.ОтправитьСообщениеGitter(НевернаяИмяКомнаты, "Тестовое сообщение по имени комнаты " + Строка(ТекущаяДата()));
	Исключение
		Ожидаем.Что(ОписаниеОшибки(), "Должен Упасть С Ошибкой комната не найдена").Содержит("Комната не найдена в списке");
	КонецПопытки

КонецПроцедуры	

Процедура ТестДолжен_ОтправитьСообщениеМетодомОтправитьСообщение() Экспорт

	Мессенджер.ИнициализацияGitter(ТокенПользователя);
	Мессенджер.ОтправитьСообщение(Мессенджер.ДоступныеПротоколы().gitter, ИмяКомнаты, "Тестовое сообщение Методом отправить сообщение " + Строка(ТекущаяДата()));

КонецПроцедуры	

Процедура ТестДолжен_ПроверитьОтправкуМногострочногоСообщения() Экспорт

	Мессенджер.ИнициализацияGitter(ТокенПользователя);

	Сообщение = СтрШаблон(
			"Многострочная строка сейчас будет ПС %1 Это уже вторая строка, сейчас будет ВК %2А это урл: %3 Дата:%4",
			Символы.ПС,
			Символы.ВК,
			"http://git",
		Строка(ТекущаяДата())
		);
		
	Мессенджер.ОтправитьСообщение(Мессенджер.ДоступныеПротоколы().gitter, ИмяКомнаты, Сообщение);

КонецПроцедуры	

Процедура ЗаполнитьПарметрыИзПеременныхОкружения()
	

	СИ = Новый СистемнаяИнформация();
	ПеременныеСреды = СИ.ПеременныеСреды();

	Если НЕ ЗначениеЗаполнено(ТокенПользователя) И НЕ ПеременныеСреды["GitterToken"] = Неопределено Тогда
		ТокенПользователя = ПеременныеСреды["GitterToken"];
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(IdКомнаты) И НЕ ПеременныеСреды["GitterRoomId"] = Неопределено Тогда
		IdКомнаты = ПеременныеСреды["GitterRoomId"];
	КонецЕсли;	

	Если НЕ ЗначениеЗаполнено(ИмяКомнаты) И НЕ ПеременныеСреды["GitterRoomName"] = Неопределено Тогда
		ИмяКомнаты = ПеременныеСреды["GitterRoomName"];
	КонецЕсли;	

КонецПроцедуры	
