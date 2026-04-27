# dbrus.ru — рабочее саммери проекта

> Этот документ — точка входа для любого нового чата по проекту.
> **Читать первым**, прежде чем что-либо править.
>
> Последнее обновление: 2026-04-27. Ветка: `claude/start-modx-project-ecQN7`.

---

## 1. Что за проект

- Сайт **dbrus.ru** — продаёт типовые проекты каркасных домов.
- Стек: **MODX Revolution 2.8.5-pl** + pdoTools (Fenom) + miniShop2 +
  ms2gallery + msearch2 + mFilter2 + seoPro + Login.
- Базовый URL: `https://dbrus.ru/`
- Сервер: shared hosting, корень `/home/a/artemkd6/dbrus_2023/public_html/`.
- **У ассистента НЕТ прямого FTP/SSH к серверу.** Работаем через git;
  пользователь руками выгружает изменённые файлы на сервер.

---

## 2. Архитектура шаблонов

Системная настройка `pdotools_fenom_options.templates.dir` указывает на
**`core/elements/`**. Поэтому путь `file:new_design/...` в Fenom
резолвится в `core/elements/new_design/...`.

```
core/elements/new_design/
├── main/        ← meta.tpl, header.tpl, footer.tpl, modals.tpl, scripts.tpl
│                  (meta.tpl содержит <head> — сюда подключаем SEO)
├── sections/    ← meta.tpl (legacy/минимальный), header.tpl, footer.tpl,
│                  faq.tpl, tags.tpl
├── pages/       ← index.tpl (главная), projects.tpl (каталог проектов),
│                  houses.tpl (выставочные дома), capital.tpl, faq.tpl,
│                  mortgage.tpl
├── tpls/        ← productItem_project.tpl, productItem_house.tpl,
│                  productItem_house_slide.tpl, mainMenu_item.tpl, forms/
├── mfilter/     ← mFilter_houses.Outer.tpl
├── components/
└── seo/         ← наши JSON-LD чанки (добавлены в этом чате)
```

В админке MODX **базовый шаблон** содержит только:

```fenom
{include 'file:new_design/pages/index.tpl'}
[[$jivoChat]]
```

Контента в чанках MODX почти нет — всё в файлах. Кроме того, что вынесено
в БД-чанки исторически: `[[$metrika]]`, `[[$jivoChat]]` и т.п.

---

## 3. Системные настройки (префикс `dbrus_*`)

Все заведены пользователем (см. `upload/sistems-nasto.txt`).

**Заполненные:**

| Ключ | Значение |
|---|---|
| `dbrus_phone` | `+74957557617` |
| `dbrus_email` | `info@d-brus.ru` |
| `dbrus_city` | `Москва` |
| `dbrus_address` | `м. Домодедовская Каширское шоссе, вл. 63` |
| `dbrus_postal_code` | `115583` |
| `dbrus_geo_lat` / `_lng` | `55.607794` / `37.721265` |
| `dbrus_open_hours` | `Mo-Su 09:00-21:00` |
| `dbrus_logo` | `assets/template/images/svg/logo_mobile.svg` |
| `dbrus_search_url_template` | `search?q={search_term_string}` |
| `dbrus_telegram` | `https://t.me/dbrussk` |
| `dbrus_youtube` | `https://www.youtube.com/@dbrus` |
| `dbrus_yandex_business` | `https://yandex.ru/profile/108290001484?lang=ru` |
| `dbrus_yandex_maps` | то же |
| `dbrus_2gis` | `https://2gis.ru/moscow/firm/70000001025900066` |
| `dbrus_zoon` | `https://zoon.ru/msk/building/...` |

**Пустые / ждут заполнения:** `dbrus_vk`, `dbrus_rutube`,
`dbrus_schema_template_map` (важно для Article/Product — см. п. 5).

**Существующие настройки фронта (НЕ ТРОГАЕМ):** `front_phone`,
`front_message`, `front_email` и пр. Они используются в `header.tpl`
для отображения. Наша SEO-разметка читает только `dbrus_*`.

---

## 4. TV проектов домов (уже существуют)

Имена видны в `index.tpl` через `mFilter2` / `pdoPage` `includeTVs`:

| TV | Что значит | Куда идёт в Schema |
|---|---|---|
| `house_namem` | название проекта | `Product.name` |
| `house_name` | внутренний код/имя | `Product.sku` (fallback) |
| `house_cost` | цена ₽ (только число!) | `Product.offers.price` |
| `house_size` | габариты `10x12` | `additionalProperty` |
| `house_square` | общая площадь, м² | `additionalProperty` |
| `house_floors_upd` | этажность | `additionalProperty` |
| `house_style` | стиль | `additionalProperty` |
| `built_house_type` | тип постройки | `additionalProperty` |
| `house_popular` | флаг для фильтра | (не идёт в JSON) |

**Картинки проекта**: TV `house_image_main` нет. Чанк `schema_house.tpl`
делает fallback через `pdoResources` к `msResourceFile` (ms2gallery).

**TV для статей (не существуют, нужно создать):**
`article_image`, `article_author`, `article_summary`, `article_section`,
`article_image_width`, `article_image_height`.

---

## 5. SEO-микроразметка — где, что, как

### Файлы

`core/elements/new_design/seo/`

| Файл | Тип Schema.org | Статус |
|---|---|---|
| `schema.tpl` | оркестратор | ✅ деплой |
| `schema_organization.tpl` | `Organization` (sameAs: соцсети + Я.Бизнес + 2ГИС + Зун + …) | ✅ деплой, Google ОК |
| `schema_website.tpl` | `WebSite` + `SearchAction` | ✅ деплой |
| `schema_breadcrumb.tpl` | `BreadcrumbList` | 🟡 фикс в коммите `fe806e4` ждёт деплоя |
| `schema_article.tpl` | `Article` | 🔜 в git, не активирован |
| `schema_house.tpl` | `Product` (под house TVs + ms2gallery) | 🔜 в git, не активирован |

### Подключение в `meta.tpl`

`core/elements/new_design/main/meta.tpl`, **прямо перед `</head>`**:

```fenom
{include 'file:new_design/seo/schema.tpl'}
```

### Что какой страницей рендерится

Оркестратор `schema.tpl` **всегда** выводит Organization + WebSite +
Breadcrumb. Контекстный блок (Article или House) — выбирается по:

- TV `resource_schema_type` (значения `article`, `house`, `none`) на
  конкретном ресурсе — приоритет, ИЛИ
- системной настройке `dbrus_schema_template_map` (карта
  `id_шаблона:тип`, например `5:article, 7:house, 8:house`).

На главной (id == site_start) Breadcrumb не выводится (внутри чанка
есть `{if id != site_start}`).

---

## 6. Грабли Fenom 2.x на pdoTools для MODX 2.8 ⚠️

**Каждый раз при правке `.tpl` нужно учитывать.**

1. **PHP-style касты НЕ работают**: `(string) $x`, `(int) $x`, `(float) $x` →
   ломают Fenom-компиляцию.
   - Заменять на `strval($x)`, `intval($x)`, `floatval($x)`.

2. **Анонимные функции с `use ()` НЕ работают**:
   `{var $f = function($x) use ($url) { ... }}` ломает компиляцию.
   - Делать inline-условия / прямые проверки вместо лямбд.

3. **Двойной парсинг output**: pdoTools пропускает результат рендера
   чанка через Fenom **повторно**. Любой `{` в выводе, за которым **нет
   пробела/переноса**, парсится как Fenom-тег → fatal error.
   - **Для структуры JSON**: `json_encode($x : 448)` — флаг 448 =
     `JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT`.
     PRETTY_PRINT даёт перенос после каждого `{`, Fenom считает текстом.
   - **Для `{...}` внутри строковых значений** (например, литерал
     `{search_term_string}` в URL-шаблоне): через маркеры подменять
     `{` → `__JSON_LB__`, `}` → `__JSON_RB__`, после `json_encode`
     заменить маркеры на `{` / `}` (текстовые,
     **не** на сами скобки!). JSON-парсер декодирует обратно.
   - **В исходнике `.tpl`** избегать литеральных `{` / `}` вне Fenom-тегов —
     даже в комментариях `{* *}` и в одиночных кавычках. Строить через
     `chr(123)` / `chr(125)`. Эталон — `schema_website.tpl`.

4. **`$_modx->makeUrl(site_start, '', '', 'full')`** возвращает **пустую
   строку** в этой конфигурации. Для главной всегда брать
   `$cfg['site_url']` напрямую.

5. **`$_modx->config['key']`** — обращение через `[]` стабильнее, чем
   `$_modx->config.key`. Проект использует bracket-стиль (`header.tpl`).

---

## 7. Цикл деплоя (для пользователя)

1. Скачать изменённый `.tpl` из ветки `claude/start-modx-project-ecQN7`.
2. Положить на сервер по тому же пути (через FTP / файловый менеджер
   хостинга).
3. **ОБЯЗАТЕЛЬНО**: удалить содержимое `core/cache/default/` — иначе
   Fenom продолжит использовать скомпилированную старую версию. Это
   главная причина повторов «исправил, а ничего не изменилось».
   Штатная кнопка «Очистить кэш» в админке не всегда чистит Fenom-кэш.
4. Обновить страницу с Ctrl+F5.
5. Проверить через Rich Results Test
   (https://search.google.com/test/rich-results) или Ctrl+U → искать
   `application/ld+json`.

При падении сайта — первое действие: **снять `{include}`** из `meta.tpl`,
очистить кэш, поднять сайт, потом разбирать `core/cache/logs/error.log`
и присылать в чат.

---

## 8. Текущий статус (на 27.04.2026)

- [x] Сайт жив с подключённой SEO-разметкой.
- [x] Google валидирует `Organization` на главной (зелёный).
- [x] Google валидирует `WebSite` (с SearchAction).
- [x] Google **автоматически распознаёт `LocalBusiness`** из Organization
      + телефона + адреса + гео + open_hours.
- [ ] `BreadcrumbList`: ошибка «отсутствует поле item» у пункта
      «Главная». Фикс в коммите `fe806e4` (зашёл в git, ждёт деплоя
      на сервер).
- [ ] `Article` для статей — чанк готов, не активирован. Нужно:
  - создать TV `article_*` (см. п. 4),
  - привязать к шаблону страницы статьи,
  - вписать ID шаблона в `dbrus_schema_template_map`.
- [ ] `Product` для проектов домов — чанк готов, не активирован.
  Нужно вписать ID шаблона карточки проекта в
  `dbrus_schema_template_map`. TV для домов уже существуют.
- [ ] Минорные рекомендации Google для `LocalBusiness` (`priceRange`,
      `image` в нужном формате) — опционально, добивать потом.

---

## 9. Хронология коммитов в этом чате

```
chore: initialize MODX Revolution 3 project skeleton
feat(seo): add schema.org JSON-LD chunks (site-wide + Article + House)
feat(seo): include Yandex.Business / 2GIS / Google Business in Organization sameAs
docs: add step-by-step schema.org integration guide for MODX beginners
chore: add upload/ folder for staging HTML pages from server
refactor(seo): move chunks to new_design/seo, align with real templates and TVs
fix(seo): replace PHP-style casts with strval/intval/floatval (Fenom on MODX 2.8)
fix(seo): emit JSON-LD with JSON_PRETTY_PRINT to dodge Fenom token scanner
fix(seo): unicode-escape literal {search_term_string} in WebSite SearchAction
fix(seo): build all braces in schema_website.tpl via chr() so Fenom never sees a literal brace
fix(seo): use site_url for the home item in BreadcrumbList
```

---

## 10. Справочные материалы в `upload/`

- `main-html.txt` — рендер главной (исторический, до правок).
- `project-html.txt` — рендер каталога проектов.
- `stati-html.txt` — рендер списка статей.
- `sistems-nasto.txt` — дамп всех системных настроек MODX.
- `log-error.txt` — фрагмент `core/cache/logs/error.log`.
- `a5152c5f4d08b75b7ee9f863335cabe3.zip` — полный архив папки
  `core/elements/new_design/` с сервера. Распаковать и заглядывать,
  если нужно понять, как устроен какой-то существующий блок.

---

## 11. Связанные документы в репо

- `docs/schema-org-instruction.md` — инструкция «с нуля», как внедрять
  SEO-микроразметку. Часть теперь устарела (Шаг 2 — был про создание
  чанков в админке, мы перешли на файловый сценарий), но Шаг 1
  (системные настройки) и Шаг 6 (валидация) актуальны.

---

## 12. Стартовый промт для нового чата

Скопировать целиком как первое сообщение в новом чате:

```
Продолжаем проект dbrus.ru. Полный контекст и статус — в `docs/project-summary.md`. Прочитай его первым делом, прежде чем что-либо менять.

Сейчас нужно сделать:
<ВПИСАТЬ ЗАДАЧУ>

Учти грабли Fenom 2.x из секции 6 саммери (PHP-касты ломают, анонимные функции ломают, двойной парсинг output, литералы { } в .tpl, makeUrl для site_start). Любая правка SEO-чанков требует от пользователя выгрузки файла на сервер + очистки `core/cache/default/`.

Работаем в ветке `claude/start-modx-project-ecQN7`. Прямого SSH/FTP к серверу нет — пользователь руками деплоит изменения по моим указаниям.
```
