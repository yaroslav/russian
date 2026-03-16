# gem russian

**Russian language support for Ruby and Rails**: localization, date and time handling, pluralization, and improved Russian language support in Rails.


**Поддержка русского языка для Ruby и Rails**: локализация, работа с датой и временем, плюрализация, локализация, улучшенная поддержка русского языка в Rails.

[![CI](https://github.com/yaroslav/russian/actions/workflows/ci.yml/badge.svg)](https://github.com/yaroslav/russian/actions/workflows/ci.yml)
[![Docs](https://img.shields.io/badge/yard-docs-blue.svg)](https://rubydoc.info/gems/russian)

## Features

- **Russian date and time localization** (`strftime`)
- **Russian date and time parsing** (`strptime`)
- Correct Russian **pluralization** (`"1 вещь"`, `"9 вешей"`)
- **Cyrillic transliteration** (`transliterate`)
- A simple proxy for the `i18n` gem with the Russian locale enforced

With Ruby on Rails:

- All necessary **Russian localization** through Rails’ built-in mechanisms (`i18n`)
- **Support for contextual month names in date and time helpers** (`[Март ↓] [2026 ↓]`, but `[01 ↓] [марта ↓] [2026 ↓]`)
- **Custom validation error messages** without the attribute name at the beginning (`"You need to accept the license agreement"` instead of something like `"License agreement accepted must be present"`)
- Working Russian **pluralization**
- Working Russian **transliteration**, which can also be used for `to_param` when building “pretty” URLs (`posts/42-privet-mir`)


## Что умеет

- **Русская локализация даты и времени** (`strftime`)
- **Разбор даты и времени** на русском языке (`strptime`)
- Корректную **плюрализацию** для русского языка ("1 вещь", "9 вещей")
- **Транслитерация** кириллицы (`transliterate`)
- Простой прокси для gem i18n с явным пробросом русской локали

С Ruby on Rails:

- Всю необходимую **локализацию на русский язык** через встроенные в Rails механизмы (gem i18n)
- **Поддержка контекстных имен месяцев в хелперах** выбора даты и времени (`[Март ↓] [2026 ↓]`, но `[01 ↓] [марта ↓] [2026 ↓]`)
- **Особые сообщения об ошибках валидации** без явного названия атрибута в начале ("Нужно принять лицензионное соглашение", вместо чего-то вроде "Лицензионное соглашение принято должно присутствовать")
- Рабочая **плюрализация** для русского языка
- Рабочая **транслитерация** для русского языка, которая в том числе может использоваться для `to_param` при составлении "красивых" URL (`posts/42-privet-mir`)

## When to use

- Your application is entirely in Russian or another Cyrillic language
- Your application supports only a small number of languages, and **Russian is one of them or the primary one**

When not to use it:

- Your application targets many languages or uses unusual or complex I18n backends


## Когда стоит использовать

- **Приложение целиком на русском** или другом кириллическом языке
- Приложение поддерживает небольшое количество языков, но **русский — один из них или основной**

Когда не стоит использовать:

- Приложение сделано для большого количества языков или использует нестандартные или сложные бэкенды для I18n.

# Требования

- Современные версии Ruby и Rails. На момент написания — Ruby 3.2+ или 4.0+, Rails 7.2, 8.0, 8.1;
- Использование с Ruby on Rails не обязательно
- Используйте более ранние версии для устаревших и неподдерживаемых версий Ruby и Rails

# Установка

Для установки:

Через Bundler:

```sh
bundle add russian
bundle install
```

Чтобы задать русскую локаль по умолчанию в вашем приложении, укажите

```ruby
I18n.default_locale = :ru
```

Чтобы установить локаль для текущего Ruby thread, используйте

```ruby
I18n.locale = :ru
```

## Ruby on Rails

После установки через Bundler, укажите

```ruby
config.i18n.default_locale = :ru
```

в `config/application.rb`. Если по умолчанию нужна другая локаль, или же нужно переключать локали "на ходу", используйте методы модуля I18n. 

Также ознакомьтесь с [гидом по интернационализации Ruby on Rails](https://guides.rubyonrails.org/i18n.html).

# Использование

gem russian можно использовать как с Ruby on Rails, так и отдельно: с любым другим веб-фреймворком, или в любом другом приложении. gem i18n, который Ruby on Rails использует для интернационализации, включен в gem russian как зависимость.

## Примеры и справка по переводам (I18n)

Небольшую справку по переводам (I18n) и пример того, как можно переводить имена моделей, атрибутов, и многие другие вещи, определенные в Rails или I18n, можно посмотреть в директории [lib/russian/locale](https://github.com/yaroslav/russian/tree/master/lib/russian/locale). Там находятся файлы переводов, которые используются в Russian, со всеми комментариями.

## Вспомогательные методы модуля Russian

### `locale`

Возвращает локаль русского языка (`:'ru'`).

```ruby
Russian.locale
Russian::LOCALE
```

### `init_i18n`

Выполняется автоматически при загрузке. Добавление русских переводов в путь загрузки стандартного бэкенда I18n, включение модулей для плюрализации и транслитерации и перегрузка I18n.

```ruby
Russian::init_i18n
```

### `translate` / `t`

Прокси для метода `translate` I18n, форсирует использование русской локали.

Поддерживаются и современный вызов с keyword args, и "старый" вызов с positional hash:

```ruby
Russian.translate(:"date.formats.default")
Russian.t(:"date.formats.default", scope: :foo)
Russian.t(:"date.formats.default", {scope: :foo})
```

### `localize` / `l`

Прокси для метода `localize` I18n, форсирует использование русской локали.

Поддерживаются и современный вызов с keyword args, и старый вызов с positional hash:

```ruby
Russian.localize(Date.new(1985, 12, 1), format: :long)
Russian.l(Date.new(1985, 12, 1), {format: :long})
```

### `strftime`

`strftime` с форсированием русской локали (упрощенный вариант `localize`)

```ruby
Russian.strftime(Time.new(2008, 9, 1, 11, 12, 43, "+03:00"), format: :long)
Russian.strftime(Time.new(2008, 9, 1, 11, 12, 43, "+03:00"), {format: :long})

Russian::strftime(Time.new(2008, 9, 1, 11, 12, 43, "+03:00"))
=> "Пн, 01 сент. 2008, 11:12:43 +0300"
Russian::strftime(Time.new(2008, 9, 1, 11, 12, 43, "+03:00"), "%d %B")
=> "01 сентября"
Russian::strftime(Time.new(2008, 9, 1, 11, 12, 43, "+03:00"), "%B")
=> "Сентябрь"
```

### `date_strptime` / `time_strptime` / `datetime_strptime`

Локализованные `strptime`-хелперы для `Date`, `Time` и `DateTime` для разбора даты и времени.

Понимают русские названия месяцев и дней недели, включая case-insensitive ввод.
`format` у `date_strptime` и `datetime_strptime` можно опустить, а `now`
у `time_strptime` остается опциональным, как и в `Time.strptime`.
Все остальные `%`-директивы обрабатываются нативными parser'ами Ruby:
`Date.strptime`, `Time.strptime` и `DateTime.strptime`.

```ruby
Russian.date_strptime("01 апреля 2011", "%d %B %Y")
=> #<Date: 2011-04-01 ...>
Russian.time_strptime("пт, 01 апр. 2011 23:45:05 +0300", "%a, %d %b %Y %H:%M:%S %z")
=> 2011-04-01 23:45:05 +0300
Russian.datetime_strptime("Пятница, 01 апреля 2011 23:45:05 +0300", "%A, %d %B %Y %H:%M:%S %z")
=> #<DateTime: 2011-04-01T23:45:05+03:00 ...>
```

### `pluralize` / `p`

Упрощенная плюрализация для русского языка.

```ruby
Russian.pluralize(1, "вещь", "вещи", "вещей")
=> "вещь"
Russian.p(2, "вещь", "вещи", "вещей")
=> "вещи"
Russian.p(10, "вещь", "вещи", "вещей")
=> "вещей"
Russian.p(3.14, "вещь", "вещи", "вещей", "вещи") # последний вариант используется для дробных величин
=> "вещи"
```

### `transliterate` / `translit`

Транслитерация русских букв в строке.

```ruby
Russian.translit("рубин")
=> "rubin"
Russian.transliterate("Hallo Юлику Тарханову")
=> "Hallo Yuliku Tarhanovu"
```

## Ruby on Rails

Если gem russian используется внутри Rails, интеграция с Rails подключается автоматически через и применяется сразу же, если нужные части фреймворка уже загружены. Для современных версий Rails это дает два эффекта:

После загрузки можно использовать все стандартные функции библиотеки I18n, пользоваться измененным функционалом для лучшей поддержки русского языка, или использовать хелперы модуля Russian для еще более простой работы с русским языком.

### Переводы

При использовании с Ruby on Rails загружаются все стандартные переводы, и русский язык становится годным к использованию для локализации. В поставку включены все нужные переводы для ActionView, ActiveRecord, ActiveSupport, ActiveModel, которые можно переопределять по необходимости стандартными средствами I18n из вашего приложения.

### Хелперы

Хелперы даты-времени получают ключ `:use_standalone_month_names` для форсирования отображения отдельностоящего названия месяца ("Сентябрь" а не "сентября"). Такое имя месяца используется, когда включен ключ `:use_standalone_month_names`, либо когда есть ключ `:discard_day`. Для русской локали `select_month` всегда использует отдельностоящие имена месяцев.

### Валидация

На тот случай, если по каким-то причинам нельзя воспользоваться ключом `full_messages.format` в таблице переводов, Russian перегружает вывод "полных сообщений" об ошибках в ActiveModel.

Так, например,

```ruby
validates :accepted_terms, acceptance: {message: "нужно принять соглашение"}
```

при валидации выдаст сообщение

```text
Accepted terms нужно принять соглашение
```

или, например

```text
Соглашение об использовании нужно принять соглашение
```

если вы указали перевод для имени атрибута.

Но

```ruby
validates :accepted_terms, acceptance: {message: "^Нужно принять соглашение"}
```

даст сообщение

```text
Нужно принять соглашение
```

### Параметризация строк

Метод `parameterize` инфлектора ActiveSupport использует механизмы транслитерации I18n. Если русская локаль является текущей, он сможет поддерживать транслитерацию букв русского алфавита.

Пример:

```erb
class Person
  def to_param
    "#{id}-#{name.parameterize}"
  end
end

@person = Person.find(1)
# => #<Person id: 1, name: "Дональд Кнут">

<%= link_to(@person.name, person_path(@person)) %>
# => <a href="/person/1-donald-knut">Дональд Кнут</a>
```

# Историческая справка

gem russian проектировалась для полноценной поддержки русского языка (форматирование даты и времени, плюрализация, транслит, локализация в целом) для Ruby и Ruby on Rails. Приоритет: построить полноценную среду для русской локализации Ruby и Rails проектов, при этом используя минимально возможное количество хаков, сохраняя при этом поддержку локализации приложения на другие языки, а также форсировать включение в основную ветку I18n и Rails всех функций локализации, необходимых для работы с русским языком. Вместе с командой gem i18n решено было обкатывать решение для русского языка на отдельном gem/плагине, и по мере возможности переносить наиболее общий функционал в "родительскую" библиотеку i18n. Таким образом, общей целью gem russian стала поддержка русского языка до тех пор, пока она не появится в самом I18n.

Библиотека I18n входит в состав Ruby on Rails начиная с версии 2.2. I18n — это самое простое и недеструктивное решение для локализации и интернационализации Rails приложений. К сожалению, в первых версиях отсутствовала поддержка нескольких важных возможностей, специфичных для русского языка. Таким образом, русский язык для локализации в Rails 2.2 фактически не поддерживался.

Для исправления этого досадного недоразумения появилась библиотека Russian. Ранее Russian включал в себя собственный бекенд для перегрузки форматирования даты-времени (использование названия месяца или дня недели в зависимости от контекста) и плюрализации (стандартный бекенд поддерживал только плюрализацию для английского языка), несколько хаков для Rails 2.2/2.3 (ActionView, ActiveRecord, ActiveSupport), полную локализацию даты-времени и таблицы переводов Rails на русский язык, и вспомогательные модули (плюрализация и транслитерация). 

В версии 0.2 `gem i18n` наконец появились первые средства для поддержки русского языка: во многом, из-за gem russian была добавлена поддержка lambda-переводов, благодаря которой стало возможным вынести логику перевода названия месяца/дня недели в таблицу переводов. Далее в `gem i18n` появилась поддержка хранения правил плюрализации в таблице переводов (опять же, с помощью lambda-переводов) и правил транслитерации. 

**Сейчас использование gem russian для русскоязычных приложений — скорее комфорт, а не абсолютная необходимость.** Некоторые из возможностей gem russian никогда не появятся в Rails из коробки.

# Разработка и тестирование

Для локального запуска:

Тесты:

```sh
bundle exec rspec
```

Линтер:

```sh
bundle exec standardrb
```

Rails-интеграцию можно проверять отдельно по gemfile для нужной версии Rails:

```sh
BUNDLE_GEMFILE=gemfiles/rails_7_2.gemfile bundle exec rspec
BUNDLE_GEMFILE=gemfiles/rails_8_0.gemfile bundle exec rspec
BUNDLE_GEMFILE=gemfiles/rails_8_1.gemfile bundle exec rspec
```

# Авторы и благодарности

[Ярослав Маркин](http://yaroslav.io) при участии: [Юлика Тарханова](https://blog.julik.nl), Евгения Пименова, [Дмитрия Смалько](https://github.com/dsmalko), [Алексея Фортуны](https://github.com/dadooda), [Антона Агеева](https://github.com/antage), [Александра Семенова](https://github.com/alsemyonov), [valodzka](https://github.com/valodzka), [Николая Немшилова](https://github.com/MadRabbit), [Дмитрия Куликова](https://github.com/dima4p), [Алексея Саварцова](https://github.com/asavartsov), [Андрея Новикова](https://github.com/Envek), [Игорь Бочкарев](https://github.com/ujifgc).

Огромное спасибо:

[Юлику Тарханову](http://julik.nl) за [rutils](https://github.com/julik/rutils).
