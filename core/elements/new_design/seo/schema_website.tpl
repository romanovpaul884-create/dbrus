{*
  Schema.org WebSite (общесайтовый блок).
  Включает SearchAction — подсказка Google для поля внутреннего поиска.

  Параметры через системные настройки:
    site_name, site_url, cultureKey
    dbrus_search_url_template (по умолчанию search?q={search_term_string})
*}
{var $cfg = $_modx->config}
{var $url = $cfg['site_url']}
{var $searchTpl = $cfg['dbrus_search_url_template'] ?: 'search?q={search_term_string}'}
{var $lang = $cfg['cultureKey'] ?: 'ru-RU'}

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
            'urlTemplate' => $url ~ ltrim($searchTpl, '/')
        ],
        'query-input' => 'required name=search_term_string'
    ]
]}

<script type="application/ld+json">{$site | json_encode : 448}</script>
