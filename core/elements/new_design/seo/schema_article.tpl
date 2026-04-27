{*
  Schema.org Article.
  Подключается на страницах статей/блога/новостей.

  Ожидаемые TV (создать в MODX-менеджере, секция "Параметры шаблона"):
    article_image          — главное изображение (URL или путь от корня сайта)
    article_image_width    — ширина, px (опц.)
    article_image_height   — высота, px (опц.)
    article_author         — автор (строка)
    article_summary        — краткий анонс (если не использовать introtext)
    article_section        — рубрика (опц.)

  Используются стандартные поля ресурса: pagetitle, longtitle, introtext,
  description, publishedon, editedon, createdon.
*}
{var $r       = $_modx->resource}
{var $cfg     = $_modx->config}
{var $url     = $cfg['site_url']}
{var $lang    = $cfg['cultureKey'] ?: 'ru-RU'}
{var $resUrl  = $_modx->makeUrl($r.id, '', '', 'full')}

{var $img = $r.article_image}
{if $img}
    {set $img = preg_match('~^https?://~', $img) ? $img : ($url ~ ltrim($img, '/'))}
{/if}

{var $headline    = $r.longtitle ?: $r.pagetitle}
{var $description = trim(strip_tags($r.article_summary ?: ($r.description ?: $r.introtext)))}

{var $datePub = $r.publishedon ? date('c', $r.publishedon) : date('c', $r.createdon)}
{var $dateMod = $r.editedon    ? date('c', $r.editedon)    : $datePub}

{var $article = [
    '@context'         => 'https://schema.org',
    '@type'            => 'Article',
    '@id'              => $resUrl ~ '#article',
    'mainEntityOfPage' => ['@type' => 'WebPage', '@id' => $resUrl],
    'headline'         => $headline,
    'datePublished'    => $datePub,
    'dateModified'     => $dateMod,
    'inLanguage'       => $lang,
    'publisher'        => ['@id' => $url ~ '#organization']
]}

{if $description}{set $article['description'] = $description}{/if}

{if $img}
    {var $imgObj = ['@type' => 'ImageObject', 'url' => $img]}
    {var $iw = intval($r.article_image_width)}
    {var $ih = intval($r.article_image_height)}
    {if $iw}{set $imgObj['width']  = $iw}{/if}
    {if $ih}{set $imgObj['height'] = $ih}{/if}
    {set $article['image'] = $imgObj}
{/if}

{var $author = $r.article_author}
{if $author}
    {set $article['author'] = ['@type' => 'Person', 'name' => $author]}
{else}
    {set $article['author'] = ['@id' => $url ~ '#organization']}
{/if}

{var $section = $r.article_section}
{if $section}{set $article['articleSection'] = $section}{/if}

<script type="application/ld+json">{$article | json_encode : 448}</script>
