{*
  Schema.org WebSite (общесайтовый блок).
  Включает SearchAction — подсказка Google для поля внутреннего поиска.

  Параметры через системные настройки:
    site_name, site_url, cultureKey
    dbrus_search_url_template (по умолчанию search?q={search_term_string})

  ВАЖНО: значение dbrus_search_url_template (и любой URL c фигурными
  скобками, например google-style {search_term_string}) проходит
  безопасный пост-эскейп: { → {, } → }. JSON-парсеры (включая
  Google и Яндекс) декодируют unicode-эскейпы обратно в { и }, так что
  для поисковика результат идентичен. А Fenom при повторной токенизации
  собственного вывода не увидит {literal — и не упадёт.
*}
{var $cfg = $_modx->config}
{var $url = $cfg['site_url']}
{var $searchTpl = $cfg['dbrus_search_url_template'] ?: 'search?q={search_term_string}'}
{var $lang = $cfg['cultureKey'] ?: 'ru-RU'}

{*
  Подменяем фигурные скобки в шаблоне поиска на маркеры до того, как
  значение попадёт в json_encode. Так оно не пройдёт через двойную
  json-эскейп (\\u007B вместо нужного {).
*}
{var $searchTplSafe = str_replace(['{', '}'], ['__JSON_LB__', '__JSON_RB__'], $searchTpl)}

{var $site = [
    '@context'        => 'https://schema.org',
    '@type'           => 'WebSite',
    '@id'             => $url ~ '#website',
    'url'             => $url,
    'name'            => $cfg['site_name'],
    'inLanguage'      => $lang,
    'publisher'       => ['@id' => $url ~ '#organization'],
    'potentialAction' => [
        '@type'       => 'SearchAction',
        'target'      => [
            '@type'       => 'EntryPoint',
            'urlTemplate' => $url ~ ltrim($searchTplSafe, '/')
        ],
        'query-input' => 'required name=search_term_string'
    ]
]}

{var $json = $site | json_encode : 448}
{set $json = str_replace(['__JSON_LB__', '__JSON_RB__'], ['{', '}'], $json)}
<script type="application/ld+json">{$json}</script>
