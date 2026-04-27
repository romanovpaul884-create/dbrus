{*
  Schema.org WebSite (общесайтовый блок).
  Включает SearchAction для внутреннего поиска по сайту.

  Параметры через системные настройки:
    site_name, site_url, cultureKey
    dbrus_search_url_template — URL-шаблон поиска. Должен содержать
        литерал search_term_string в фигурных скобках (это требование
        Google для SearchAction). Пример значения:
            search?q=LBsearch_term_stringRB
        где LB и RB — обычные фигурные скобки. В этом файле они
        нигде не пишутся напрямую, чтобы не запутать Fenom-токенизатор;
        вместо них используется chr(123) и chr(125).

  Логика экранирования: значение шаблона приходит из настройки уже
  с фигурными скобками. До json_encode скобки заменяются на маркеры,
  после json_encode — на JSON unicode-эскейпы (Bsequence, Csequence
  ниже строятся через chr(92) ~ 'u007B' и т.п.). JSON-парсеры (Google,
  Yandex, validator.schema.org) декодируют эскейпы обратно. А Fenom при
  повторной токенизации собственного вывода не видит литеральной скобки
  перед идентификатором и не падает.
*}
{var $cfg  = $_modx->config}
{var $url  = $cfg['site_url']}
{var $lang = $cfg['cultureKey'] ?: 'ru-RU'}

{* {  и  }  без литералов в исходнике *}
{var $LB    = chr(123)}
{var $RB    = chr(125)}
{var $LBesc = chr(92) ~ 'u007B'}
{var $RBesc = chr(92) ~ 'u007D'}

{* Шаблон поиска: либо настройка, либо безопасный дефолт *}
{var $searchTpl = $cfg['dbrus_search_url_template'] ?: ('search?q=' ~ $LB ~ 'search_term_string' ~ $RB)}

{* До json_encode скобки → маркеры, чтобы они не дошли до выходного JSON в виде литерала *}
{var $searchTplSafe = str_replace([$LB, $RB], ['__JSON_LB__', '__JSON_RB__'], $searchTpl)}

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
{* После json_encode маркеры → unicode-эскейпы ({ / }); в выводе нет литеральной {  *}
{set $json = str_replace(['__JSON_LB__', '__JSON_RB__'], [$LBesc, $RBesc], $json)}
<script type="application/ld+json">{$json}</script>
