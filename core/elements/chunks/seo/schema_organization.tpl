{*
  Schema.org Organization (общесайтовый блок).
  Подключается в <head> на каждой странице через chunks/seo/schema.tpl.

  Источники данных — системные настройки MODX:
    site_name, site_url
    dbrus_phone, dbrus_email
    dbrus_city, dbrus_address
    dbrus_vk, dbrus_telegram, dbrus_youtube, dbrus_whatsapp
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
    {if $cfg.dbrus_city}{set $addr['addressLocality'] = $cfg.dbrus_city}{/if}
    {if $cfg.dbrus_address}{set $addr['streetAddress'] = $cfg.dbrus_address}{/if}
    {set $org['address'] = $addr}
{/if}

{var $sameAs = []}
{foreach ['dbrus_vk', 'dbrus_telegram', 'dbrus_youtube', 'dbrus_whatsapp'] as $key}
    {if $cfg[$key]}{set $sameAs[] = $cfg[$key]}{/if}
{/foreach}
{if $sameAs}{set $org['sameAs'] = $sameAs}{/if}

<script type="application/ld+json">{$org | json_encode : 320}</script>
