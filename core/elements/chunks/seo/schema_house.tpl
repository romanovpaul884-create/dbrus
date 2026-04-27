{*
  Schema.org Product (с уточнением House) — для страниц проектов домов.

  Сайт продаёт типовые проекты домов, поэтому базовый тип — Product
  (готовый продукт-проект), а технические характеристики дома уходят
  в additionalProperty + связанный @type House через subjectOf.

  Ожидаемые TV:
    house_sku             — артикул проекта (например, BR-120)
    house_image_main      — главное фото (URL/путь)
    house_gallery         — галерея, через перевод строки или JSON-массив URLов
    house_price           — цена в рублях (число)
    house_currency        — валюта (по умолчанию RUB)
    house_availability    — InStock | PreOrder | OutOfStock (по умолчанию InStock)
    house_material        — брус / клеёный брус / каркас / бревно / газобетон…
    house_area_total      — общая площадь, м²
    house_area_living     — жилая площадь, м² (опц.)
    house_floors          — этажность (1, 1.5, 2…)
    house_bedrooms        — количество спален
    house_bathrooms       — количество санузлов
    house_dimensions      — габариты, например "10x12"
    house_rating_value    — средняя оценка (опц.)
    house_rating_count    — количество отзывов (опц.)
*}
{var $r = $_modx->resource}
{var $cfg = $_modx->config}
{var $url = $cfg.site_url}
{var $resUrl = $_modx->makeUrl($r.id, '', '', 'full')}

{var $absolutize = function($path) use ($url) {
    return $path ? (preg_match('~^https?://~', $path) ? $path : ($url ~ ltrim($path, '/'))) : null;
}}

{var $images = []}
{var $main = $absolutize($r.getTVValue('house_image_main'))}
{if $main}{set $images[] = $main}{/if}

{var $gallery = $r.getTVValue('house_gallery')}
{if $gallery}
    {var $list = json_decode($gallery, true)}
    {if !is_array($list)}
        {set $list = preg_split('/\r\n|\r|\n/', trim($gallery))}
    {/if}
    {foreach $list as $g}
        {if is_array($g)}{set $g = $g.image ?: $g.url ?: $g.0}{/if}
        {var $abs = $absolutize(trim($g))}
        {if $abs && !in_array($abs, $images)}{set $images[] = $abs}{/if}
    {/foreach}
{/if}

{var $name = $r.longtitle ?: $r.pagetitle}
{var $description = trim(strip_tags($r.description ?: $r.introtext))}

{var $product = [
    '@context'         => 'https://schema.org',
    '@type'            => 'Product',
    '@id'              => $resUrl ~ '#product',
    'name'             => $name,
    'url'              => $resUrl,
    'category'         => 'Проекты домов',
    'brand'            => ['@id' => $url ~ '#organization']
]}

{if $description}{set $product['description'] = $description}{/if}
{if $images}{set $product['image'] = count($images) == 1 ? $images.0 : $images}{/if}

{var $sku = $r.getTVValue('house_sku')}
{if $sku}{set $product['sku'] = $sku}{/if}

{var $price = $r.getTVValue('house_price')}
{if $price}
    {var $currency = $r.getTVValue('house_currency') ?: 'RUB'}
    {var $availTv = $r.getTVValue('house_availability') ?: 'InStock'}
    {set $product['offers'] = [
        '@type'         => 'Offer',
        'url'           => $resUrl,
        'price'         => (string)(0 + $price),
        'priceCurrency' => $currency,
        'availability'  => 'https://schema.org/' ~ $availTv,
        'seller'        => ['@id' => $url ~ '#organization']
    ]}
{/if}

{var $props = []}
{var $propMap = [
    'house_material'    => 'Материал',
    'house_area_total'  => 'Общая площадь, м²',
    'house_area_living' => 'Жилая площадь, м²',
    'house_floors'      => 'Этажность',
    'house_bedrooms'    => 'Спальни',
    'house_bathrooms'   => 'Санузлы',
    'house_dimensions'  => 'Габариты'
]}
{foreach $propMap as $tv => $label}
    {var $val = $r.getTVValue($tv)}
    {if $val !== null && $val !== ''}
        {set $props[] = [
            '@type' => 'PropertyValue',
            'name'  => $label,
            'value' => $val
        ]}
    {/if}
{/foreach}
{if $props}{set $product['additionalProperty'] = $props}{/if}

{var $ratingVal = $r.getTVValue('house_rating_value')}
{var $ratingCnt = (int)$r.getTVValue('house_rating_count')}
{if $ratingVal && $ratingCnt > 0}
    {set $product['aggregateRating'] = [
        '@type'       => 'AggregateRating',
        'ratingValue' => (string)$ratingVal,
        'reviewCount' => $ratingCnt,
        'bestRating'  => '5',
        'worstRating' => '1'
    ]}
{/if}

<script type="application/ld+json">{$product | json_encode : 320}</script>
