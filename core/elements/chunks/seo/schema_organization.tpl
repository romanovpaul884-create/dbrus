{*
  Schema.org Organization (общесайтовый блок).
  Подключается в <head> на каждой странице через chunks/seo/schema.tpl.

  Источники данных — системные настройки MODX:
    site_name, site_url
    dbrus_phone, dbrus_email
    dbrus_city, dbrus_address, dbrus_postal_code, dbrus_region
    dbrus_geo_lat, dbrus_geo_lng           — координаты для GeoCoordinates
    dbrus_open_hours                       — часы работы, например "Mo-Su 09:00-21:00"

    sameAs — ссылки на официальные карточки/профили компании:
      Соцсети:    dbrus_vk, dbrus_telegram, dbrus_youtube, dbrus_whatsapp,
                  dbrus_instagram, dbrus_dzen, dbrus_ok, dbrus_rutube
      Каталоги:   dbrus_yandex_business   (Яндекс.Бизнес / Я.Карты профиль)
                  dbrus_yandex_maps       (если карта отдельным URL)
                  dbrus_2gis              (карточка в 2ГИС)
                  dbrus_google_business   (Google Business Profile)
                  dbrus_yandex_market     (магазин на Яндекс.Маркете, опц.)
                  dbrus_avito             (профиль на Авито, опц.)
                  dbrus_zoon              (профиль на Zoon, опц.)
                  dbrus_yandex_uslugi     (Яндекс.Услуги, опц.)

    dbrus_logo  (путь относительно сайта, по умолчанию /assets/templates/dbrus/images/logo.svg)
*}
{var $cfg = $_modx->config}
{var $url = $cfg.site_url}
{var $logo = $cfg.dbrus_logo ?: 'assets/templates/dbrus/images/logo.svg'}

{var $org = [
    '@context' => 'https://schema.org',
    '@type'    => 'Organization',
    '@id'      => $url ~ '#organization',
    'name'     => $cfg.site_name,
    'url'      => $url,
    'logo'     => [
        '@type' => 'ImageObject',
        'url'   => $url ~ ltrim($logo, '/')
    ]
]}

{if $cfg.dbrus_phone}{set $org['telephone'] = $cfg.dbrus_phone}{/if}
{if $cfg.dbrus_email}{set $org['email'] = $cfg.dbrus_email}{/if}

{if $cfg.dbrus_city || $cfg.dbrus_address}
    {var $addr = ['@type' => 'PostalAddress', 'addressCountry' => 'RU']}
    {if $cfg.dbrus_region}{set $addr['addressRegion'] = $cfg.dbrus_region}{/if}
    {if $cfg.dbrus_city}{set $addr['addressLocality'] = $cfg.dbrus_city}{/if}
    {if $cfg.dbrus_address}{set $addr['streetAddress'] = $cfg.dbrus_address}{/if}
    {if $cfg.dbrus_postal_code}{set $addr['postalCode'] = $cfg.dbrus_postal_code}{/if}
    {set $org['address'] = $addr}
{/if}

{if $cfg.dbrus_geo_lat && $cfg.dbrus_geo_lng}
    {set $org['geo'] = [
        '@type'     => 'GeoCoordinates',
        'latitude'  => (string)$cfg.dbrus_geo_lat,
        'longitude' => (string)$cfg.dbrus_geo_lng
    ]}
{/if}

{if $cfg.dbrus_open_hours}
    {set $org['openingHours'] = $cfg.dbrus_open_hours}
{/if}

{*
  sameAs — собираем все официальные профили: соцсети + каталоги
  (Яндекс.Бизнес, 2ГИС, Google Business и т.п.). Помогает поисковикам
  связать сайт с известными карточками компании.
*}
{var $sameAsKeys = [
    'dbrus_vk', 'dbrus_telegram', 'dbrus_youtube', 'dbrus_whatsapp',
    'dbrus_instagram', 'dbrus_dzen', 'dbrus_ok', 'dbrus_rutube',
    'dbrus_yandex_business', 'dbrus_yandex_maps', 'dbrus_2gis',
    'dbrus_google_business', 'dbrus_yandex_market', 'dbrus_avito',
    'dbrus_zoon', 'dbrus_yandex_uslugi'
]}
{var $sameAs = []}
{foreach $sameAsKeys as $key}
    {if $cfg[$key]}{set $sameAs[] = $cfg[$key]}{/if}
{/foreach}
{if $sameAs}{set $org['sameAs'] = $sameAs}{/if}

<script type="application/ld+json">{$org | json_encode : 320}</script>
