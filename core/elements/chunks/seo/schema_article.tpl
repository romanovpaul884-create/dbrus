{*
  Schema.org Article.
  Подключается на страницах статей/блога/новостей.

  Ожидаемые TV (создать в MODX-менеджере, секция "Параметры шаблона"):
    article_image          — главное изображение (URL или путь от корня сайта)
    article_image_width    — ширина (опц.)
    article_image_height   — высота (опц.)
    article_author         — автор (строка)
    article_summary        — краткий анонс (если не использовать introtext)
    article_section        — рубрика (опц.)

  Используются стандартные поля ресурса: pagetitle, longtitle, introtext,
  description, publishedon, editedon, createdon.
*}
{var $r = $_modx->resource}
{var $cfg = $_modx->config}
{var $url = $cfg.site_url}
{var $resUrl = $_modx->makeUrl($r.id, '', '', 'full')}

{var $img = $r.getTVValue('article_image')}
{if $img}
    {set $img = preg_match('~^https?://~', $img) ? $img : ($url ~ ltrim($img, '/'))}
{/if}

{var $headline = $r.longtitle ?: $r.pagetitle}
{var $description = $r.getTVValue('article_summary') ?: ($r.description ?: $r.introtext)}
{set $description = trim(strip_tags($description))}

{var $datePub = $r.publishedon ? date('c', $r.publishedon) : date('c', $r.createdon)}
{var $dateMod = $r.editedon ? date('c', $r.editedon) : $datePub}

{var $article = [
    '@context'         => 'https://schema.org',
    '@type'            => 'Article',
    '@id'              => $resUrl ~ '#article',
    'mainEntityOfPage' => ['@type' => 'WebPage', '@id' => $resUrl],
    'headline'         => $headline,
    'datePublished'    => $datePub,
    'dateModified'     => $dateMod,
    'inLanguage'       => 'ru-RU',
    'publisher'        => ['@id' => $url ~ '#organization']
]}

{if $description}{set $article['description'] = $description}{/if}

{if $img}
    {var $imgObj = ['@type' => 'ImageObject', 'url' => $img]}
    {var $iw = (int)$r.getTVValue('article_image_width')}
    {var $ih = (int)$r.getTVValue('article_image_height')}
    {if $iw}{set $imgObj['width'] = $iw}{/if}
    {if $ih}{set $imgObj['height'] = $ih}{/if}
    {set $article['image'] = $imgObj}
{/if}

{var $author = $r.getTVValue('article_author')}
{if $author}
    {set $article['author'] = ['@type' => 'Person', 'name' => $author]}
{else}
    {set $article['author'] = ['@id' => $url ~ '#organization']}
{/if}

{var $section = $r.getTVValue('article_section')}
{if $section}{set $article['articleSection'] = $section}{/if}

<script type="application/ld+json">{$article | json_encode : 320}</script>
