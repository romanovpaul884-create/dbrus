{*
  Schema.org Product — для страниц проектов домов.

  Сайт продаёт типовые проекты домов, поэтому базовый тип — Product
  (готовый продукт-проект), а технические характеристики дома уходят
  в additionalProperty.

  Реальные TV из core/elements/new_design/pages/index.tpl (mFilter2/pdoPage):
    house_namem        — название проекта (бренд-имя дома)
    house_name         — внутреннее имя/код
    house_cost         — цена в рублях (число, без пробелов и валюты)
    house_size         — габариты, например "10x12"
    house_square       — общая площадь, м²
    house_floors_upd   — этажность ("1 этаж", "Полуторный", "2 этажа")
    house_style        — стиль ("Классический", "Современный", …)
    house_popular      — флаг "популярный" (для фильтра, в schema не идёт)
    built_house_type   — тип постройки

  Опциональные TV (заведите при необходимости — пустые отбрасываются):
    house_sku             — артикул проекта
    house_image_main      — главное фото (URL/путь). Если не задан —
                            берём первый файл из ms2gallery (msResourceFile).
    house_currency        — валюта (по умолчанию RUB)
    house_availability    — InStock / PreOrder / OutOfStock (по умолчанию InStock)
    house_material        — материал (брус / каркас / газобетон …)
    house_area_living     — жилая площадь, м²
    house_bedrooms        — количество спален
    house_bathrooms       — количество санузлов
    house_rating_value    — средняя оценка (опц.)
    house_rating_count    — количество отзывов (опц.)
*}
{var $r       = $_modx->resource}
{var $cfg     = $_modx->config}
{var $url     = $cfg['site_url']}
{var $resUrl  = $_modx->makeUrl($r.id, '', '', 'full')}

{*
  Главное изображение — приоритет TV house_image_main, fallback —
  первый файл из ms2gallery (msResourceFile).
*}
{var $images = []}
{var $main = $r.house_image_main}
{if $main}
    {if preg_match('~^https?://~', $main)}
        {set $images[] = $main}
    {else}
        {set $images[] = $url ~ ltrim($main, '/')}
    {/if}
{/if}

{if !$images}
    {var $rows = $_modx->runSnippet('!pdoResources', [
        'class'   => 'msResourceFile',
        'where'   => '{"resource_id":' ~ intval($r.id) ~ '}',
        'sortby'  => 'rank',
        'sortdir' => 'ASC',
        'limit'   => 6,
        'return'  => 'data',
        'tpl'     => '@INLINE {$url}'
    ])}
    {if is_array($rows)}
        {foreach $rows as $row}
            {var $u = $row.url}
            {if $u}
                {var $abs = preg_match('~^https?://~', $u) ? $u : ($url ~ ltrim($u, '/'))}
                {if !in_array($abs, $images)}{set $images[] = $abs}{/if}
            {/if}
        {/foreach}
    {/if}
{/if}

{var $name        = $r.house_namem ?: ($r.longtitle ?: $r.pagetitle)}
{var $description = trim(strip_tags($r.description ?: $r.introtext))}

{var $product = [
    '@context' => 'https://schema.org',
    '@type'    => 'Product',
    '@id'      => $resUrl ~ '#product',
    'name'     => $name,
    'url'      => $resUrl,
    'category' => 'Проекты домов',
    'brand'    => ['@id' => $url ~ '#organization']
]}

{if $description}{set $product['description'] = $description}{/if}
{if $images}{set $product['image'] = count($images) == 1 ? $images.0 : $images}{/if}

{var $sku = $r.house_sku ?: $r.house_name}
{if $sku}{set $product['sku'] = $sku}{/if}

{var $price = floatval($r.house_cost)}
{if $price > 0}
    {var $currency = $r.house_currency ?: 'RUB'}
    {var $availTv  = $r.house_availability ?: 'InStock'}
    {set $product['offers'] = [
        '@type'         => 'Offer',
        'url'           => $resUrl,
        'price'         => strval($price),
        'priceCurrency' => $currency,
        'availability'  => 'https://schema.org/' ~ $availTv,
        'seller'        => ['@id' => $url ~ '#organization']
    ]}
{/if}

{var $props = []}
{var $propMap = [
    'house_size'        => 'Габариты',
    'house_square'      => 'Общая площадь, м²',
    'house_area_living' => 'Жилая площадь, м²',
    'house_floors_upd'  => 'Этажность',
    'house_bedrooms'    => 'Спальни',
    'house_bathrooms'   => 'Санузлы',
    'house_material'    => 'Материал',
    'house_style'       => 'Стиль',
    'built_house_type'  => 'Тип постройки'
]}
{foreach $propMap as $tv => $label}
    {var $val = $r[$tv]}
    {if $val !== null && $val !== ''}
        {set $props[] = [
            '@type' => 'PropertyValue',
            'name'  => $label,
            'value' => $val
        ]}
    {/if}
{/foreach}
{if $props}{set $product['additionalProperty'] = $props}{/if}

{var $ratingVal = $r.house_rating_value}
{var $ratingCnt = intval($r.house_rating_count)}
{if $ratingVal && $ratingCnt > 0}
    {set $product['aggregateRating'] = [
        '@type'       => 'AggregateRating',
        'ratingValue' => strval($ratingVal),
        'reviewCount' => $ratingCnt,
        'bestRating'  => '5',
        'worstRating' => '1'
    ]}
{/if}

<script type="application/ld+json">{$product | json_encode : 320}</script>
