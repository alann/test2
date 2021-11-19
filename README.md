Пример выполнения тестового задания

Первая часть

Разработать процесс регистрации пользователя: a. Экран со следующими элементами i. Фамилия (обязательное поле) ii. Имя (обязательное поле) iii. Отчество (обязательное поле) iv. Поле ввода email. Email должен валидироваться по формату (обязательное поле) v. Поле ввода пароля (+ кнопка «Показать пароль», действует на оба поля с паролями, обязательное поле) vi. Поле подтверждения пароля (обязательное поле) vii. Кнопка «Регистрация» b. После нажатия кнопки – валидация данных, после чего отправка данных в метод registerUser (см. Приложение 1), и в случае успешного ответа (код 200) - переход к экрану авторизации c. В случае ошибок валидации – подсвечивать некорректно заполненные поля d. В случае ошибки от сервера – показывать кастомный Toast с описанием ошибки. Toast должен показываться не менее 5 секунд.
Разработать процесс авторизации пользователя в Backend по email и паролю: a. Экран со следующими элементами: i. Поле ввода email. Email должен валидироваться по формату (обязательное поле) ii. Поле ввода пароля (обязательное поле) iii. Кнопка «Авторизация» b. После нажатия кнопки – проверка авторизации методом checkLogin (см. ение 1) и, в случае успешной авторизации – переход к экрану заполнения профиля пользователя (если делается только первая часть – просто белый экран с лого андроида) c. В случае ошибок валидации – подсвечивать некорректно заполненные поля d. В случае ошибки авторизации на сервере – показывать кастомный Toast с описанием ошибки. Toast должен показываться не менее 5 секунд.
Вторая часть

После успешной авторизации (ответ от checkLogin 200), переход на экран заполнения профиля пользователя. Экран содержит: a. Элемент загрузки фото, при нажатие на который появляется диалог выбора фото из галереи или камеры. Выбор влечет за собой открытие соответствующего Intent. После получения фото, оно должно быть отправлено на сервер методом uploadAvatar (см. Приложение 1), который вернет идентификатор фото b. Набор полей: i. Фамилия (обязательное поле) ii. Имя (обязательное поле) iii. Отчество iv. Место рождения (обязательное поле) v. Дата рождения (ввод через DatePicker) vi. Организация vii. Должность viii. Набор интересующих тем (множественный выбор, должен быть выбран ХОТЯ БЫ ОДИН вариант)
Авто
Бизнес
Инвестиции
Спорт
Саморазвитие
Здоровье
Еда
Семья, дети
Домашние питомцы
Фильмы
Компьютерные игры
Музыка c. Кнопка «Сохранить». По нажатии на кнопку «Сохранить» происходит i. Валидация данных. В случае ошибок валидации – подсвечивать некорректно заполненные поля ii. Обновление профиля пользователя методом updateProfile (см. Приложение 1). В случае ошибки обновления профиля на сервере – показывать кастомный Toast с описанием ошибки. Toast должен показываться не менее 5 секунд.
